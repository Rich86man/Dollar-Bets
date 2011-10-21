//
//  BetPage.m
//  DollarBets
//
//  Created by Richard Kirk on 9/8/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "BetPage.h"
#import "Opponent.h"
#import "Twitter/Twitter.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#define DEFAULT_KEYBOARD_SIZE 220.0f

@interface BetPage(PrivateMethods)
-(void)setUpMap;
-(void)setUpDollars;
-(void)showOverlay;
-(void)hideOverlay:(NSInteger)duration;
-(void)didTapPage;
-(void)resizeScrollView;
@end

@implementation BetPage

@synthesize bet;
@synthesize scrollView;
@synthesize overlayView;
@synthesize descriptionTextView, amountTextView;
@synthesize titleLabel, dateLabel, amountLabel, pageNumberLabel;
@synthesize photoButton, tweetButton;
@synthesize pageNum;
@synthesize delegate;
@synthesize addNewView;


-(id)initWithBet:(Bet *)aBet asNew:(_Bool)isNew
{
    self = [super init];
    if (self) 
    {
        self.bet = aBet;
        newBet = isNew;
    }
    return self;
}



#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"handmadepaper.png"]];
  //  self.scrollView.backgroundColor = [UIColor clearColor];
    
    
    
    /* Set up Labels */
    self.titleLabel.text = self.bet.opponent.name;
    self.pageNumberLabel.text = self.pageNum;
    [self setUpAmountLabel];
    self.descriptionTextView.text = self.bet.report;
    self.dateLabel.text =  [self.bet.date RKStringFromDate];
    
    /* Check if the Overlay view is currently showing */
    if (self.overlayView.alpha == 0) 
    {
        overlayShowing = NO;
    }
    else
        overlayShowing = YES;
    
    //self.descriptionTextView.contentOffset = CGPointMake(0, 0);
    
    [self resizeScrollView];
    
    /* Set up the buttons */
    if(self.bet.picture)
        [self.photoButton setEnabled:YES];
    else
        [self.photoButton setEnabled:NO];
    
    if([TWTweetComposeViewController canSendTweet])
        [self.tweetButton setEnabled:YES];
    else
        [self.tweetButton setEnabled:NO];
    
    /* Create a tap gesture recognizer to show the overlay */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPage)];
    [tap setNumberOfTapsRequired:1];
    [tap setDelegate:self];
    [self.view addGestureRecognizer:tap];
    
    /* Finally, if dealing with a new page, show the keyboard right away */
    if(newBet)
    {
        UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
        [view setBackgroundColor:[UIColor lightGrayColor]];
        [view setAlpha:0.8f];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height / 2 , 320, 50)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName:HEITI size:25]];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [label setText:@"Tap to edit"];
        [view addSubview:label];
        
        UITapGestureRecognizer *addNewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addNewOverlayTapped)];
        [view addGestureRecognizer:addNewTap];
        self.addNewView = view;
        [self.view addSubview:self.addNewView];
    }
}
- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    [self.delegate betPageWillAppear:self];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewWillDisappear:(BOOL)animated 
{
    
    [self hideOverlay:0.0];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super viewWillDisappear:animated];
}





- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setScrollView:nil];
    [self setDateLabel:nil];
    [self setDescriptionTextView:nil];
    [self setAmountLabel:nil];
    [self setPageNumberLabel:nil];
    [self setPhotoButton:nil];
    [self setTweetButton:nil];
    [self setAmountTextView:nil];
    [self setOverlayView:nil];
    [self setAmountTextView:nil];
    [super viewDidUnload];
}


-(NSString *)description
{
    NSMutableString *desc = [[NSMutableString alloc]init];
    
    [desc appendString:@"Bet Page "];
    [desc appendFormat:@"with index:  %@   ",self.pageNumberLabel.text ];
    [desc appendFormat:@"and bet name : %@ ", self.bet.report];
    return [NSString stringWithString:desc];
}


#pragma mark - Button actions

- (IBAction)backButtonSelected:(id)sender 
{
    [self.delegate didselectBack:self];
}


- (IBAction)editButtonSelected:(id)sender 
{
    editing = YES;
    [self hideOverlay:1.0];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setShowsVerticalScrollIndicator:YES];
    
    
    CGRect frame =  self.scrollView.frame;
    frame.size.height = frame.size.height + self.descriptionTextView.contentSize.height;
    self.scrollView.frame = frame;
    
    [self.descriptionTextView setEditable:YES];
    [self.descriptionTextView becomeFirstResponder];
    [self.delegate didselectEdit:self];
}


- (IBAction)photoButtonSelected:(id)sender 
{
    if(!editing)
        [self.delegate didSelectphoto:self];
}


- (IBAction)tweetButtonSelected:(id)sender 
{
    if (!editing) 
    {
        [self.delegate didSelectTweet:self];
    }
    
}


-(void)doneEditing
{   
    editing = NO;
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self resizeScrollView];
}


#pragma mark - Keyboard Stuff

- (void)keyboardWillShow:(NSNotification *)notification 
{
    
    scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y + self.descriptionTextView.contentSize.height); 
}

-(void)keyboardWillHide:(NSNotification *)notification 
{
    scrollView.contentOffset = CGPointMake(0, 0);
}


