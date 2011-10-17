//
//  RKPageViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 10/17/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "RKPageViewController.h"

@implementation RKPageViewController


- (id)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options
{
    
    self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
    if (self)
    {/*
        for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
            gesture.delegate = self;
        }        
    */
        
      }
    return self;
    
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
    {NSLog(@"Disabling Gestures");
        for (UIGestureRecognizer *gesture in self.gestureRecognizers) 
        {
            if([gesture isEnabled])
                [gesture setEnabled:NO];
        }
    }
    else if(!disable)
    {NSLog(@"Enabling Gestures");
        for (UIGestureRecognizer *gesture in self.gestureRecognizers) 
        {
            if(![gesture isEnabled])
                [gesture setEnabled:YES];
        }
    }
}

-(NSNumber *)currentPage
{
        int pageCheck = ((UIViewController *)[self.viewControllers objectAtIndex:0]).view.tag;
        return  [NSNumber numberWithInt:pageCheck];
}


@end
