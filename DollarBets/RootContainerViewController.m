//
//  RootContainerViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 8/29/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "RootContainerViewController.h"
#import "MainViewController.h"

@implementation RootContainerViewController
@synthesize context = _context;
@synthesize mainViewController, rootViewController;



-(id)initWithManagedObjectContext:(NSManagedObjectContext *)cntxt
{
    self = [super init];
    if (self) {
        self.context = cntxt;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *containerView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    containerView.backgroundColor = [UIColor blueColor];
    [containerView setUserInteractionEnabled:YES];
    self.view = containerView;
    
   
    
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.mainViewController = [[MainViewController alloc] initWithManagedObjectContext:self.context];
    self.mainViewController.parent = self;
  //  [self addChildViewController:self.mainViewController];
    [self.view addSubview:self.mainViewController.view];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)OpenBookWithOpponent:(Opponent *)opp
{
    NSLog(@"RootContainerViewController : OpenBookWithOpponent:");

    self.rootViewController = [[RootViewController alloc] init];
    self.rootViewController.opponent = opp;
    
    
//    [UIView transitionFromView:self.mainViewController.view toView:self.rootViewController.view duration:0.5f options:UIViewAnimationTransitionFlipFromLeft completion:nil];
    
      
    
    [UIView transitionWithView:self.view duration:0.5f options:UIViewAnimationOptionTransitionCurlUp animations:^{
        [self.view addSubview:self.rootViewController.view];

    } completion:nil];
    
    
    [self.mainViewController.view removeFromSuperview];
    
}

















- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
