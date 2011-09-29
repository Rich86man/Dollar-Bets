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
@class statusBarView;

@protocol TOCTableViewControllerDelegate <NSObject>

-(void)didSelectPage:(int)index;

@end

@interface TOCTableViewController : UIViewController<UITextFieldDelegate, UITableViewDelegate, UIScrollViewDelegate, UITextViewDelegate> {
    // Custom Headers
    UIView *tableOfContentsHeader;
    UIView *graphsHeader;    

    
    // Quick add View
    UIView *quickAddView;
    UIView *overlayView;
    UILabel *overlayLabel;
    statusBarView *statusBar;
    UITextField *amountTextField;
    UITextView *descriptionTextView;
    UIButton *saveButton;
	UIImageView *refreshArrow;
    BOOL isQuickAdding;
    BOOL isDragging;
    Bet *quickBet;
    
    
    // Managed Objects
    Opponent *opponent;
    NSArray *bets;

    
    
    
    UITableView *tableView;
}
@property (assign)id delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIView *tableOfContentsHeader;
@property (strong, nonatomic) UIView *graphsHeader;

@property (strong, nonatomic) IBOutlet UIView *quickAddView;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UILabel *overlayLabel;
@property (strong, nonatomic) IBOutlet statusBarView *statusBar;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, retain) UIImageView *refreshArrow;
@property (strong, nonatomic) Bet *quickBet;

@property (strong, nonatomic) Opponent *opponent;
@property (strong, nonatomic) NSArray *bets;






// Quick add Functions

- (IBAction)save:(UIButton *)sender;


@end
