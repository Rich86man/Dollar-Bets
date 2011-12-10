//
//  ModelController.m
//  PageViewTest
//
//  Created by Richard Kirk on 8/29/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "BookModelController.h"
#import "TOCTableViewController.h"
#import "RootBookViewController.h"
#import "BetPage.h"

#define MPAGE_FRAME CGRectMake(0, 7, 305, 446)

@interface BookModelController()
@property (strong, nonatomic) NSArray *bets;
@end

@implementation BookModelController
@synthesize opponent;
@synthesize bets;
@synthesize controllers;
@synthesize rvc;
@synthesize gestureRecognizers;

- (id)initWithOpponent:(Opponent *)opp
{
    self = [super init];
    if (self) {
        // Create the data model.
        self.opponent = opp;
          
        
        
    }
    return self;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{     
    NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
    self.bets = [self.opponent.bets sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];

    // Return the data view controller for the given index.
    if ( index > [self.bets count] ) 
    {
        BetPage *betPage = [[BetPage alloc] initWithBet:nil asNew:YES]; 
        betPage.delegate = rvc;
        betPage.pageNum =  [NSString stringWithFormat:@"%@/%@",[NSNumber numberWithInt:index],[NSNumber numberWithInt:index]];
        return betPage;
    }
    
    if (index == 0)
    {
        TOCTableViewController *toc = [[TOCTableViewController alloc]initWithOpponent:self.opponent];

        toc.delegate = self.rvc;
        return toc;
    }

    BetPage *betPage = [[BetPage alloc] initWithBet:[self.bets objectAtIndex:index -1] asNew:NO]; 
    betPage.delegate = rvc;
    betPage.pageNum =  [NSString stringWithFormat:@"%@/%i",[NSNumber numberWithInt:index],[bets count]];
  
    return betPage;

    /*
    // Create a new view controller and pass suitable data.
    DataViewController *dataViewController = [[DataViewController alloc] initWithNibName:@"DataViewController" bundle:nil];
    dataViewController.dataObject = [self.pageData objectAtIndex:index];
    return dataViewController;
     */
    
     
    
    
    

}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController
{   
    /*
     Return the index of the given data view controller.
     For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
     */
    
    NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
    self.bets = [self.opponent.bets sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
        
    if ( [viewController isKindOfClass:[TOCTableViewController class]])
        return 0;
    
    if ([(BetPage *)viewController newBet]) {
        return [self.bets count] + 1;
    }
        
    return [self.bets indexOfObject:[(BetPage *)viewController bet]] + 1;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) 
    {
        return nil;
    }
    if(index == 0) 
    {
        return [self.rvc topBook];

    }
    
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController respondsToSelector:@selector(refreshFrontView)]) {
        return [self viewControllerAtIndex:0];
    }
    
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }

    
        index++;

    if (index > [self.bets count] + 1) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

@end
