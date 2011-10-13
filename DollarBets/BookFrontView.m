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

@interface BookFrontView (PrivateMethods)



@end

@implementation BookFrontView
@synthesize nameTextField, bookImgView, dateLabel;
@synthesize configButton, plusSignButton;
@synthesize viewController;
@synthesize nameLabel;

-(void)setupView
{
    
    self.bookImgView = nil;
    self.configButton = nil;
    self.nameTextField = nil;
    self.dateLabel = nil;
    self.plusSignButton = nil;
    
    
    
}

-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupView];
    }
    return self;
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    self.backgroundColor = [UIColor clearColor];
    
    if(self.bookImgView == nil)
    {
        UIImageView *setupImgView = [[UIImageView alloc]initWithFrame:CGRectMake(31, 64, 265, 362)];
        setupImgView.backgroundColor = [UIColor clearColor];
        setupImgView.image = [UIImage imageNamed:@"book.png"];
    
        setupImgView.userInteractionEnabled = YES;

        //UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self.viewController action:@selector(handleTapGesture:)];
        //[doubleTap setNumberOfTapsRequired:3];
        ///doubleTap.delegate = self.viewController;
        //UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self.viewController action:@selector(didLongPress:)];
        //[longPressGesture setMinimumPressDuration:2.0];
        //[setupImgView addGestureRecognizer:longPressGesture];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self.viewController action:@selector(didLongPress:)];
        [doubleTap setNumberOfTapsRequired:2];
        [setupImgView addGestureRecognizer:doubleTap];
        self.bookImgView = setupImgView;
        
    }
    [self addSubview:self.bookImgView];
    
    if(!self.nameLabel)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(80, 80, 215, 100)];
        label.font =[UIFont fontWithName:@"STHeitiJ-Light" size:30.0f];
        label.backgroundColor = [UIColor clearColor];
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
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(80, 80, 215, 100)];
        [tf setContentMode:UIViewContentModeCenter];
        [tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [tf setAdjustsFontSizeToFitWidth:YES];
        tf.backgroundColor = [UIColor clearColor];
        tf.delegate = self.viewController;
        tf.font = [UIFont fontWithName:@"STHeitiJ-Light" size:30.0f];
       
              
        self.nameTextField = tf;
    }
    [self addSubview:self.nameTextField];
    
    
    
    
    if (self.viewController.opponent == nil) 
    {
        [self showPlusButton];
    }
    else
    {
        [self showConfigAndDate];
    }
    
    
    
    
    
}


-(void)showPlusButton
{
    

    
    if(self.plusSignButton == nil)
    {
        
        UIButton *psb = [UIButton buttonWithType:UIButtonTypeCustom];
        [psb setFrame:CGRectMake(115, 170, 100, 100)];
        [psb setImage:[UIImage imageNamed:@"plusSign.png"] forState:UIControlStateNormal];
                [psb setImage:[UIImage imageNamed:@"plusSign.png"] forState:UIControlStateSelected];
                [psb setImage:[UIImage imageNamed:@"plusSign.png"] forState:UIControlStateHighlighted];
        [psb setAdjustsImageWhenDisabled:NO];
        [psb setAdjustsImageWhenHighlighted:NO];
        psb.backgroundColor = [UIColor clearColor];
        [psb addTarget:self action:@selector(hidePlusButton) forControlEvents:UIControlEventTouchUpInside];
        self.plusSignButton = psb;
    }
    [self addSubview:self.plusSignButton];
    
    [UIView animateWithDuration:1.2 
                          delay:0 
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{ 
                         self.plusSignButton.alpha = 0.1f;
                         self.plusSignButton.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
                       
                     }    
                     completion:nil];   
    
    self.nameTextField.alpha = 0;
}




-(void)hidePlusButton
{
    
    
    [UIView animateWithDuration:1.0 
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn 
                     animations:^{
                         self.plusSignButton.frame = CGRectMake(self.plusSignButton.frame.origin.x + (self.plusSignButton.frame.size.width / 2), self.plusSignButton.frame.origin.y + (self.plusSignButton.frame.size.height / 2) , 0, 0);
                     }completion:nil];
    
    self.plusSignButton.alpha = 0;
    self.plusSignButton = nil;
    self.nameTextField.alpha = 1;

    
    
}

-(void)showConfigAndDate
{
    if(self.configButton == nil)
    {
        UIButton *setupConfigButton = [UIButton buttonWithType:UIButtonTypeCustom];
        setupConfigButton.frame  = CGRectMake(75, 377, 25, 25);
        setupConfigButton.backgroundColor = [UIColor clearColor];
       // [setupConfigButton setImage:[UIImage imageNamed:@"config-wheel.png"] forState:UIControlStateNormal];
        [setupConfigButton addTarget:self.viewController action:@selector(configButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [setupConfigButton setEnabled:YES];
        self.configButton = setupConfigButton;  
        self.bookImgView.image = [UIImage imageNamed:@"bookWithRibbon.png"];
    }
    [self addSubview:self.configButton];
    
    if(self.dateLabel == nil)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(139, 330, 129, 21)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentRight;
        label.font = [UIFont fontWithName:@"Helvetica" size:19.0f];
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM / dd / YYYY"];
        
        if (self.viewController.opponent != nil)
        {
            label.text = [dateFormatter stringFromDate:[self.viewController.opponent date]];
        }
        else 
        {
            label.text = @"error: date with no opponent";
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
        self.configButton = nil;
        self.dateLabel = nil;
    }
    else if(self.viewController.opponent != nil)
    {
        [self hidePlusButton];
        self.nameTextField.text = [self.viewController.opponent name];
        [self showConfigAndDate];
    }
    
    
    
}



@end
