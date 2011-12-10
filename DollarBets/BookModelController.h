//
//  ModelController.h
//  PageViewTest
//
//  Created by Richard Kirk on 8/29/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Opponent.h"

@class DataViewController;

@interface BookModelController : NSObject <UIPageViewControllerDataSource>
{
    Opponent *opponent;
    NSMutableArray *controllers;
    NSArray *gestureRecognizers;
}
@property (strong, nonatomic)Opponent *opponent;
@property (strong, nonatomic)NSMutableArray *controllers;
@property (assign) id rvc;
@property (strong, nonatomic)NSArray *gestureRecognizers;

-(id)initWithOpponent:(Opponent *)opp;

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfViewController:(UIViewController *)viewController;
@end
