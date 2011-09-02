//
//  MainViewController.h
//  DollarBets
//
//  Created by Richard Kirk on 8/21/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookViewController.h"
@class RootContainerViewController;

@interface MainViewController : UIViewController <UIScrollViewDelegate, BookViewControllerDelegate> {
    UIScrollView *mainScrollView;
    NSManagedObjectContext *context;
    NSMutableArray *opponents;
    NSMutableArray *books;
    RootContainerViewController *parent;
    
}

@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) NSMutableArray *opponents;
@property (strong, nonatomic) NSMutableArray *books;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) RootContainerViewController *parent;


-(id)initWithManagedObjectContext:(NSManagedObjectContext *)cntxt;

-(void)retrieveOpponents;
-(void)resizeScrollView;
-(bool)deleteOpponent:(Opponent *)opp;



@end
