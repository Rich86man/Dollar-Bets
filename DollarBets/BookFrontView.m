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


#define RGB256_TO_COL(col) ((col) / 255.0f)
#define BODONI @"BodoniSvtyTwoSCITCTT-Book"

@implementation BookFrontView
@synthesize nameTextField, bookImgView, dateLabel;
@synthesize configButton, addNewButton;
@synthesize viewController;
@synthesize nameLabel;


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
        FXLabel *label = [[FXLabel alloc]initWithFrame:CGRectMake(80, 60, 200, 100)];
        [label setFont:[UIFont fontWithName:HEITI_MEDIUM size:35.0f]];
        [label setTextColor:[UIColor colorWithRed:RGB256_TO_COL(116) green:RGB256_TO_COL(72) blue:RGB256_TO_COL(35) alpha:0.1]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setContentMode:UIViewContentModeCenter];
        [label setAdjustsFontSizeToFitWidth:YES];
        [label setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.3f]];
        [label setShadowOffset:CGSizeMake(1.0f, 1.0f)];
        [label setShadowBlur:1.0f ];
        [label setInnerShadowColor:[UIColor colorWithWhite:0.0f alpha:0.4f]];
        [label setInnerShadowOffset:CGSizeMake(0.1f, 0.4f)];
        
        
        
        
        
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
        [textField setFont:[UIFont fontWithName:HEITI_MEDIUM size:30.0f]];
        [textField setTextColor:[UIColor colorWithRed:RGB256_TO_COL(47) green:RGB256_TO_COL(14) blue:RGB256_TO_COL(8) alpha:1.0]];
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
    
}


-(void)showPlusButton
{
    if(self.addNewButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(115, 150, 100, 100)];
        [button setImage:[UIImage imageNamed:@"plusSign.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"plusSign.png"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"plusSign.png"] forState:UIControlStateHighlighted];
        [button setAdjustsImageWhenDisabled:NO];
        [button setAdjustsImageWhenHighlighted:NO];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self.viewController action:@selector(addNewButtonSelected) forControlEvents:UIControlEventTouchUpInside];
        self.addNewButton = button;
    }
    [self addSubview:self.addNewButton];
    
    [UIView animateWithDuration:1.2 
                          delay:0 
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{ 
                         self.addNewButton.imageView.alpha = 0.0f;
                         self.addNewButton.imageView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
                         
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
    if(self.configButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(60, 347, 55, 55)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self.viewController action:@selector(configButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button setEnabled:YES];
        self.configButton = button;  
        self.bookImgView.image = [UIImage imageNamed:@"bookWithRibbon.png"];
    }
    [self addSubview:self.configButton];
    
    if(self.dateLabel == nil)
    {
        FXLabel *label = [[FXLabel alloc]initWithFrame:CGRectMake(139, 310, 129, 21)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:UITextAlignmentRight ];
        [label setFont:[UIFont fontWithName:HEITI_MEDIUM size:16.0f]];
        [label setTextColor:[UIColor colorWithRed:RGB256_TO_COL(116) green:RGB256_TO_COL(72) blue:RGB256_TO_COL(35) alpha:0.1]];
        [label setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.3f]];
        [label setShadowOffset:CGSizeMake(1.0f, 1.0f)];
        [label setShadowBlur:1.0f ];
        [label setInnerShadowColor:[UIColor colorWithWhite:0.0f alpha:0.6f]];
        [label setInnerShadowOffset:CGSizeMake(0.1f, 0.4f)];
        
               
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
}

@end
