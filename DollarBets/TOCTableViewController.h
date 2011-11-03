//
//  TOCTableViewController.h
//  DollarBets
// The Talbe Of Contents page is the first page you see when you open up the book
// It shows a tableview of all of the bets you have made with the opponent
// There is an added quickAdd feature which appears once you pull the tableview down past a certain point
//  Created by Richard Kirk on 9/4/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opponent.h"
#import "Bet.h"

@protocol TOCTableViewControllerDelegate <NSObject>
-(void)didSelectPage:(int)index;
-(void)didBeginQuickAdd:(id)sender;
-(void)didselectHomeButton;
-(void)savedQuickBet;
-(void)didBeginEditingDescription;
-(void)editingTable:(BOOL)editing;
@end

@interface TOCTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate> 
{
    UITableView *tableView;
    // Custom Headers
    UIView *headerView;
    
    // Quick add View
    UIView *quickAddView;
    UITextView *descriptionTextView;
    UITextView *amountTextView;
    UIButton *saveButton;
    UIView *overlayView;
    UILabel *overlayLabel;
    
    // Managed Objects
    Opponent *opponent;
    NSArray *bets;
    Bet *bet;


    NSTimer *myHomeButtonTimer;
    
    bool isQuickAdding;
    bool isDragging;
    bool homeButtonShowing;
    

}
@property (assign)id delegate;
@property (strong, nonatomic) Opponent *opponent;
@property (strong, nonatomic) NSArray *bets;
@property (strong, nonatomic) NSTimer *myHomeButtonTimer;
@property (strong, nonatomic) Bet *bet;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *quickAddView;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UILabel *overlayLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UITextView *amountTextView;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;

@property (strong, nonatomic) IBOutlet UIButton *homeButton;
-(id)initWithOpponent:(Opponent *)opp;
-(void)setUpAmountLabel;
-(void)timerFired;

// Quick add Functions
- (IBAction)save:(UIButton *)sender;
- (IBAction)homeButtonSelected:(id)sender;
- (IBAction)editButtonSelected:(id)sender;

-(void)didTapHeader;
-(void)didTapAmountLabel;

@end
