//
//  BookFrontView.h
//  DollarBets
//
//  Created by Richard Kirk on 8/26/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookViewController;
@class Opponent;
@class FXLabel;

@interface BookFrontView : UIView
{
    UIImageView *bookImgView;
    FXLabel *nameLabel;
    UITextField *nameTextField;
    FXLabel *dateLabel;
    UIButton *addNewButton;
    UIButton *configButton;
    UILabel *summaryLabel;
    UIView *winsAmountTab;
    UIView *lossesAmountTab;
    
}
@property (strong, nonatomic) UIImageView *bookImgView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UIButton *addNewButton;
@property (strong, nonatomic) UIButton *configButton;
@property (strong, nonatomic) UILabel *summaryLabel;
@property (assign)BookViewController *viewController;
@property (strong, nonatomic)UIView *winsAmountTab;
@property (strong, nonatomic)UIView *lossesAmountTab;

-(void)showPlusButton;
-(void)hidePlusButton;
-(void)showConfigAndDate;

-(void)refresh;
-(void)showWins;
-(void)showLosses;
@end
