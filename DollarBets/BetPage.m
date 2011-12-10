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
#import "RootBookViewController.h"
#import "DollarBetsAppDelegate.h"
#import "RKPaperView.h"

#define DEFAULT_KEYBOARD_HEIGHT 214.0f
#define KEYBOARD_ADDON_HEIGHT 44
#define PAGE_BOTTOM_PADDING 20


@interface BetPage(PrivateMethods)
-(void)showOverlay;
-(void)hideOverlay:(NSInteger)duration;
-(void)didTapPage;
-(void)resizeScrollView;
-(void)resizeDescription;
@end

@implementation BetPage

@synthesize bet;
@synthesize scrollView;
@synthesize overlayStatusBar;
@synthesize overlayBottom;
@synthesize descriptionTextView, amountTextView;
@synthesize titleLabel, dateLabel, amountLabel, pageNumberLabel;
@synthesize photoButton, tweetButton;
@synthesize pageNum;
@synthesize delegate;
@synthesize addNewView;
@synthesize paperView;
@synthesize newBet;

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
    
    if(!newBet)
    {
        /* Set up Labels */
        self.titleLabel.text = self.bet.opponent.name;
        self.pageNumberLabel.text = self.pageNum;
        [self setUpAmountLabel];
        self.descriptionTextView.text = self.bet.report;
        self.dateLabel.text =  [self.bet.date RKStringFromDate];
        
        /* Set up the buttons */
        if(self.bet.picture)
            [self.photoButton setEnabled:YES];
        else
            [self.photoButton setEnabled:NO];
        self.addNewView.alpha = 0;
        
        
        [self resizeDescription];    
        [self resizeScrollView];

    }
    else
    {
        /* Set up Labels */
        self.titleLabel.text = [[self.delegate opponent] name];
        self.pageNumberLabel.text = self.pageNum;
               
        self.photoButton.alpha = 0;
        self.tweetButton.alpha = 0;
        self.amountLabel.alpha = 0;
        self.descriptionTextView.alpha = 0;
        

        
        /* set Up the addnw overlay */
        self.addNewView.alpha = 1.0f;
        self.addNewView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        UIButton *addNewButton = (UIButton *)[[self.addNewView subviews] objectAtIndex:0];
        
        [UIView animateWithDuration:1.0 
                              delay:0 
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{ 
                             addNewButton.imageView.alpha = 0.1f;
                             addNewButton.imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                         }    
                         completion:nil]; 
    }
    
    
    
    /* Check if the Overlay view is currently showing */
    if (self.overlayStatusBar.alpha == 0) 
    {
        overlayShowing = NO;
    }
    else
        overlayShowing = YES;
    
    if([TWTweetComposeViewController canSendTweet])
        [self.tweetButton setEnabled:YES];
    else
        [self.tweetButton setEnabled:NO];
    
    /* Create a tap gesture recognizer to show the overlay */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPage)];
    [tap setNumberOfTapsRequired:1];
    [tap setDelegate:self];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *amountLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapAmountLabel)];
    [self.amountLabel addGestureRecognizer:amountLabelTap];
    
    self.scrollView.contentOffset = CGPointZero;

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
    editing = NO;
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
    [self setOverlayStatusBar:nil];
    [self setAmountTextView:nil];
    [self setPaperView:nil];
    [self setOverlayBottom:nil];
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
    [UIView animateWithDuration:0.3 animations:^{
     scrollView.contentOffset = CGPointMake(0, self.descriptionTextView.frame.origin.y - 40);
    }];
   
    [self.scrollView setScrollEnabled:YES];
    
    
    
    [self.descriptionTextView setEditable:YES];
    [self.descriptionTextView setUserInteractionEnabled:YES];
    [self.descriptionTextView becomeFirstResponder];
    [self.delegate didselectEdit:self];
}


- (IBAction)photoButtonSelected:(id)sender 
{
    if(editing)
        [self.delegate changeEditStateTo:2];
    else
        [self.delegate didSelectphoto:self];
}


- (IBAction)tweetButtonSelected:(id)sender 
{
    if (!editing) 
        [self.delegate didSelectTweet:self];
    
}


-(void)doneEditing
{   
    editing = NO;
    [self.descriptionTextView setEditable:NO];
    [self.descriptionTextView setUserInteractionEnabled:NO];
    [self resizeScrollView];
}


#pragma mark - Keyboard Stuff

- (void)keyboardWillShow:(NSNotification *)notification 
{
    [self resizeScrollView];
}

-(void)keyboardWillHide:(NSNotification *)notification 
{

}


#pragma mark - TextView Delegate Functions

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.tag == 0)
    {
        [self.delegate didBeginEditingDescription];
        if ([textView.text isEqualToString:@"Description..."]) {
            textView.text = @"";
        }
        [self resizeDescription];
    
    }
}


- (void)textViewDidChange:(UITextView *)textView
{    
    if(textView.tag == 0)
    {
        [self resizeDescription];
    }
    else
    {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc]init];
        NSNumber *newAmount = [nf numberFromString:textView.text]; 
        
        if([newAmount intValue] < 101 && [newAmount intValue] >= 0)
        {
            self.bet.amount = newAmount;
            [self setUpAmountLabel];
        }
        
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.tag == 0)
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
    }
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView.tag == 1)
    {
        if (range.length > 2 || range.location > 2)
            return NO;
        else 
            return YES;
    }
    
    return YES;
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


