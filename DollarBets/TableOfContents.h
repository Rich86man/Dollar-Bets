//
//  TableOfContents.h
//  DollarBets
//
//  Created by Richard Kirk on 9/1/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opponent.h"
#import "Bet.h"

@class QuickAddViewController;

@interface TableOfContents : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    IBOutlet UITableView *tableView;
    Opponent *opponent;
    NSArray *bets;
    UIView *tableOfContentsHeader;
    UIView *graphsHeader;    
    QuickAddViewController *quickAddView;
    UIImageView *refreshArrow;
    BOOL isQuickAdding;
    BOOL isDragging;
    
    Bet *bet;
    
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) Opponent *opponent;
@property (strong, nonatomic) NSArray *bets;
@property (strong, nonatomic) UIView *tableOfContentsHeader;
@property (strong, nonatomic) UIView *graphsHeader;
@property (strong, nonatomic) QuickAddViewController *quickAddView;
@property (strong, nonatomic) Bet *bet;

@property (nonatomic, retain) UIImageView *refreshArrow;

-(void)startLoading;
-(void)stopLoading;
-(void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
-(void)refresh;

/*
-(void)amountEntered:(UITextField *)txtField;
-(void)descriptionEntered:(UITextField *)txtField;
*/

@end
