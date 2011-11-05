//
//  RKPaperView.m
//  DollarBets
//
//  Created by Richard Kirk on 10/17/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "RKPaperView.h"

@implementation RKPaperView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 -(void)drawRect:(CGRect)rect
 {
     //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"handmadepaper.png"]];
 //Get the current drawing context   
 CGContextRef context = UIGraphicsGetCurrentContext(); 
 //Set the line color and width
 CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.2f].CGColor);
 CGContextSetLineWidth(context, 2.0f);
 //Start a new Path
 CGContextBeginPath(context);
 
 //Find the number of lines in our View + add a bit more height to draw lines in the empty part of the view
 UIFont *font = [UIFont fontWithName:HEITI size:20];
 NSUInteger numberOfLines = (self.frame.size.height - 88) / font.leading;
 
 //Set the line offset from the baseline. 
 CGFloat baselineOffset = 103.0f;
 
 //iterate over numberOfLines and draw each line
 for (int x = 0; x < numberOfLines; x++) {
 //0.5f offset lines up line with pixel boundary
 CGContextMoveToPoint(context, self.frame.origin.x, font.leading*x + 0.5f + baselineOffset);
 CGContextAddLineToPoint(context, self.frame.size.width, font.leading*x + 0.5f + baselineOffset);
 }
 
 //Close our Path and Stroke (draw) it
 CGContextClosePath(context);
 CGContextStrokePath(context);
 
 
 
 CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
 CGFloat locations[] = { 0.0, 1.0 };
 
 // there is an error in iOS5 which requires me to make the array in such a way. Please see :
 // https://devforums.apple.com/message/550670 
 NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1].CGColor, (id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8].CGColor, nil];
     
 CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,(__bridge CFArrayRef) colors, locations);
 
 CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), 230);
 CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), 230);
 
 CGContextSaveGState(context);
 CGContextAddRect(context, rect);
 CGContextClip(context);
 CGContextDrawRadialGradient(context, gradient, startPoint,125.0, endPoint, 300.0, 0);
 CGContextRestoreGState(context);
 
 CGGradientRelease(gradient);
 CGColorSpaceRelease(colorSpace);
 
 }
 


@end
