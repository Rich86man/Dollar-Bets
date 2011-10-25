//
//  BookFrontView.m
//  DollarBets
//
//  Created by Richard Kirk on 8/26/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "BookFrontView.h"
#import "BookViewController.h"
#import "Opponent.h"
#import "FXLabel.h"





@implementation BookFrontView
@synthesize nameTextField, bookImgView, dateLabel;
@synthesize configButton, addNewButton;
@synthesize viewController;
@synthesize nameLabel;
@synthesize summaryLabel;
@synthesize winsAmountTab, lossesAmountTab;


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    
    
    
    if(!self.bookImgView)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(31, 44, 265, 362)];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setImage:[UIImage imageNamed:@"book.png"]];
        [imageView setUserInteractionEnabled:YES];
        
        self.bookImgView = imageView;
    }
    [self addSubview:self.bookImgView];
    
    if(!self.nameLabel)
    {
        UILabel *label = [[FXLabel alloc]initWithFrame:CGRectMake(80, 60, 200, 100)];
        [label setFont:[UIFont fontWithName:HEITI_MEDIUM size:35.0f]];
        //[label setTextColor:[UIColor colorWithRed:RGB256_TO_COL(116) green:RGB256_TO_COL(72) blue:RGB256_TO_COL(35) alpha:0.1]];
        [label setTextColor:[UIColor colorWithWhite:0.0f alpha:0.7f]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setContentMode:UIViewContentModeCenter];
        [label setAdjustsFontSizeToFitWidth:YES];
        //[label setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.3f]];
        [label setShadowColor:[UIColor colorWithRed:RGB256_TO_COL(116) green:RGB256_TO_COL(72) blue:RGB256_TO_COL(35) alpha:1.0]];
        
        [label setShadowOffset:CGSizeMake(1.0f, 1.0f)];
        //[label setShadowBlur:1.0f ];
        //  [label setInnerShadowColor:[UIColor colorWithWhite:0.0f alpha:0.4f]];
        //[label setInnerShadowOffset:CGSizeMake(0.1f, 0.4f)];
        
        
        
        
        
        if(self.viewController.opponent != nil)
        {
            label.text = [self.viewController.opponent name];
            label.userInteractionEnabled =  NO;
        }
        else
        {
            label.text = @"";
        }
        self.nameLabel = label;
        
        
    }
    [self addSubview:self.nameLabel];
    
    
    if(self.nameTextField == nil)
    {
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(80, 60, 200, 100)];
        [textField setContentMode:UIViewContentModeCenter];
        [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textField setAdjustsFontSizeToFitWidth:YES];
        [textField setBackgroundColor:[UIColor clearColor]];
        [textField setDelegate:self.viewController];
        [textField setFont:[UIFont fontWithName:HEITI_MEDIUM size:35.0f]];
        [textField setTextColor:[UIColor colorWithRed:RGB256_TO_COL(33) green:RGB256_TO_COL(15) blue:RGB256_TO_COL(0) alpha:1.0]];
        [textField setUserInteractionEnabled:NO];
        
        self.nameTextField = textField;
    }
    [self addSubview:self.nameTextField];
    
    if (self.viewController.opponent == nil) 
    {
        [self showPlusButton];
        self.nameTextField.alpha = 0;
    }
    else
    {
        [self showConfigAndDate];
    }
    
    
    
    [self showWins];
    [self showLosses];
}




-(void)showPlusButton
{
    if(self.addNewButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //     [button setFrame:CGRectMake(115, 150, 100, 100)];
        [button setFrame:CGRectMake(31, 44, 265, 362)];
        [button setImage:[UIImage imageNamed:@"plusSign.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"plusSign.png"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"plusSign.png"] forState:UIControlStateHighlighted];
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 50, 0  )];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [button setAdjustsImageWhenDisabled:NO];
        [button setAdjustsImageWhenHighlighted:NO];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self.viewController action:@selector(addNewButtonSelected) forControlEvents:UIControlEventTouchUpInside];
        self.addNewButton = button;
    }
    [self addSubview:self.addNewButton];
    
    [UIView animateWithDuration:1.0 
                          delay:0 
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{ 
                         self.addNewButton.imageView.alpha = 0.1f;
                         self.addNewButton.imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                         
                     }    
                     completion:nil];   
}


