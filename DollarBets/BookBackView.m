//
//  BookSettingsView.m
//  DollarBets
//
//  Created by Richard Kirk on 8/26/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "BookBackView.h"
#import "BookViewController.h"
#define RGB256_TO_COL(col) ((col) / 255.0f)

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
        
        [button setAdjustsImageWhenHighlighted:YES];
        [button setTitle:@"Delete" forState:UIControlStateNormal];
        [button setTitle:@"Delete" forState:UIControlStateSelected];
        [button setTitle:@"Delete" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        [button setBackgroundImage:[UIImage imageNamed:@"deleteButton.png"] forState:UIControlStateNormal];
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
    
    UIButton *changeNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeNameButton setFrame:CGRectMake(45, 120, 197, 31)];
    [changeNameButton addTarget:self.viewController action:@selector(changeNamePressed) forControlEvents:UIControlEventTouchUpInside];
    [changeNameButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [changeNameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [changeNameButton setTitle:@"Change Name" forState:UIControlStateNormal];
    [changeNameButton setTitleColor:[UIColor colorWithRed:RGB256_TO_COL(184) green:RGB256_TO_COL(180) blue:RGB256_TO_COL(180) alpha:1.0] forState:UIControlStateNormal];
    [changeNameButton setBackgroundImage:[UIImage imageNamed:@"changeNameButton.png"] forState:UIControlStateNormal];
    [changeNameButton setAdjustsImageWhenHighlighted:NO];
    [self addSubview:changeNameButton];
    
    
    [self showWinsTab];
    [self showLossesTab];
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

-(void)showWinsTab
{
    if ([[self.viewController.opponent numberOfWins] intValue] > 0)
    {
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bookImageView.frame.origin.x - 10, 100, 10, 27)];
        [imageView setImage:[UIImage imageNamed:@"winsAmountTabFlipped.png"]];
        [imageView setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:imageView];
    }
}

-(void)showLossesTab
{
    if ([[self.viewController.opponent numberOfLosses] intValue] > 0)
    {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bookImageView.frame.origin.x - 10, 150, 10, 27)];
        [imageView setImage:[UIImage imageNamed:@"lossesAmountTabFlipped.png"]];
        [imageView setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:imageView];
    }
}



@end
