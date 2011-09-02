//
//  BookSettingsView.h
//  DollarBets
//
//  Created by Richard Kirk on 8/26/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookViewController;
@class Opponent;

@interface BookSettingsView : UIView
{
    UIButton *deleteButton; 
    UIButton *backButton;
    UIImageView *bookImageView;
    BookViewController *viewController;
    Opponent * opponent;
    
}
@property (strong, nonatomic)UIButton *deleteButton;
@property (strong, nonatomic)UIButton *backButton;
@property (strong, nonatomic)UIImageView *bookImageView;
@property (strong, nonatomic)BookViewController *viewController;
@property (strong, nonatomic)Opponent *opponent;

@end
