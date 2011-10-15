//
//  BookController.h
//  DollarBets
//
//  Created by Richard Kirk on 10/15/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opponent.h"
#import "BookViewController.h"
@protocol BookControllerDelegate <NSObject>
-(void)bookClosed;
@end

@interface BookController : UIPageViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
{
    Opponent *opponent;
    NSMutableArray *controllers;
    NSArray *bets;
    int pageNumber;
    BookViewController *topPage;
}

@property (assign) id <BookControllerDelegate> bookDelegate;
@property (strong, nonatomic) BookViewController *topPage;
@property (strong, nonatomic)NSMutableArray *controllers;
@property (strong,nonatomic) NSArray *bets;


-(id) initWithTopPage:(BookViewController *)tp;

-(UIViewController *)currentPage;
-(UIViewController *)viewControllerAtIndex:(NSUInteger)index;
-(NSUInteger)indexOfViewController:(UIViewController *)viewController;

-(void)disablePageViewGestures:(_Bool)disable;
-(void)flipToPage:(int)page animated:(bool)animated;

-(void)openBook;
-(void)closeBook;

@end

