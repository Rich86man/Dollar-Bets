//
//  ModelController.m
//  PageViewTest
//
//  Created by Richard Kirk on 8/29/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "ModelController.h"
#import "TableOfContents.h"
#import "DataViewController.h"



/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface ModelController()
@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation ModelController
@synthesize opponent;
@synthesize pageData = _pageData;

- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model.
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        _pageData = [[dateFormatter monthSymbols] copy];
    }
    return self;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{   
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    if (index == 0)
    {
        TableOfContents *toc = [[TableOfContents alloc]init];
        toc.opponent = self.opponent;
        return toc;
    }
    
    
    // Create a new view controller and pass suitable data.
    DataViewController *dataViewController = [[DataViewController alloc] initWithNibName:@"DataViewController" bundle:nil];
    dataViewController.dataObject = [self.pageData objectAtIndex:index];
    
    
     
    
    
    
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController
{   
    /*
     Return the index of the given data view controller.
     For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
     */
    if ([viewController isKindOfClass:[TableOfContents class]])
    {
        return 0;
    }
    return [self.pageData indexOfObject:[(DataViewController *)viewController dataObject]];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

@end
