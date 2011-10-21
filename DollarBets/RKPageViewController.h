//
//  RKPageViewController.h
//  DollarBets
// 
//
// This is a subclass of UIPageViewController. It is need to disable
// the Page View gestures in certain circumstances. 
//
//  Created by Richard Kirk on 10/17/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKPageViewController : UIPageViewController <UIGestureRecognizerDelegate, UIPageViewControllerDelegate>

@property ( nonatomic)BOOL gesturesDisabled;
-(NSNumber *)currentPage;
-(void)disablePageViewGestures:(_Bool)disable;

@end
