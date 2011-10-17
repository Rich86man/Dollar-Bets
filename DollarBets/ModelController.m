//
//  ModelController.m
//  PageViewTest
//
//  Created by Richard Kirk on 8/29/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "ModelController.h"
#import "TOCTableViewController.h"
#import "RootViewController.h"
#import "BetPage.h"


/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface ModelController()
@property (strong, nonatomic) NSArray *bets;
@end

@implementation ModelController
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
        NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
        self.bets = [self.opponent.bets sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    
        
        
    }
    return self;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{   
    // Return the data view controller for the given index.
    if ( index > [self.bets count] ) {
        
        Bet * aBet = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:[[self.rvc opponent] managedObjectContext]];
        aBet.opponent = [self.rvc opponent];
        aBet.report = @"Bet Description...";
        aBet.didWin = [NSNumber numberWithInt:2];
        aBet.amount = [NSNumber numberWithInt:1];
        aBet.date = [NSDate date];

        self.bets = [self.bets arrayByAddingObject:aBet];
        
        BetPage *betPage = [[BetPage alloc] initWithBet:aBet]; 
        betPage.delegate = rvc;
        betPage.pageNum =  [NSString stringWithFormat:@"%@/%i",[NSNumber numberWithInt:index],[bets count]];
        return betPage;
    }
    
    if (index == 0)
    {
        TOCTableViewController *toc = [[TOCTableViewController alloc]initWithOpponent:self.opponent];

        toc.delegate = self.rvc;
        return toc;
    }

    BetPage *betPage = [[BetPage alloc] initWithBet:[self.bets objectAtIndex:index -1]]; 
    betPage.delegate = rvc;
    betPage.pageNum =  [NSString stringWithFormat:@"%@/%i",[NSNumber numberWithInt:index],[bets count]];
  //  betPage.view.gestureRecognizers = [[rvc pageViewController] gestureRecognizers];
    
    
   // betPage.scrollView.gestureRecognizers = self.gestureRecognizers;
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
    
    
    if ( [viewController isKindOfClass:[TOCTableViewController class]])
        return 0;
    return [self.bets indexOfObject:[(BetPage *)viewController bet]] + 1;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
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

    if (index > [self.bets count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

@end
