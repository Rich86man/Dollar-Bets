//
//  BookController.m
//  DollarBets
//
//  Created by Richard Kirk on 10/15/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "BookController.h"
#import "Bet.h"
#import "Opponent.h"
#import "BetPage.h"
#import "TOCTableViewController.h"
#import "BookViewController.h"


@implementation BookController
@synthesize bookDelegate;

@synthesize bets,controllers;
@synthesize topPage;


-(id)initWithTopPage:(BookViewController *)tp{
    

    
    BookController *bc = [[BookController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    bc.dataSource = bc;
    bc.delegate = bc;
    bc.topPage = tp;
    
    return bc;

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch 
{
    gestureRecognizer locationInView:<#(UIView *)#>
    
    if (touch.view.tag == 10)
    {
        return NO;
    }
    return YES;
}


-(void)disablePageViewGestures:(_Bool)disable   
{
    if(disable)
    {NSLog(@"Disabling Gestures");
        for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
            if([gesture isEnabled])
                [gesture setEnabled:NO];
        }
        
        
    }
    else if(!disable)
    {NSLog(@"Enabling Gestures");
        for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
            if(![gesture isEnabled])
                [gesture setEnabled:YES];
        }
        
        
        
    }
    
}


#pragma mark - PageView Helper Functions
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{   
    // Return the data view controller for the given index.
    
    NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
    self.bets = [self.topPage.opponent.bets sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];

    if ( index > [self.bets count] ) {
        
        Bet * aBet = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:[[self.topPage opponent] managedObjectContext]];
        aBet.opponent = [self.topPage opponent];
        aBet.report = @"Bet Description...";
        aBet.didWin = [NSNumber numberWithInt:2];
        aBet.amount = [NSNumber numberWithInt:1];
        aBet.date = [NSDate date];
        
        self.bets = [self.bets arrayByAddingObject:aBet];
        
        BetPage *betPage = [[BetPage alloc] initWithBet:aBet]; 
        betPage.delegate = bookDelegate;
        betPage.pageNum =  [NSString stringWithFormat:@"%@/%i",[NSNumber numberWithInt:index],[bets count]];
        return betPage;
    }
    
    if (index == 0)
    {
        TOCTableViewController *toc = [[TOCTableViewController alloc]initWithOpponent:[self.topPage opponent]];
        toc.delegate = self.bookDelegate;
        return toc;
    }
    
    BetPage *betPage = [[BetPage alloc] initWithBet:[self.bets objectAtIndex:index -1]]; 
    betPage.delegate = bookDelegate;
    betPage.pageNum =  [NSString stringWithFormat:@"%@/%i",[NSNumber numberWithInt:index],[bets count]];
    
    

    return betPage;
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController
{   

    if ( [viewController isKindOfClass:[TOCTableViewController class]])
        return 0;
    return [self.bets indexOfObject:[(BetPage *)viewController bet]] + 1;
}

- (UIViewController *) currentPage
{
      return (UIViewController *)[self.viewControllers objectAtIndex:0];
}
#pragma mark - UIPageViewController delegate methods

/*
 - (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
 {
 
 
 }
 */

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentViewController = [self.viewControllers objectAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
    
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    self.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

-(void)flipToPage:(int)page animated:(_Bool)animated
{
    UIViewController *selectedPage = [self viewControllerAtIndex:page];
    NSArray *viewControllers = [NSArray arrayWithObject:selectedPage];
    
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:animated completion:NULL];
    
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


-(void)openBook
{
    NSArray *viewControllers = [NSArray arrayWithObjects:self.topPage,nil];
    
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    
    UIViewController *startingViewController = [self viewControllerAtIndex:0];
    [self setViewControllers:[NSArray arrayWithObject:startingViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

}

-(void)closeBook
{
    topPage.view.frame = CGRectMake(0, 0, 320, 460);
    
    NSArray *viewControllers = [NSArray arrayWithObject:self.topPage];
    
    
    [self setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:NO
                                     completion:^(BOOL finished){    [self.bookDelegate bookClosed];
                                     }];
}



@end
