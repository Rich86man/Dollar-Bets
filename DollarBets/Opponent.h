//
//  Opponent.h
//  DollarBets
//
//  Created by Richard Kirk on 8/23/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bet;

@interface Opponent : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSSet *bets;
@end

@interface Opponent (CoreDataGeneratedAccessors)

+(NSArray *)allOponentsSortedBy:(NSString *)sortDescriptor;
+(void)deleteAll;
+(bool)deleteOpponent:(Opponent *)opp;

-(bool)save;

- (void)addBetsObject:(Bet *)value;
- (void)removeBetsObject:(Bet *)value;
- (void)addBets:(NSSet *)values;
- (void)removeBets:(NSSet *)values;
-(NSNumber *)numberOfWins;
-(NSNumber *)numberOfLosses;

@end
