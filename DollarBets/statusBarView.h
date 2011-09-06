//
//  statusBarView.h
//  DollarBets
//
//  Created by Richard Kirk on 9/6/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface statusBarView : UIView
{
    UILabel * centerLabel;
    UIImageView *statusImage;
    UIProgressView *progressIndicator;
}



@property (strong, nonatomic) UILabel *centerLabel;
@property (strong, nonatomic) UIImageView *statusImageView;
@property (strong, nonatomic) UIProgressView *progressIndicator;

@end
