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



-(void)setup
{
    [self setFrontView:nil];
    [self setBackView:nil];
    [self setContainerView:nil];
    [self setOpponent:nil];
    
    
    UIView *localContainerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.containerView = localContainerView;
    
    self.view = self.containerView;
    

}

-(id)initWithOpponent:(Opponent *)opp
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        [self setup];
        newBook = NO;
        self.opponent = opp;
    }    
    
    
    return self;
    
}

-(id)initAsAddBook
{
    if (self = [super initWithNibName:nil bundle:nil])
    {   [self setup];
        newBook = YES;
    }
    
   return self;
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *localContainerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.containerView = localContainerView;

    BookFrontView *bfw = [[BookFrontView alloc] initWithFrame:self.containerView.frame asNewBook:newBook];
    bfw.viewController = self;
    self.frontView = bfw;
    [self.containerView addSubview:self.frontView];
    
   // self.view = containerView;
    
    
    BookSettingsView *bsw = [[BookSettingsView alloc] initWithFrame:self.containerView.frame];
    bsw.viewController = self;
    
    
    

}



- (void)viewDidUnload
{
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

-(IBAction)enteredNewOpponentName:(UITextField *)sender
{ 

    
    [delegate opponentCreatedWithName:[sender text]];
    
}

- (IBAction)configButtonPressed:(id)sender 
{
    [self flipCurrentView];    
      
      

    

}

-(void)deleteButtonSelected
{
    NSLog(@"DeleteButtonSelected:");
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
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    } 
    else 
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
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
	containerView.userInteractionEnabled = YES;
	

}









@end
