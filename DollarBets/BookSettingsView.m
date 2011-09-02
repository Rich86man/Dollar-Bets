//
//  BookSettingsView.m
//  DollarBets
//
//  Created by Richard Kirk on 8/26/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "BookSettingsView.h"

@implementation BookSettingsView
@synthesize deleteButton, backButton, bookImageView;
@synthesize viewController;
@synthesize opponent;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.deleteButton = nil;
        self.backButton = nil;
        self.bookImageView = nil;
        
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor clearColor];
    // Drawing code
    UIImageView *biv = [[UIImageView alloc] initWithFrame:CGRectMake(27, 64, 267, 331)];
    biv.backgroundColor = [UIColor clearColor];
    biv.image = [UIImage imageNamed:@"bookCoverFlipped.png"];
    self.bookImageView = biv;
    [self addSubview:self.bookImageView];
    
    
    UIButton *db = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    db.frame = CGRectMake(124, 163, 72, 37);
    db.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    db.titleLabel.text = @"Delete";
    [db addTarget:self.viewController action:@selector(deleteButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteButton = db;
    [self addSubview:self.deleteButton];
    
    
    UIButton *bb = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bb.frame = CGRectMake(38, 82, 72, 37);
    [bb setTitle:@"back" forState:UIControlStateNormal];
    [bb addTarget:self.viewController action:@selector(backButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton = bb;
    [self addSubview:self.backButton];
    

}



@end