#pragma mark - TextView Delegate Functions

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.tag == 0)
    {
        [self.delegate didBeginEditingDescription];
        if (textView.contentSize.height - self.scrollView.contentOffset.y > 38.0f) 
        {
           
            [UIView animateWithDuration:0.1f animations:^{
                self.scrollView.contentOffset = CGPointMake(0, (textView.contentSize.height - 38));
            }];
        }
    }
}


- (void)textViewDidChange:(UITextView *)textView
{    
    if(textView.tag == 0)
    {
        if (textView.contentSize.height != self.scrollView.contentOffset.y ) 
        {
            CGRect frame =  self.scrollView.frame;
            frame.size.height = 460 + self.descriptionTextView.contentSize.height;
            self.scrollView.frame = frame;
            scrollView.contentOffset = CGPointMake(0, self.descriptionTextView.contentSize.height); 
            [UIView animateWithDuration:0.1f animations:^{
                scrollView.contentOffset = CGPointMake(0, self.descriptionTextView.contentSize.height); 
            }];
        }
        if(textView.contentSize.height >= textView.frame.size.height)
        {
            CGRect frame = textView.frame;
            frame.size.height = frame.size.height + 22;
            textView.frame = frame;
        }
    }
    else
    {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc]init];
        self.bet.amount = [nf numberFromString:textView.text];
        [self setUpAmountLabel];
        
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.tag == 0)
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
        
        
        self.descriptionTextView.contentOffset = CGPointMake(0, 0);
        
        if (self.descriptionTextView.contentSize.height > 301)
        {
            CGRect frame = self.scrollView.frame;
            frame.size.height = frame.size.height + (self.descriptionTextView.contentSize.height - 302); 
            self.scrollView.frame = frame;
        }
    }
    
    
}


#pragma mark - UIGesture Delegate Functions

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (editing)
        return NO;
    
    CGPoint touchPoint = [touch locationInView:self.view];
    NSLog(@"%f, %f", touchPoint.x, touchPoint.y);    
    if (touchPoint.x < 220 && touchPoint.x > 100 && ![touch.view isKindOfClass:[UIButton class]]) 
        return YES;
    else 
        return NO;
}


#pragma mark - Overlay Stuff

-(void)didTapPage
{
    
    if (overlayShowing) 
    {
        [self hideOverlay:1.0f];
    }
    else
        [self showOverlay];
    
}


-(void)addNewOverlayTapped
{
    [self.addNewView removeFromSuperview];
    
    [self showOverlay];
    [self.descriptionTextView setEditable:YES];
    [self.descriptionTextView becomeFirstResponder];
    [self.descriptionTextView setText:@""];
    [self.delegate didselectEdit:self];
}


-(void)showOverlay
{
    if(!overlayShowing)
    {
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             [self.overlayView setAlpha:1.0f];
                             
                         }
                         completion:nil];
        
        overlayShowing = YES;
    }
}


-(void)hideOverlay:(NSInteger)duration
{
    if (!duration) 
    {
        duration = 1.0f;
    }
    
    if(overlayShowing)
    {
        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.overlayView setAlpha:0.0f];                             
                         }
                         completion:nil];
        
        overlayShowing = NO;
    }
}


-(void)setUpAmountLabel
{
    UILabel *label = self.amountLabel;
    
    switch ([self.bet.didWin intValue]) {
        case 0:
            label.text = [NSString stringWithFormat:@"- $%i",[self.bet.amount intValue]];
            label.textColor = [UIColor redColor];
            break;
        case 1:
            label.text = [NSString stringWithFormat:@"+ $%i",[self.bet.amount intValue]];
            label.textColor = [UIColor greenColor];
            break;
        case 2:
            label.text = [NSString stringWithFormat:@"-/+ $%i",[self.bet.amount intValue]];
            label.textColor = [UIColor grayColor];
            break;
        default:
            break;
    }
}


-(void)resizeScrollView
{
    /* In case of very long descriptions, move the portion of the scroll view being shown */
    if (descriptionTextView.contentSize.height + descriptionTextView.frame.origin.y > 460)
    {
        CGRect frame = self.scrollView.frame;
        frame.size.height = frame.size.height + (self.descriptionTextView.contentSize.height * 2); 
        self.scrollView.frame = frame;
        [scrollView setContentSize:CGSizeMake(320, scrollView.frame.size.height)];

        [scrollView setScrollEnabled:YES];
    }
    else
    {
        self.scrollView.frame = CGRectMake(0, 0, 320, 460);
        [scrollView setScrollEnabled:NO];
        [scrollView setContentSize:CGSizeMake(0,0)];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
    self.scrollView.contentOffset = scrollView1.contentOffset;
}


/* Possible maps implementation */
/*
 -(void)setUpMap
 {
 if ([self.bet.latitude intValue] == 0 && [self.bet.longitude intValue] == 0)
 {
 self.mapViewCoverUpImageView.alpha = 1;
 self.mapView.alpha = 0;
 }
 else
 {
 self.mapViewCoverUpImageView.alpha = 0;
 self.mapView.alpha = 1;
 }
 
 if (self.bet.latitude)
 {
 MKCoordinateRegion newRegion;
 // newRegion.center.latitude = [self.bet.latitude doubleValue];
 //newRegion.center.longitude = [self.bet.longitude doubleValue];
 newRegion.center.latitude = 37.37;
 newRegion.center.longitude = -96.24;
 newRegion.span.latitudeDelta = 28.49;
 newRegion.span.longitudeDelta = 31.025;    
 [self.mapView setRegion:newRegion animated:NO];
 }
 
 
 
 }
 */



@end
