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
@synthesize textField, bookImgView, dateLabel;
@synthesize configButton, plusSignButton, plusSignImageView;
@synthesize viewController;


-(void)setupView
{
    
    self.bookImgView = nil;
    self.configButton = nil;
    self.textField = nil;
    self.dateLabel = nil;
    self.plusSignButton = nil;
    self.plusSignImageView = nil;

    
    
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
        setupImgView.image = [UIImage imageNamed:@"bookFront.png"];
    
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
    
    
    if(self.textField == nil)
    {
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(80, 113, 215, 100)];
        [tf addTarget:self.viewController action:@selector(enteredNewOpponentName:) forControlEvents:UIControlEventEditingDidEndOnExit];
        tf.font = [UIFont fontWithName:@"Helvetica" size:30.0f];
        if(self.viewController.opponent != nil)
        {
            tf.text = [self.viewController.opponent name];
            tf.userInteractionEnabled =  NO;
        }
        else
        {
            tf.placeholder = @"Opponent...";
        }
        
        self.textField = tf;
    }
    [self addSubview:self.textField];
    
    
    
    
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
    
    if(self.plusSignImageView == nil)
    {
        UIImageView *psiv = [[UIImageView alloc]initWithFrame:CGRectMake(125, 194, 71, 71)];
        psiv.image = [UIImage imageNamed:@"plusSign.png"];
        self.plusSignImageView = psiv;
    }
    [self addSubview:self.plusSignImageView];
    
    
    if(self.plusSignButton == nil)
    {
        UIButton *psb = [[UIButton alloc]initWithFrame:CGRectMake(110, 182, 101, 95)];
        psb.backgroundColor = [UIColor clearColor];
        [psb addTarget:self action:@selector(hidePlusButton) forControlEvents:UIControlEventTouchUpInside];
        self.plusSignButton = psb;
    }
    [self addSubview:self.plusSignButton];
    
    [UIView animateWithDuration:1.2 
                          delay:0 
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{ 
                         self.plusSignImageView.alpha = 0.0f;
                         //self.plusSignImageView.frame = CGRectMake(self.plusSignImageView.frame.origin.x, self.plusSignImageView.frame.origin.y, self.plusSignImageView.frame.size.width + 2, self.plusSignImageView.frame.size.height + 2);
                         self.plusSignImageView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
                     }    
                     completion:nil];   
    
    self.textField.alpha = 0;
}




-(void)hidePlusButton
{
    
    
    [UIView animateWithDuration:1.0 
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn 
                     animations:^{
                         self.plusSignImageView.frame = CGRectMake(self.plusSignImageView.frame.origin.x + (self.plusSignImageView.frame.size.width / 2), self.plusSignImageView.frame.origin.y + (self.plusSignImageView.frame.size.height /2) , 0, 0);
                     }completion:nil];
    
    self.plusSignImageView.alpha = 0;
    self.plusSignButton.alpha = 0;
    self.plusSignImageView = nil;
    self.plusSignButton = nil;
    self.textField.alpha = 1;

    
    
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
        self.bookImgView.image = [UIImage imageNamed:@"bookFrontWithConfig.png"];
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
        self.textField.text = [self.viewController.opponent name];
        [self showConfigAndDate];
    }
    
    
    
}



@end
