//
//  MainViewController.h
//  DollarBets
//
//  Created by Richard Kirk on 8/21/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookViewController.h"

@interface MainViewController : UIViewController <UIScrollViewDelegate, BookViewControllerDelegate> {
    UIScrollView *mainScrollView;
    NSMutableArray *books;
    UIPageControl *pageControl;
    bool pageControlUsed;
    NSManagedObjectContext *context;
    
    NSArray *opponents;
    
    
}

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *books;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *opponents;



-(id)initWithManagedObjectContext:(NSManagedObjectContext *)cntxt;
-(void)addNewBook;
-(void)retrieveOpponents;
-(void)resizeScrollView;
-(void)removeBook;
-(bool)deleteOpponent:(Opponent *)opp;



@end
