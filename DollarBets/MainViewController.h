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

@interface MainViewController : UI ViewController <UIScrollViewDelegate, BookViewControllerDelegate, SliderPageControlDelegate> {
    UIScrollView *mainScrollView;
    NSManagedObjectContext *context;
    NSMutableArray *opponents;
    NSMutableArray *books;
    RootContainerViewController *parent;
    SliderPageControl *sliderPageControl;
    bool pageControlUsed;
    
}

@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) NSMutableArray *opponents;
@property (strong, nonatomic) NSMutableArray *books;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) RootContainerViewController *parent;
@property (strong, nonatomic) SliderPageControl *sliderPageControl;

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)cntxt;

-(NSMutableArray *)retrieveOpponents;
-(void)resizeScrollView;
-(bool)deleteOpponent:(Opponent *)opp;


- (void)slideToCurrentPage:(bool)animated;
- (void)changeToPage:(int)page animated:(BOOL)animated;


@end
