//
//  TOCTableViewController.h
//  DollarBets
//
//  Created by Richard Kirk on 9/4/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opponent.h"
#import "Bet.h"


@interface TOCTableViewController : UITableViewController<UITextFieldDelegate, UITableViewDelegate> {
    // Custom Headers
    UIView *tableOfContentsHeader;
    UIView *graphsHeader;    

    
    // Quick add View
    UIView *quickAddView;
    UITextField *amountTextField;
    UITextView *descriptionTextView;
	UIImageView *refreshArrow;
    BOOL isQuickAdding;
    BOOL isDragging;
    Bet *quickBet;
    
    
    // Managed Objects
    Opponent *opponent;
    NSArray *bets;

    
}
@property (strong, nonatomic) UIView *tableOfContentsHeader;
@property (strong, nonatomic) UIView *graphsHeader;

@property (strong, nonatomic) IBOutlet UIView *quickAddView;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (nonatomic, retain) UIImageView *refreshArrow;
@property (strong, nonatomic) Bet *quickBet;

@property (strong, nonatomic) Opponent *opponent;
@property (strong, nonatomic) NSArray *bets;


// Quick add Functions
-(void)startLoading;
-(void)stopLoading;
-(void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
-(void)refresh;


@end
