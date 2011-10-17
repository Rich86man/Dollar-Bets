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
@class RKButton;
@interface BookFrontView : UIView
{
    UIImageView *bookImgView;
    UILabel *nameLabel;
    UITextField *nameTextField;
    UILabel *dateLabel;
    UIButton *addNewButton;
    UIButton *configButton;

}
@property (strong, retain) UIImageView *bookImgView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, retain) UITextField *nameTextField;
@property (strong, retain) UILabel *dateLabel;
@property (strong, nonatomic) UIButton *addNewButton;
@property (strong, nonatomic) UIButton *configButton;
@property (assign)BookViewController *viewController;



-(void)showPlusButton;
-(void)hidePlusButton;
-(void)showConfigAndDate;
-(void)refresh;

@end
