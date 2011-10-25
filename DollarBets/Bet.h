//
//  Bet.h
//  DollarBets
//
//  Created by Richard Kirk on 8/23/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Opponent;

@interface Bet : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * didWin;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSString * report;
@property (nonatomic, retain) Opponent *opponent;

+(bool)deleteBet:(Bet *)bet;

-(bool)save;


@end
