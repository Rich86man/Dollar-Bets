//
//  NSDate+RK.m
//  DollarBets
//
//  Created by Richard Kirk on 10/17/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "NSDate+RK.h"

@implementation NSDate (RK)


-(NSString *)RKStringFromDate
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM / dd / YYYY"];
    return [dateFormatter stringFromDate:self];
}

@end
