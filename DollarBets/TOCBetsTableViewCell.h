//
//  TOCBetsTableViewCell.h
//  DollarBets
//
//  Created by Richard Kirk on 9/7/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TOCBetsTableViewCell : UITableViewCell
{
    UILabel *amountLabel;
    UILabel *descriptionLabel;
    UIImageView *addNew;

}
@property (nonatomic, retain)UILabel *amountLabel;
@property (nonatomic, retain)UILabel *descriptionLabel;
@property (nonatomic, retain)UIImageView *addNew;


@end
