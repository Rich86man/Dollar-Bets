//
//  TOCBetsTableViewCell.m
//  DollarBets
//
//  Created by Richard Kirk on 9/7/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "TOCBetsTableViewCell.h"

@implementation TOCBetsTableViewCell
@synthesize amountLabel, descriptionLabel;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.font = [UIFont fontWithName:@"STHeitiJ-Light" size:16.0f];
       // descriptionLabel.frame = CGRectMake(70 ,12,250, 24);
        
        
        [self  addSubview:descriptionLabel];
        
        amountLabel = [[UILabel alloc] init];
        amountLabel.font = [UIFont fontWithName:@"STHeitiJ-Light" size:24.0f];
        //amountLabel.frame = CGRectMake(20 ,12,71, 24);
        amountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:amountLabel];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor clearColor];
        
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    descriptionLabel.frame = CGRectMake(70 ,12,250, 24);
    amountLabel.frame = CGRectMake(20 ,12,71, 24);
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