-(void)hidePlusButton
{
    
    [UIView animateWithDuration:1.0 
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{
                         self.addNewButton.imageView.transform = CGAffineTransformMakeScale(0.0, 0.0);
                     }completion:^(BOOL finished){
                         self.addNewButton.alpha = 0;
                         self.addNewButton = nil;
                     }];
    
}


-(void)showConfigAndDate
{
    self.bookImgView.image = [UIImage imageNamed:@"bookWithRibbon.png"];
    
    if(!self.configButton)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(60, 347, 55, 55)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self.viewController action:@selector(configButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button setEnabled:YES];
        self.configButton = button;  
        
    }
    [self addSubview:self.configButton];
    
    if(self.dateLabel == nil)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(139, 310, 129, 21)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:UITextAlignmentRight ];
        [label setFont:[UIFont fontWithName:HEITI_MEDIUM size:16.0f]];
        [label setTextColor:[UIColor colorWithRed:RGB256_TO_COL(33) green:RGB256_TO_COL(15) blue:RGB256_TO_COL(0) alpha:1.0]];
        
        
        if (self.viewController.opponent != nil)
        {
            label.text = [self.viewController.opponent.date RKStringFromDate];
        }
        else 
        {   // There must be an error.
            label.text = @"";
        }
        self.dateLabel = label;        
    }
    [self addSubview:self.dateLabel];
}



-(void)refresh
{
    if(self.viewController.opponent == nil)
    {
        [self showPlusButton];
        [self setConfigButton:nil];
        [self setDateLabel:nil];
    }
    else if(self.viewController.opponent != nil)
    {
        [self hidePlusButton];
        self.nameTextField.text = @" ";
        self.nameLabel.text = [self.viewController.opponent name];
        [self showConfigAndDate];
    }
    
    [self showWins];
    [self showLosses];
}

-(void)showWins
{
    if ([[self.viewController.opponent numberOfWins] intValue] > 0)
    {
        
        if (!self.winsAmountTab)
        {
            UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(282, 100, 39, 35)];
            [aview setBackgroundColor:[UIColor clearColor]];
            
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,39, 35)];
            [imageView setImage:[UIImage imageNamed:@"winsAmountTab.png"]];
            
            [aview addSubview:imageView];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor whiteColor]];
            [label setAdjustsFontSizeToFitWidth:YES];
            [label setFont:[UIFont fontWithName:HEITI size:15]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setContentMode:UIViewContentModeCenter];
        
            NSString *text = [NSString stringWithFormat:@"$%@",[[self.viewController.opponent numberOfWins] stringValue]];
            [label setText:text];
            
            [aview addSubview:label];
            self.winsAmountTab = aview;
        }
        [self addSubview:self.winsAmountTab];
    }
}

-(void)showLosses
{
    if ([[self.viewController.opponent numberOfLosses] intValue] > 0)
    {
        
        if (!self.lossesAmountTab)
        {
            UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(282, 150, 39, 35)];
            [aview setBackgroundColor:[UIColor clearColor]];
            
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 39, 35)];
            [imageView setImage:[UIImage imageNamed:@"lossesAmountTab.png"]];
            
            [aview addSubview:imageView];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setAdjustsFontSizeToFitWidth:YES];
            [ label setTextColor:[UIColor whiteColor]];
            [label setFont:[UIFont fontWithName:HEITI size:15]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setContentMode:UIViewContentModeCenter];
             NSString *text = [NSString stringWithFormat:@"$%@",[[self.viewController.opponent numberOfLosses] stringValue]];
            [label setText:text];
            
            [aview addSubview:label];
            self.lossesAmountTab = aview;
        }
        [self addSubview:self.lossesAmountTab];
    }
}

@end
