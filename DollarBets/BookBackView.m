//
//  BookSettingsView.m
//  DollarBets
//
//  Created by Richard Kirk on 8/26/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "BookBackView.h"

@implementation BookBackView
@synthesize backButton, bookImageView;
@synthesize popOver;
@synthesize deleteButton;
@synthesize viewController;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    
    // Drawing code
    if(!self.bookImageView)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(27, 44, 267, 331)];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setImage:[UIImage imageNamed:@"bookBack.png"]];
        self.bookImageView = imageView;
    }
    [self addSubview:self.bookImageView];
    
    if(!self.deleteButton)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(45, 275, 204, 34)];
        
        [button setAdjustsImageWhenHighlighted:NO];
        [button setTitle:@"Delete" forState:UIControlStateNormal];
        [button setTitle:@"Delete" forState:UIControlStateSelected];
        [button setTitle:@"Delete" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        [button setBackgroundImage:[UIImage imageNamed:@"deleteButton.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"deleteButtonPressed.png"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"deleteButtonPressed.png"] forState:UIControlStateHighlighted];
        [button addTarget:self.viewController action:@selector(deleteButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:0];
        self.deleteButton = button;
    }
    [self addSubview:self.deleteButton];
    
    if(!self.backButton)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(38, 62, 72, 37)];
        [button setImage:[UIImage imageNamed:@"bookBackButton.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"bookBackButtonPressed.png"] forState:UIControlStateSelected];
        [button addTarget:self.viewController action:@selector(backButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        self.backButton = button;
    }
    [self addSubview:self.backButton];
    
}


-(void)showPopOver
{
    if(!self.popOver){
        UIView *popView = [[UIView alloc]init];
        [popView setFrame:CGRectMake(25, 195, 248, 105)];
        [popView setAlpha:0.0f];
        [popView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *popImageView = [[UIImageView alloc]init];
        [popImageView setImage:[UIImage imageNamed:@"popOver.png"]];
        [popImageView sizeToFit];
        [popView addSubview:popImageView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(25, 30, 194, 32)];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        [button setAdjustsImageWhenHighlighted:NO];
        [button setTitle:@"Delete" forState:UIControlStateNormal];
        [button setTitle:@"Delete" forState:UIControlStateSelected];
        [button setTitle:@"Delete" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"deleteDoubleCheckButton.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"deleteDoubleCheckButtonSelected.png"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"deleteDoubleCheckButtonSelected.png"] forState:UIControlStateHighlighted];
        [button addTarget:self.viewController action:@selector(deleteButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:1];
        [popView addSubview:button];
        
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
