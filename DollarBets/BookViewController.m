//
//  BookViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 8/22/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "BookViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "Opponent.h"
#import "BookFrontView.h"
#import "BookSettingsView.h"

@interface BookViewController(PrivateMethods)
-(void)setup;
@end    

@implementation BookViewController
@synthesize frontView, backView;
@synthesize delegate;
@synthesize opponent;
@synthesize frontViewIsVisible;
@synthesize containerView;

@synthesize debugLabel;


-(void)setup
{
    [self setFrontView:nil];
    [self setBackView:nil];
    [self setContainerView:nil];
    [self setOpponent:nil];
    
    
    UILabel *dl = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 320, 30)];
    dl.font = [UIFont fontWithName:@"STHeitiJ-Light" size:20.0f];
    dl.textAlignment = UITextAlignmentCenter;
    self.debugLabel = dl;
    

}

-(id)initWithOpponent:(Opponent *)opp
{
    if (self = [super init])
    {
        [self setup];
        newBook = NO;
        self.opponent = opp;
    }    
    
    
    return self;
    
}

-(id)initAsAddBook
{
    if (self = [super init])
    {   [self setup];
        newBook = YES;
    }
    
   return self;
}



#pragma mark - View lifecycle
- (void)loadView
{
    [super loadView];
    // Do any additional setup after loading the view from its nib.
    
    UIView *localContainerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.containerView = localContainerView;
    self.containerView.backgroundColor = [UIColor clearColor];
      [self.containerView addSubview:self.debugLabel];
    
    BookFrontView *bfw = [[BookFrontView alloc] initWithFrame:self.containerView.frame asNewBook:newBook];
    bfw.opponent = self.opponent;
    bfw.viewController = self;
    bfw.backgroundColor = [UIColor clearColor];
    

    
    frontViewIsVisible = YES;
  
    self.frontView = bfw;
    [self.containerView addSubview:self.frontView];
    [self.frontView setNeedsLayout];
    
   // self.view = containerView;
    
    
    BookSettingsView *bsw = [[BookSettingsView alloc] initWithFrame:self.containerView.frame];
    bsw.viewController = self;
    bsw.backgroundColor = [UIColor clearColor];
    self.backView = bsw;
    
  
    
    self.view = self.containerView;
    
   
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    NSLog(@"%@: viewDidUnload",[self.debugLabel.text substringToIndex:8] );
    
    [self setFrontView:nil];
    [self setBackView:nil];
    [self setContainerView:nil];
    [self setOpponent:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




-(IBAction)plusSignPressed:(id)sender
{

   
    
    [delegate addNewBook];

    
  
}

-(void)enteredNewOpponentName:(UITextField *)sender
{ 

    
    [delegate opponentCreatedWithName:[sender text] by:self];
    
}

- (IBAction)configButtonPressed:(id)sender 
{
    [self flipCurrentView];    
}

-(void)backButtonSelected:(id)sender
{
    [self flipCurrentView];
}

-(void)deleteButtonSelected:(id)sender
{
    NSLog(@"DeleteButtonSelected:");
        
    [self.delegate deleteThisBook:self];
}
-(void)setDateLabel:(NSDate *)date
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM / DD / YYYY"];
    if(date == nil)
    {
        frontView.dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    }
    else 
    {
        frontView.dateLabel.text = [dateFormatter stringFromDate:date];
    }

}

-(void)showConfigAndDate
{
    [self.frontView showConfigAndDate:nil];
}

- (void)flipCurrentView {

	
	// disable user interaction during the flip
	self.view.userInteractionEnabled = NO;
	
	
	// setup the animation group
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(myTransitionDidStop:finished:context:)];
	
	// swap the views and transition
    if (frontViewIsVisible == YES) 
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];
        [self.frontView removeFromSuperview];
        [self.view addSubview:self.backView];
        
    } 
    else 
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:NO];
        [self.backView removeFromSuperview];
        [self.view addSubview:self.frontView];
    
    }
	[UIView commitAnimations];
	
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(myTransitionDidStop:finished:context:)];
    
	[UIView commitAnimations];
	frontViewIsVisible=!frontViewIsVisible;
}


- (void)myTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    // re-enable user interaction when the flip is completed.
	self.containerView.userInteractionEnabled = YES;
	

}









@end
