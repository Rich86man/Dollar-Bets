//
//  MainViewController.h
//  DollarBets
//
//  Created by Richard Kirk on 8/21/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookViewController.h"
#import "SliderPageControl.h"
@class RootContainerViewController;

@interface MainViewController : UIViewController <UIScrollViewDelegate, BookViewControllerDelegate, SliderPageControlDelegate> {
    UIScrollView *scrollView;
    NSManagedObjectContext *context;
    NSMutableArray *opponents;
    NSMutableArray *books;
    RootContainerViewController *parent;
    SliderPageControl *sliderPageControl;
    bool pageControlUsed;
    
}
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *opponents;
@property (strong, nonatomic) NSMutableArray *books;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) RootContainerViewController *parent;
@property (strong, nonatomic) SliderPageControl *sliderPageControl;

/* MainViewController Funtions */
-(id)initWithManagedObjectContext:(NSManagedObjectContext *)cntxt;
-(void)resizeScrollView;

/* Managed Object Functions */
-(NSMutableArray *)retrieveOpponents;
-(bool)deleteOpponent:(Opponent *)opp;

/*Slider Page Control Helper Functions*/
-(void)slideToCurrentPage:(bool)animated;
-(void)changeToPage:(int)page animated:(BOOL)animated;
-(void)setupSlider;


@end
