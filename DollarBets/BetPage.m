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
@synthesize amountLabel;
@synthesize pageNumberLabel;
@synthesize editButton;
@synthesize pageNum;
@synthesize photoButton;
@synthesize tweetButton;

@synthesize delegate;


-(id)initWithBet:(Bet *)aBet
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.bet = aBet;       
    }
    return self;
    
}




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperTile.png"]];
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
    [self setEditButton:nil];
    
    [self setPageNumberLabel:nil];

    [self setPhotoButton:nil];
    [self setTweetButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}







- (IBAction)editButtonSelected:(id)sender 
{
    [self.descriptionTextView setEditable:YES];
    [self.descriptionTextView becomeFirstResponder];
    
    self.editButton.alpha = 0;
    
    [self.delegate didSelectEdit:self];

    
    
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
    if (textView.contentSize.height - self.scrollView.contentOffset.y > 60.0f) {
        
        [UIView animateWithDuration:0.1f animations:^{
            self.scrollView.contentOffset = CGPointMake(0, (textView.contentSize.height - 60));
        }];
    }
    
}


- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"ContentSize w:%f, h:%f",textView.contentSize.width,  textView.contentSize.height);
    NSLog(@"ScrollViewOffset :%@", self.scrollView.contentOffset);
    
    if (textView.contentSize.height - self.scrollView.contentOffset.y > 60.0f) {
       
        [UIView animateWithDuration:0.1f animations:^{
            self.scrollView.contentOffset = CGPointMake(0, (textView.contentSize.height - 60));
        }];
    }
    
    
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
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


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"ScrollViewWillBeginDraggin");
}


@end