-(void)addNewOverlayButtonTapped
{
    [self.addNewView removeFromSuperview];
    
    Bet *realBet = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:[[self.delegate opponent] managedObjectContext]]; 
    realBet.opponent = [self.delegate opponent];
    realBet.amount = [NSNumber numberWithInt:1];
    realBet.date = [NSDate date];
    realBet.didWin = [NSNumber numberWithInt:2];
    realBet.report = @"";
    self.bet = realBet;
    
    [self.bet save];
    
    [self setUpAmountLabel];
    self.dateLabel.text =  [self.bet.date RKStringFromDate];
    
    /* Set up the buttons */
    if(self.bet.picture)
        [self.photoButton setEnabled:YES];
    else
        [self.photoButton setEnabled:NO];
    self.addNewView.alpha = 0;
    
    self.photoButton.alpha = 1;
    self.tweetButton.alpha = 1;
    self.amountLabel.alpha = 1;
    self.descriptionTextView.alpha = 1;
    
    
    [self resizeDescription];    
    [self resizeScrollView];
        
    self.newBet = NO;
    [self showOverlay];
    [self.descriptionTextView setEditable:YES];
    [self.descriptionTextView becomeFirstResponder];
    [self.descriptionTextView setText:@"Description..."];
    [self.delegate didselectEdit:self];
}


-(void)showOverlay
{
    if(!overlayShowing)
    {
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             [self.overlayStatusBar setAlpha:1.0f];
                             [self.overlayBottom setAlpha:1.0f];
                             
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
                             [self.overlayStatusBar setAlpha:0.0f];
                                                          [self.overlayBottom setAlpha:0.0f];
                         }
                         completion:nil];
        
        overlayShowing = NO;
    }
}


-(void)setUpAmountLabel
{
    UILabel *label = self.amountLabel;
    
    if (!newBet)
    {
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
    else
    {
        label.text = @"-/+1";
        label.textColor = [UIColor grayColor];
    }
}

-(void)resizeDescription
{
    /* handle expanding the textview and then resize the scrollview */
    if(self.descriptionTextView.contentSize.height > self.descriptionTextView.frame.size.height)
    {   
        CGRect frame = self.descriptionTextView.frame;
        frame.size.height = self.descriptionTextView.contentSize.height;
        self.descriptionTextView.frame = frame;
        
        if (descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height > self.scrollView.contentSize.height) 
        {
            [self resizeScrollView];
        }
    }
    
    
    /* Handle when a user types too much and the text is hidden by the keyboard */
    int textViewBottomPoint = self.descriptionTextView.frame.origin.y + self.descriptionTextView.contentSize.height;
    int visibleArea = self.view.frame.size.height - (DEFAULT_KEYBOARD_HEIGHT + KEYBOARD_ADDON_HEIGHT);
    int visibleAreaBottomPoint = visibleArea + self.scrollView.contentOffset.y;
    
    if( textViewBottomPoint > visibleAreaBottomPoint)
    {
        CGPoint offsetPoint = CGPointMake(0, textViewBottomPoint - visibleArea);
        self.scrollView.contentOffset = offsetPoint;
    }

}

-(void)resizeScrollView
{
    if(editing)
    {
        CGSize content = CGSizeMake(self.view.frame.size.width, self.descriptionTextView.frame.origin.y + self.descriptionTextView.contentSize.height);
        [self.scrollView setScrollEnabled:YES];
        
        /* In case of very long descriptions, allow the user to scroll */
        if(content.height > self.scrollView.frame.size.height)
        {
            content.height = content.height + DEFAULT_KEYBOARD_HEIGHT;
            self.scrollView.contentSize = content ;
            
            CGRect frame = self.paperView.frame;
            frame.size.height = content.height + PAGE_BOTTOM_PADDING;
            self.paperView.frame = frame;
            
        }
        else
        {
            content.height = self.scrollView.frame.size.height + DEFAULT_KEYBOARD_HEIGHT;
            self.scrollView.contentSize = content ;
            
            CGRect frame = self.paperView.frame;
            frame.size.height = content.height + PAGE_BOTTOM_PADDING;
            self.paperView.frame = frame;
        }
        
        
        
    }
    else
    {
        CGSize content = CGSizeMake(0, self.descriptionTextView.frame.origin.y + self.descriptionTextView.contentSize.height);
        self.scrollView.contentSize = content;

        /* In case of very long descriptions, allow the user to scroll */
        if(content.height > self.scrollView.frame.size.height)
        {
            [self.scrollView setScrollEnabled:YES];
            
            CGRect frame = self.paperView.frame;
            frame.size.height = content.height + PAGE_BOTTOM_PADDING;
            self.paperView.frame = frame;
            
        }
        else
        {
            [self.scrollView setScrollEnabled:NO];
            self.paperView.frame = self.scrollView.frame;
        }

    }
    
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static int defaultHeight = 208;
    CGRect frame = self.descriptionTextView.frame;
    
    frame.size.height = defaultHeight + self.scrollView.contentOffset.y;
    
    self.descriptionTextView.frame = frame;
}



-(void)didTapAmountLabel
{   
    if (editing)
        [self.delegate changeEditStateTo:1];
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
