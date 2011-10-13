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
- (void)myTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
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
    
    /*  --------DEBUG LABEL---------*/
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
        self.opponent = opp;
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
    self.containerView.userInteractionEnabled = YES;

    /*  --------DEBUG LABEL---------*/
    [self.containerView addSubview:self.debugLabel];
    
    BookFrontView *bfw = [[BookFrontView alloc] initWithFrame:self.containerView.frame ];
    bfw.viewController = self;
    bfw.backgroundColor = [UIColor clearColor];
    bfw.userInteractionEnabled = YES;
    self.frontView = bfw;
    [self.containerView addSubview:self.frontView];
    
    frontViewIsVisible = YES;
    
    
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




- (void)configButtonSelected:(id)sender 
{
    [self flipCurrentView];    
}

-(void)backButtonSelected:(id)sender
{
    [self flipCurrentView];
}

-(void)deleteButtonSelected:(id)sender
{
    switch ([sender tag]) {
        case 0:
            [self.backView showPopOver];
            [self.backView.deleteButton setSelected:YES];
            break;
        case 1:
            [self.delegate deleteThisBook:self];
            [self.backView.deleteButton setSelected:NO];
            break;
        default:
            break;
    }
    
}

-(void)didDoubleClick
{   NSLog(@"BookViewController : didDoubleClick");
    [self.delegate didSelectBook:self];
}

-(void)didLongPress:(UILongPressGestureRecognizer *)sender
{
   [self.delegate didSelectBook:self];
    
}

-(void)refreshFrontView
{
    [self.frontView refresh];
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



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if(!frontViewIsVisible && self.backView.popOver.alpha == 1.0f)
    {
        [self.backView hidePopOver];
        [self.backView.deleteButton setSelected:NO];
        
    }
}

#pragma mark - TextField Delegate Functions
-(void)textFieldDidBeginEditing:(UITextField *)textField 
{
    self.frontView.nameLabel.alpha = 0.0f;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.frontView.nameLabel.text = textField.text;
    self.frontView.nameLabel.alpha = 1.0f;
    textField.text = @"";
    [textField resignFirstResponder];
    [delegate opponentCreatedWithName:frontView.nameLabel.text by:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
