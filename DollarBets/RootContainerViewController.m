//
//  RootContainerViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 8/29/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "RootContainerViewController.h"
#import "MainViewController.h"
#import "BookViewController.h"
#import "BookFrontView.h"

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
    containerView.backgroundColor = [UIColor clearColor];
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

-(void)OpenBook:(BookViewController *)book
{
    aFrame = book.view.frame;
    NSLog(@"RootContainerViewController : OpenBookWithOpponent:");
    NSLog(@"frame(%f, %f, %f, %f)",book.view.frame.origin.x, book.view.frame.origin.y, book.view.frame.size.height, book.view.frame.size.width);

    self.rootViewController = [[RootViewController alloc] init];
    self.rootViewController.delegate = self;
    
   //  [book.view setAutoresizingMask:UIViewAutoresizingNone];
    
    [UIView animateWithDuration:1.0f 
                          delay:0.0f 
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         book.frontView.transform = CGAffineTransformMakeScale(1.4f, 1.4f);
                     }
                     completion:^(BOOL finished){  
                         [book.view removeFromSuperview];
                        
                         
                         self.rootViewController.topBook = book;
                         
                         
                         [UIView transitionWithView:self.view duration:0.5f options:UIViewAnimationOptionTransitionNone animations:^{
                             [self.view addSubview:self.rootViewController.view];
                             
                         } 
                                         completion:^(BOOL finished){    [self.mainViewController.view removeFromSuperview];
                                         }
                          ];
                         
                     }];  
    
    
    
    NSLog(@"frame(%f, %f, %f, %f)",book.view.frame.origin.x, book.view.frame.origin.y, book.view.frame.size.height, book.view.frame.size.width);
    
}






-(void)closeBook:(BookViewController *)book
{   
    NSLog(@"frame(%f, %f, %f, %f)",book.view.frame.origin.x, book.view.frame.origin.y, book.view.frame.size.height, book.view.frame.size.width);
    
    
    [book.view removeFromSuperview];
    [book removeFromParentViewController];
    book.view.frame = aFrame;
    [self.mainViewController.bookScrollView addSubview:book.view];
    


    [UIView transitionWithView:self.view duration:0.5f options:UIViewAnimationOptionTransitionNone animations:^{
        [self.view addSubview:self.mainViewController.view];
        //  [book refreshFrontView];
        
    } completion:^(BOOL finished){
        
        [self.rootViewController.view removeFromSuperview];
        
        
        [UIView animateWithDuration:1.0f 
                              delay:0.0f 
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             book.frontView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         }completion:nil];

        
        
    }];

    /*
    
    [UIView animateWithDuration:1.0f 
                          delay:0.0f 
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         book.frontView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                     }
                     completion:^(BOOL finished){  
                         [book.view removeFromSuperview];
                         [book removeFromParentViewController];
                         book.view.frame = aFrame;
                         [self.mainViewController.bookScrollView addSubview:book.view];
                         
                         [self.rootViewController.view removeFromSuperview];
                         [UIView transitionWithView:self.view duration:0.5f options:UIViewAnimationOptionTransitionNone animations:^{
                             [self.view addSubview:self.mainViewController.view];
                           //  [book refreshFrontView];
                             
                         } completion:^(BOOL finished){}];
                     }];
    
    */
    NSLog(@"frame(%f, %f, %f, %f)",book.view.frame.origin.x, book.view.frame.origin.y, book.view.frame.size.height, book.view.frame.size.width);
}










- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
