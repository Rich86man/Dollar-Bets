//
//  PopOverController.h
//  DollarBets
//
//  Created by Richard Kirk on 8/25/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopOverControllerDelegate <NSObject>

-(void)didSelectOption:(bool)deleteBook;


@end

@interface PopOverController : UITableViewController
{
    id <PopOverControllerDelegate> _delegate;
}
@property (nonatomic, retain)id<PopOverControllerDelegate> delegate;

@end
