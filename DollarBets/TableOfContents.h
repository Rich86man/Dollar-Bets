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



@interface TableOfContents : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    IBOutlet UITableView *tableView;
    Opponent *opponent;
    NSArray *bets;
    UIView *tableOfContentsHeader;
    UIView *graphsHeader;    
    IBOutlet UIView *quickAddView;
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
@property (strong, nonatomic) IBOutlet UIView *quickAddView;
@property (strong, nonatomic) Bet *bet;



/*
-(void)amountEntered:(UITextField *)txtField;
-(void)descriptionEntered:(UITextField *)txtField;
*/

@end
