//
//  RKPageViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 10/17/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "RKPageViewController.h"

@implementation RKPageViewController
@synthesize gesturesDisabled;

- (id)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options
{
    return [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];;
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) 
    {
        return NO;
    }
    return YES;
}


-(void)disablePageViewGestures:(_Bool)disable   
{
    if(disable)
    {
        NSLog(@"Disabling Page View Gestures");
        for (UIGestureRecognizer *gesture in self.gestureRecognizers) 
        {
            if([gesture isEnabled])
                [gesture setEnabled:NO];
        }
        self.gesturesDisabled = YES;
    }
    else if(!disable)
    {
        NSLog(@"Enabling Page View Gestures");
        for (UIGestureRecognizer *gesture in self.gestureRecognizers) 
        {
            if(![gesture isEnabled])
                [gesture setEnabled:YES];
        }
        self.gesturesDisabled = NO;
    }
}


-(NSNumber *)currentPage
{
        int pageCheck = ((UIViewController *)[self.viewControllers objectAtIndex:0]).view.tag;
        return  [NSNumber numberWithInt:pageCheck];
}


@end
