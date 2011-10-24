//
//  BookSettingsView.h
//  DollarBets
//
//  Created by Richard Kirk on 8/26/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookViewController;

@interface BookBackView : UIView
{
    UIButton *deleteButton; 
    UIButton *backButton;
    UIImageView *bookImageView;
    UIView *popOver;
}
@property (strong, nonatomic)UIButton *deleteButton;
@property (strong, nonatomic)UIButton *backButton;
@property (strong, nonatomic)UIImageView *bookImageView;
@property (assign)BookViewController *viewController;
@property (strong, nonatomic)UIView *popOver;


-(void)showPopOver;
-(void)hidePopOver;
-(void)showWinsTab;
-(void)showLossesTab;
@end
