//
//  Bet.m
//  DollarBets
//
//  Created by Richard Kirk on 8/23/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "Bet.h"
#import "Opponent.h"
#import "DollarBetsAppDelegate.h"

@implementation Bet

@dynamic amount;
@dynamic date;
@dynamic didWin;
@dynamic latitude;
@dynamic longitude;
@dynamic picture;
@dynamic report;
@dynamic opponent;

+(bool)deleteBet:(Bet *)bet
{
    NSManagedObjectContext *context = [(DollarBetsAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
   
    [bet.opponent removeBetsObject:bet];
    [context deleteObject:bet];
    
    NSError *error = nil;
    [context save:&error];
    if(error)
    {  
        NSLog(@"%@\n", [error  description]);
        return NO;
    }
    return YES;

}


-(bool)save
{
    NSManagedObjectContext *context = [(DollarBetsAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSError *error = nil;
    [context save:&error];
    if(error)
    {   
        NSLog(@"%@\n", [error  description]);   
        return NO;
    }
    return YES;
}

@end
