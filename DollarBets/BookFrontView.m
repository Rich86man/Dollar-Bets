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
@synthesize summaryLabel;


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

    if(!self.summaryLabel)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(145, 175, 126, 126)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName:HEITI_MEDIUM size:20]];        
        [label setNumberOfLines:4];
        //[label setShadowColor:[UIColor colorWithRed:RGB256_TO_COL(97) green:RGB256_TO_COL(52) blue:RGB256_TO_COL(19) alpha:1.0]];
        [label setTextColor:[UIColor colorWithRed:RGB256_TO_COL(33) green:RGB256_TO_COL(15) blue:RGB256_TO_COL(0) alpha:1.0]];
        //[label setShadowColor:[UIColor colorWithWhite:0.0f alpha:1.0f]];
        //[label setShadowOffset:CGSizeMake(1.0f, 1.0f)];
        [label setLineBreakMode:UILineBreakModeCharacterWrap];
        [label setText:@""];
        self.summaryLabel = label;
        [self setupSummaryLabel];
    }
    [self addSubview:self.summaryLabel];
    
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


-(void)setupSummaryLabel;
{
    if ([self.viewController.opponent.bets count] > 0)
    {
        int wins = [[self.viewController.opponent numberOfWins] intValue];
        int losses = [[self.viewController.opponent numberOfLosses] intValue];
        
        NSMutableString *summary = [[NSMutableString alloc]init];
        [summary appendString:@"Wins      + "];
        [summary appendFormat:@"%i\n", wins];
        [summary appendString:@"Losses    - "];
        [summary appendFormat:@"%i\n", losses];
        [summary appendString:@"------------------\n"];
        [summary appendFormat:@"Total       %i", wins - losses];
        self.summaryLabel.text = summary;
    }
    else
        self.summaryLabel.text = @"";
    
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
    
    [self setupSummaryLabel];
}

@end
