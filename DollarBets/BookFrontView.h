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

}
@property (strong, nonatomic) UIImageView *bookImgView;
@property (strong, nonatomic) FXLabel *nameLabel;
@property (strong, nonatomic) FXLabel *dateLabel;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UIButton *addNewButton;
@property (strong, nonatomic) UIButton *configButton;
@property (assign)BookViewController *viewController;



-(void)showPlusButton;
-(void)hidePlusButton;
-(void)showConfigAndDate;
-(void)refresh;

@end
