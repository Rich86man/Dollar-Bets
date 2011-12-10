//
//  RootContainerViewController.h
//  DollarBets
//
//  Created by Richard Kirk on 8/29/11.
//  Copyright (c) 2011 Home. All rights reserved.
// 
//
//  This is a container for the MainScrollView and the Actual books
//
//






#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "RootBookViewController.h"
#import "BookViewController.h"

@interface RootContainerViewController : UIViewController
{
    NSManagedObjectContext *context;
    MainViewController *mainViewController;
    RootBookViewController *rootViewController;
    CGRect aFrame;
}

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) RootBookViewController *rootViewController;

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)cntxt;

-(void)OpenBook:(BookViewController *)book;
-(void)closeBook:(BookViewController *)book;

@end
