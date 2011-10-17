//
//  RKPageViewController.h
//  DollarBets
//
//  Created by Richard Kirk on 10/17/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKPageViewController : UIPageViewController <UIGestureRecognizerDelegate, UIPageViewControllerDelegate>

-(NSNumber *)currentPage;
-(void)disablePageViewGestures:(_Bool)disable;

@end
