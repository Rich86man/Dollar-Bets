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

@interface MainViewController : UIViewController <UIScrollViewDelegate, BookViewControllerDelegate, SliderPageControlDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate> {
    UIScrollView *bookScrollView;
    NSManagedObjectContext *context;
    NSArray *opponents;
    NSMutableArray *books;
    RootContainerViewController *parent;
    SliderPageControl *sliderPageControl;
    bool pageControlUsed;
    
}
@property (strong, nonatomic) UIScrollView *bookScrollView;
@property (strong, nonatomic) NSArray *opponents;
@property (strong, nonatomic) NSMutableArray *books;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) RootContainerViewController *parent;
@property (strong, nonatomic) SliderPageControl *sliderPageControl;

/* MainViewController Funtions */
-(id)initWithManagedObjectContext:(NSManagedObjectContext *)cntxt;
-(void)resizeScrollView;

/*Slider Page Control Helper Functions*/
-(void)slideToCurrentPage:(bool)animated;
-(void)changeToPage:(int)page animated:(BOOL)animated;
-(void)setupSlider;
-(void)loadScrollViewWithPage:(int)page;
-(void)reloadBooks;
@end
