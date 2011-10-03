//
//  RootViewController.h
//  PageViewTest
//
//  Created by Richard Kirk on 8/29/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opponent.h"
#import "TOCTableViewController.h"
@interface RootViewController : UIViewController <UIPageViewControllerDelegate, UITableViewDelegate, TOCTableViewControllerDelegate>
{
    Opponent *opponent;

}
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) Opponent *opponent;
@property (strong, nonatomic) IBOutlet UIView *pageArea;
@property (strong, nonatomic) IBOutlet UIView *pageArea2;

@end
