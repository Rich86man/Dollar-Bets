//
//  Opponent.m
//  DollarBets
//
//  Created by Richard Kirk on 8/23/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "Opponent.h"
#import "Bet.h"
#import "DollarBetsAppDelegate.h"



@implementation Opponent

@dynamic date;
@dynamic name;
@dynamic picture;
@dynamic bets;


+(NSArray *)allOponentsSortedBy:(NSString *)sortDescriptor;
{
    
    if(!sortDescriptor)
        sortDescriptor = @"date";
    
    NSManagedObjectContext *context = [(DollarBetsAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Opponent"];
    
    
    NSSortDescriptor *sortBy= [[NSSortDescriptor alloc] initWithKey:sortDescriptor ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortBy]];
    
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    if(error)
    {   NSLog(@"%@\n", [error  description]);   }
    
    return array;
}


+(void)deleteAll
{
    NSManagedObjectContext *context = [(DollarBetsAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Opponent"];
    NSError *error = nil;
    
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    if(error)
    {   NSLog(@"%@\n", [error  description]);   }

 
     for (NSManagedObject *opp in array) 
     {
        [context deleteObject:opp ];
     }
     
     [context save:nil];
 

}

+(bool)deleteOpponent:(Opponent *)opp
{
    NSManagedObjectContext *context = [(DollarBetsAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [context deleteObject:opp];
    
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


-(NSNumber *)numberOfWins
{
    int winsCount = 0;
    for (Bet *bet in self.bets) {
        if ([[bet didWin] intValue] == 1)
            winsCount = winsCount + [bet.amount intValue];
    }
    return [NSNumber numberWithInt:winsCount];
}

-(NSNumber *)numberOfLosses
{
    int lossesCount = 0;
    for (Bet *bet in self.bets) {
        if ([[bet didWin] intValue] == 0)
            lossesCount = lossesCount + [bet.amount intValue];
    }   
    return [NSNumber numberWithInt:lossesCount];
}

@end
