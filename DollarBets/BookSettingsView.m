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
@synthesize popOver;
@synthesize deleteDoubleCheck;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDeleteButton:nil]; ;
        [self setBackButton:nil];
        [self setBookImageView:nil];
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
    biv.image = [UIImage imageNamed:@"bookBack.png"];
    self.bookImageView = biv;
    [self addSubview:self.bookImageView];
    
    
    UIButton *db = [UIButton buttonWithType:UIButtonTypeCustom];
    db.frame = CGRectMake(45, 295, 204, 34);
    //db.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [db setAdjustsImageWhenHighlighted:NO];
    [db setTitle:@"Delete" forState:UIControlStateNormal];
    [db setTitle:@"Delete" forState:UIControlStateSelected];
    [db setTitle:@"Delete" forState:UIControlStateHighlighted];
    [db setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [db setBackgroundImage:[UIImage imageNamed:@"deleteButton.png"] forState:UIControlStateNormal];
    [db setBackgroundImage:[UIImage imageNamed:@"deleteButtonPressed.png"] forState:UIControlStateSelected];
        [db setBackgroundImage:[UIImage imageNamed:@"deleteButtonPressed.png"] forState:UIControlStateHighlighted];
    [db addTarget:self.viewController action:@selector(deleteButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [db setTag:0];
    self.deleteButton = db;
    [self addSubview:self.deleteButton];
    
    
    UIButton *bb = [UIButton buttonWithType:UIButtonTypeCustom];
    bb.frame = CGRectMake(38, 82, 72, 37);
    [bb setImage:[UIImage imageNamed:@"bookBackButton.png"] forState:UIControlStateNormal];
    [bb setImage:[UIImage imageNamed:@"bookBackButtonPressed.png"] forState:UIControlStateSelected];
    //[bb setTitle:@"back" forState:UIControlStateNormal];
    [bb addTarget:self.viewController action:@selector(backButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton = bb;
    [self addSubview:self.backButton];
    

}

-(void)showPopOver
{
    if(!self.popOver){
        
        UIView *popView = [[UIView alloc]init];
        [popView setFrame:CGRectMake(25, 215, 248, 105)];
        [popView setAlpha:0.0f];
        [popView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *popImageView = [[UIImageView alloc]init];
        [popImageView setImage:[UIImage imageNamed:@"popOver.png"]];
        [popImageView sizeToFit];
        [popView addSubview:popImageView];
        
        UIButton *db = [UIButton buttonWithType:UIButtonTypeCustom];
        db.frame = CGRectMake(25, 30, 194, 32);
        db.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        [db setAdjustsImageWhenHighlighted:NO];
        [db setTitle:@"Delete" forState:UIControlStateNormal];
        [db setTitle:@"Delete" forState:UIControlStateSelected];
        [db setTitle:@"Delete" forState:UIControlStateHighlighted];
        [db setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [db setBackgroundImage:[UIImage imageNamed:@"deleteDoubleCheckButton.png"] forState:UIControlStateNormal];
        [db setBackgroundImage:[UIImage imageNamed:@"deleteDoubleCheckButtonSelected.png"] forState:UIControlStateSelected];
        [db setBackgroundImage:[UIImage imageNamed:@"deleteDoubleCheckButtonSelected.png"] forState:UIControlStateHighlighted];
        [db addTarget:self.viewController action:@selector(deleteButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [db setTag:1];
        [popView addSubview:db];
        
        [self setPopOver:popView];
        [self addSubview:self.popOver];
    }
    
    if(self.popOver.alpha != 1.0f)
    {
    [UIView animateWithDuration:0.1f animations:^{
        [self.popOver setAlpha:1.0f];
    }];
    }
    
}

-(void)hidePopOver
{
    if(self.popOver.alpha != 0.0f)
    {
        [UIView animateWithDuration:0.1f animations:^{
            [self.popOver setAlpha:0.0f];
        }];
    }
    
}


@end
