//
//  BookSettingsViewController.h
//  DollarBets
//
//  Created by Richard Kirk on 8/25/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopOverController.h"
@interface BookSettingsViewController : UIViewController<PopOverControllerDelegate> {
    UIButton *deleteButton;
    PopOverController *popOverViewController;
    UIPopoverController *popOver;
    
    
}


@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) PopOverController *popOverController;
@property (strong, nonatomic) UIPopoverController *popOver;



- (IBAction)deleteButtonPressed:(id)sender;


@end
