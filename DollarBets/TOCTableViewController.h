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
-(void)didBeginQuickEdit:(id)sender;
-(void)readyToSave:(bool)ready;
-(void)savedQuickBet;

@end

@interface TOCTableViewController : UIViewController <UITableViewDelegate, UIScrollViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate> {
    
    Bet *quickBet;
    UITableView *tableView;
    // Custom Headers
    UIView *headerView;
    UIView *graphsHeader;    

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

    NSTimer *myHomeButtonTimer;
    
    bool isQuickAdding;
    bool isDragging;
    

}
@property (assign)id delegate;
@property (strong, nonatomic) Opponent *opponent;
@property (strong, nonatomic) NSArray *bets;
@property (strong, nonatomic) NSTimer *myHomeButtonTimer;
@property (strong, nonatomic) Bet *quickBet;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *quickAddView;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UILabel *overlayLabel;

@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UITextView *amountTextView;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;



-(id)initWithOpponent:(Opponent *)opp;

-(void)setUpAmountLabel;
-(void)timerFired;

// Quick add Functions
- (IBAction)save:(UIButton *)sender;

-(void)didTapHeader;




@end
