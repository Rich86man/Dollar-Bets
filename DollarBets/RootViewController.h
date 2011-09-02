//
//  RootViewController.h
//  PageViewTest
//
//  Created by Richard Kirk on 8/29/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opponent.h"
@interface RootViewController : UIViewController <UIPageViewControllerDelegate>
{
    Opponent *opponent;

}
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) Opponent *opponent;

@end
