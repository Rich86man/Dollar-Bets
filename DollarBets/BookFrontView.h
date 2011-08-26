//
//  BookFrontView.h
//  DollarBets
//
//  Created by Richard Kirk on 8/26/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookViewController;


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



@property (strong, nonatomic) IBOutlet UIImageView *plusSignImageView;
@property (strong, nonatomic) IBOutlet UIButton *plusSignButton;
@property (strong, nonatomic) IBOutlet UIButton *configButton;

@property (assign,nonatomic)BookViewController *viewController;


-(id)initWithFrame:(CGRect)frame asNewBook:(BOOL)isNewBook;
-(void)configButtonSelected;



@end
