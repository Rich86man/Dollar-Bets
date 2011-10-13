//
//  Opponent.m
//  DollarBets
//
//  Created by Richard Kirk on 8/23/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "Opponent.h"
#import "Bet.h"
#import "AppDelegate.h"



@implementation Opponent

@dynamic date;
@dynamic name;
@dynamic picture;
@dynamic bets;


+(NSArray *)allOponentsSortedBy:(NSString *)sortDescriptor;
{
    
    if(!sortDescriptor)
        sortDescriptor = @"date";
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Opponent"];
    
    
    NSSortDescriptor *sortBy= [[NSSortDescriptor alloc] initWithKey:sortDescriptor ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortBy]];
    
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    if(error)
    {   NSLog(@"%@\n", [error  description]);   }
    
    return [array mutableCopy];
}


+(void)deleteAll
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
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
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
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
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
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
