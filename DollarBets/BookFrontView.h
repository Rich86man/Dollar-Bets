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

@interface BookFrontView : UIView
{
    UIImageView *bookImgView;
    UITextField *textField;
    UILabel *dateLabel;
    UIButton *plusSignButton;
    UIButton *configButton;
    UITextField *opponentTextField;
    BOOL newBook;
    BOOL frontViewIsVisible;
    
    
    BookViewController *viewController;
    
}
@property (strong, retain) UIImageView *bookImgView;
@property (strong, retain) UITextField *textField;
@property (strong, retain) UILabel *dateLabel;
@property (strong, nonatomic) UIImageView *plusSignImageView;
@property (strong, nonatomic) UIButton *plusSignButton;
@property (strong, nonatomic) UIButton *configButton;
@property (strong,nonatomic) Opponent *opponent;

@property (strong, nonatomic)BookViewController *viewController;


-(id)initWithFrame:(CGRect)frame asNewBook:(BOOL)isNewBook;

-(void)showPlusButton;
-(void)hidePlusButton;
-(void)showConfigAndDate:(NSDate *)date;

@end
