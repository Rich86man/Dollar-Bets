//
//  ModelController.m
//  PageViewTest
//
//  Created by Richard Kirk on 8/29/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "ModelController.h"
#import "TOCTableViewController.h"
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
        return nil;
    }
    
    if (index == 0)
    {
        TOCTableViewController *toc = [[TOCTableViewController alloc]initWithNibName:@"TOCTableViewController" bundle:nil];
        toc.opponent = self.opponent;
        return toc;
    }

    BetPage *betPage = [[BetPage alloc] initWithBet:[self.bets objectAtIndex:index -1]];    
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
