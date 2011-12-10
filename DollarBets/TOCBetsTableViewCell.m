//
//  TOCBetsTableViewCell.m
//  DollarBets
//
//  Created by Richard Kirk on 9/7/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "TOCBetsTableViewCell.h"

@implementation TOCBetsTableViewCell
@synthesize amountLabel, descriptionLabel, addNew;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *label = [[UILabel alloc] init];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:16.0f]];
        [label setAdjustsFontSizeToFitWidth:NO];
        [label setTextAlignment:UITextAlignmentLeft];
        [label setContentMode:UIViewContentModeCenter];
        self.descriptionLabel = label;
        [self.contentView  addSubview:descriptionLabel];
        
        amountLabel = [[UILabel alloc] init];
        amountLabel.font = [UIFont fontWithName:@"STHeitiJ-Light" size:30.0f];
        [amountLabel setAdjustsFontSizeToFitWidth:YES];
        [amountLabel setContentMode:UIViewContentModeCenter];
        [amountLabel setTextAlignment:UITextAlignmentCenter];
        amountLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:amountLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"plusSign"]];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        [imageView setAlpha:0.0f];
        self.addNew = imageView;
        [self addSubview:self.addNew];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    descriptionLabel.frame = CGRectMake(70 ,0,216, 44);
    amountLabel.frame = CGRectMake(0 ,0,57, 39);
    addNew.frame = CGRectMake(143, 4, 30, 30);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
