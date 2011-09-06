//
//  statusBarView.m
//  DollarBets
//
//  Created by Richard Kirk on 9/6/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "statusBarView.h"
#import <QuartzCore/QuartzCore.h>

@implementation statusBarView
@synthesize centerLabel, statusImageView, progressIndicator;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        /*
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
        [self.layer insertSublayer:gradient atIndex:0];
         */
        
        if(!self.centerLabel)
        {
            UILabel *cl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
            cl.font = [UIFont fontWithName:@"STHeitiJ-Light" size:10];
            cl.textColor = [UIColor whiteColor];
            cl.textAlignment = UITextAlignmentCenter;
            cl.text = @"TESTING!!";
            self.centerLabel = cl;
            
        }
        
        
        if(!self.statusImageView)
        {
            UIImageView *si = [[UIImageView alloc] initWithFrame:CGRectMake(300, 0, 20, 20)];
            
            self.statusImageView = si;
        }
        
        
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    /*
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35,  // Start color
        1.0, 1.0, 1.0, 0.06 }; // End color
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
    CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace); 
    */
    self.backgroundColor = [UIColor clearColor];
  
}


@end
