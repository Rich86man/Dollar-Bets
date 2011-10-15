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





@end

@implementation BetPage

@synthesize bet;
@synthesize scrollView;
@synthesize titleLabel;
@synthesize dateLabel;
@synthesize descriptionTextView;
@synthesize amountTextView;
@synthesize amountLabel;
@synthesize pageNumberLabel;

@synthesize pageNum;
@synthesize photoButton;
@synthesize tweetButton;
@synthesize gestureView;
@synthesize gestureViewTwo;
@synthesize delegate;


-(id)initWithBet:(Bet *)aBet
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.bet = aBet;      
        newBet = NO;
        if ([self.bet.report isEqualToString:@"Bet Description..."])
        {
            newBet = YES;
        }
    }
    return self;
    
}

-(id)initAsNewWithOpponent:(Opponent *)opp
{   self = [super init];
    if (self) {
        newBet = YES;

    }
    return self;
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PaperBackround.png"]];
    self.titleLabel.text = self.bet.opponent.name;
    
    self.pageNumberLabel.text = self.pageNum;
    
    [self setUpAmountLabel];
    
    
    self.descriptionTextView.text = self.bet.report;
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init ];
    
    [df setDateStyle:NSDateFormatterMediumStyle];
    
    self.dateLabel.text = [df stringFromDate:self.bet.date];
    
    self.descriptionTextView.contentOffset = CGPointMake(0, 0);
    
    
    if (self.descriptionTextView.contentSize.height > 301)
    {
        CGRect frame = self.scrollView.frame;
        frame.size.height = frame.size.height + (self.descriptionTextView.contentSize.height );//- 302); 
        self.scrollView.frame = frame;
    }
    
    if(self.bet.picture)
        [self.photoButton setEnabled:YES];
    else
        [self.photoButton setEnabled:NO];
    
    if([TWTweetComposeViewController canSendTweet])
        [self.tweetButton setEnabled:YES];
    else
        [self.tweetButton setEnabled:NO];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPage)];
    [tap setNumberOfTapsRequired:1];
    
    //   [self.gestureView setGestureRecognizers:[NSArray arrayWithObject:tap]];
    // [self.scrollView addGestureRecognizer:tap];
    [self.gestureView addGestureRecognizer:tap];
    [self.gestureViewTwo addGestureRecognizer:tap];
    if(newBet)
    {
        [self.delegate didTapPage:self];
        [self.delegate betPageEditButtonSelected:nil];
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

-(NSString *)description
{
    NSMutableString *desc = [[NSMutableString alloc]init];
    
    [desc appendString:@"Bet Page "];
    [desc appendFormat:@"with index:  %@   ",self.pageNumberLabel.text ];
    [desc appendFormat:@"and bet name : %@ ", self.bet.report];
    return [NSString stringWithString:desc];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [self.delegate betPageWillAppear:self];    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.delegate hideBetPageOverlay:0.0];
}

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


/*
 -(void)setUpDollars
 {
 int betAmount = [self.bet.amount intValue];
 if(betAmount == 1)
 {
 self.dollarImageView.image = [UIImage imageNamed:@"oneDollar.png"];
 }
 else if(betAmount == 5)
 {
 self.dollarImageView.image = [UIImage imageNamed:@"fiveDollar.png"];
 }
 else
 self.dollarImageView.alpha = 0;
 
 
 }
 */

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
    [self setGestureView:nil];
    [self setGestureViewTwo:nil];
    [self setAmountTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}







- (void)editButtonSelected
{
    
    [self.descriptionTextView setEditable:YES];
    [self.descriptionTextView becomeFirstResponder];
}

- (IBAction)photoButtonSelected:(id)sender 
{
    [self.delegate didSelectphoto:self];
}

- (IBAction)tweetButtonSelected:(id)sender 
{
    [self.delegate didSelectTweet:self];
}

#pragma mark - TextViewDelegateFunctions
/*
 - (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
 - (BOOL)textViewShouldEndEditing:(UITextView *)textView;
 
 
 
 
 - (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
 - (void)textViewDidChangeSelection:(UITextView *)textView;
 
 */

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.tag == 0)
    {
        if (textView.contentSize.height - self.scrollView.contentOffset.y > 38.0f) {
            
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
        if (textView.contentSize.height - self.scrollView.contentOffset.y > 38.0f) {
            
            [UIView animateWithDuration:0.1f animations:^{
                self.scrollView.contentOffset = CGPointMake(0, (textView.contentSize.height - 38));
            }];
        }
    }
    else
    {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc]init];
        self.bet.amount = [nf numberFromString:self.amountTextView.text];
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch 
{
    
    
    
    if (touch.view == self.photoButton) {
        
        return NO;
    }
    return YES;
}

#pragma mark - TextFieldDelegate 
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    NSSet *arr = [event touchesForView:self.photoButton];
    
    if ([arr count] == 0)
        [super touchesBegan:touches withEvent:event];
}



-(void)didTapPage
{
    
    
    [self.delegate didTapPage:self];
    NSLog(@"did Tap Page");
    
}


@end
