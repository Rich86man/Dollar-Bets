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
@class BetPage;
@protocol BetPageControllerDelegate <NSObject>

-(void)didSelectEdit:(BetPage *)onPage;
-(void)didSelectphoto:(BetPage *)onPage;
-(void)didSelectTweet:(BetPage *)onPage;



@end

@interface BetPage : UIViewController < UITextViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    Bet *bet;
    UIScrollView *scrollView;
    UILabel *titleLabel;
    UILabel *dateLabel;
    UIImageView *dollarImageView;
    UIImageView *mapViewCoverUpImageView;
    UITextView *descriptionTextView;
    NSString * pageNum;
  
    int editState;

    

}
@property (assign)id delegate;
@property (strong, nonatomic) Bet *bet;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;

@property (strong, nonatomic) IBOutlet UILabel *pageNumberLabel;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong,nonatomic) NSString* pageNum;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;
@property (strong, nonatomic) IBOutlet UIButton *tweetButton;




-(id)initWithBet:(Bet*)aBet;
-(void)setUpAmountLabel;

- (IBAction)editButtonSelected:(id)sender;
- (IBAction)photoButtonSelected:(id)sender;
- (IBAction)tweetButtonSelected:(id)sender;

@end


