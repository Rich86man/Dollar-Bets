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


#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
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
    [self.view addSubview:self.mainViewController.view];
    
}


-(void)OpenBook:(BookViewController *)book
{
    aFrame = book.view.frame;
    NSLog(@"RootContainerViewController : OpenBookWithOpponent:");
    NSLog(@"frame(%f, %f, %f, %f)",book.view.frame.origin.x, book.view.frame.origin.y, book.view.frame.size.height, book.view.frame.size.width);

    self.rootViewController = [[RootBookViewController alloc] init];
    self.rootViewController.delegate = self;

    
    
    [UIView animateWithDuration:0.7f 
                          delay:0.0f 
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         book.frontView.transform = CGAffineTransformMakeScale(1.8f, 1.8f);
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
    


    [UIView transitionWithView:self.view duration:0.1f options:UIViewAnimationOptionTransitionNone animations:^{
        [self.view addSubview:self.mainViewController.view];
        //  [book refreshFrontView];
        
    } completion:^(BOOL finished){
        
        [self.rootViewController.view removeFromSuperview];
        
        
        [UIView animateWithDuration:0.7f 
                              delay:0.0f 
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             book.frontView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         }completion:nil];

        
        
    }];


    NSLog(@"frame(%f, %f, %f, %f)",book.view.frame.origin.x, book.view.frame.origin.y, book.view.frame.size.height, book.view.frame.size.width);
}










- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
