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
#import "RKButton.h"
#define RGB256_TO_COL(col) ((col) / 255.0f)

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
        
       // UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self.viewController action:@selector(didDoubleClick)];
       // [doubleTap setNumberOfTapsRequired:2];
        //[imageView addGestureRecognizer:doubleTap];
        self.bookImgView = imageView;
    }
    [self addSubview:self.bookImgView];
    
    if(!self.nameLabel)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(80, 60, 215, 100)];
        [label setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:30.0f]];
        [label setTextColor:[UIColor colorWithRed:RGB256_TO_COL(171) green:RGB256_TO_COL(170) blue:RGB256_TO_COL(79) alpha:1.0]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setContentMode:UIViewContentModeCenter];
        [label setAdjustsFontSizeToFitWidth:YES];

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
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(80, 60, 215, 100)];
        [textField setContentMode:UIViewContentModeCenter];
        [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textField setAdjustsFontSizeToFitWidth:YES];
        [textField setBackgroundColor:[UIColor clearColor]];
        [textField setDelegate:self.viewController];
        [textField setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:30.0f]];
        [textField setTextColor:[UIColor colorWithRed:RGB256_TO_COL(171) green:RGB256_TO_COL(170) blue:RGB256_TO_COL(79) alpha:1.0]];


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
                         self.addNewButton.alpha = 0.1f;
                         self.addNewButton.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
                         
                     }    
                     completion:nil];   
}


-(void)hidePlusButton
{
    [UIView animateWithDuration:1.0 
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn 
                     animations:^{
                         self.addNewButton.frame = CGRectMake(self.addNewButton.frame.origin.x + (self.addNewButton.frame.size.width / 2), self.addNewButton.frame.origin.y + (self.addNewButton.frame.size.height / 2) , 0, 0);
                     }completion:nil];
}


-(void)showConfigAndDate
{
    if(self.configButton == nil)
    {
        RKButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(75, 377, 25, 25)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self.viewController action:@selector(configButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button setEnabled:YES];
        self.configButton = button;  
        self.bookImgView.image = [UIImage imageNamed:@"bookWithRibbon.png"];
    }
    [self addSubview:self.configButton];
    
    if(self.dateLabel == nil)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(139, 310, 129, 21)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:UITextAlignmentRight ];
        [label setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:16.0f]];
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM / dd / YYYY"];
        
        if (self.viewController.opponent != nil)
        {
            label.text = [dateFormatter stringFromDate:[self.viewController.opponent date]];
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
        self.nameTextField.text = [self.viewController.opponent name];
        [self showConfigAndDate];
    }
}

@end
