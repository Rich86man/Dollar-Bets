//
//  BetPage.h
//  DollarBets
//
//  Created by Richard Kirk on 9/8/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Bet.h"
@class BetPage, RKPaperView;
@protocol BetPageControllerDelegate <NSObject>
-(void)betPageWillAppear:(BetPage *)betPage;
-(void)didSelectphoto:(BetPage *)onPage;
-(void)didSelectTweet:(BetPage *)onPage;
-(void)didselectEdit:(BetPage *)onPage;
-(void)didselectBack:(BetPage *)onPage;
-(void)didBeginEditingDescription;
@end

@interface BetPage : UIViewController < UITextViewDelegate, UIGestureRecognizerDelegate , UIScrollViewDelegate>
{
    Bet *bet;
    UIScrollView *scrollView;
    UILabel *titleLabel;
    UILabel *dateLabel;
    UITextView *descriptionTextView;
    NSString * pageNum;
  

    BOOL newBet;
    bool overlayShowing;
    bool editing;
}
@property (assign)id delegate;
@property (strong, nonatomic) Bet *bet;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *overlayStatusBar;
@property (strong, nonatomic) IBOutlet UIView *overlayBottom;
@property (strong, nonatomic) IBOutlet UIView *addNewView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UITextView *amountTextView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *pageNumberLabel;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;
@property (strong, nonatomic) IBOutlet UIButton *tweetButton;
@property (strong, nonatomic) IBOutlet RKPaperView *paperView;
@property (nonatomic) BOOL newBet;
@property (strong,nonatomic) NSString* pageNum;

-(id)initWithBet:(Bet*)aBet asNew:(bool)isNew;

-(void)setUpAmountLabel;
-(IBAction)addNewOverlayButtonTapped;

- (IBAction)backButtonSelected:(id)sender;
- (IBAction)editButtonSelected:(id)sender;
- (IBAction)photoButtonSelected:(id)sender;
- (IBAction)tweetButtonSelected:(id)sender;
-(void)doneEditing;
-(void)didTapAmountLabel;

@end


