//
//  BookFrontView.m
//  DollarBets
//
//  Created by Richard Kirk on 8/26/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "BookFrontView.h"


@interface BookFrontView (PrivateMethods)

-(void)showPlusButton;
-(void)hidePlusButton;
-(void)showConfigAndDate:(NSDate *)date;

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
    self.plusSignImageView.nil;
    
    
    
}

-(id)initWithFrame:(CGRect)frame asNewBook:(BOOL)isNewBook
{
    
    self = [self initWithFrame:frame];
    
    if (self) {
        newBook = isNewBook;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    UIImageView *setupImgView = [[UIImageView alloc]initWithFrame:CGRectMake(27, 64, 267, 331)];
    setupImgView.image = [UIImage imageNamed:@"bookCover1.png"];
    setupImgView.userInteractionEnabled = NO;
    self.bookImgView = setupImgView;
    [self addSubview:self.bookImgView];
    
    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(53, 113, 215, 100)];
    tf.font = [UIFont fontWithName:@"Helvetica" size:30.0f];
    tf.placeholder = @"Opponent...";
    self.textField = tf;
    [self addSubview:self.textField];
    
    
    
    
    if (newBook) {
        [self showPlusButton];
        
        
    }
    else
    {
        
        [self showConfigAndDate:nil];
        self.dateLabel.text = @"";
        
        
    }
    
    
    
    
    
    
    
    
    
}



-(void)showPlusButton
{
    
    if(self.plusSignImageView == nil)
    {
        UIImageView *psiv = [[UIImageView alloc]initWithFrame:CGRectMake(125, 194, 71, 71)];
        psiv.image = [UIImage imageNamed:@"plusSign.png"];
        self.plusSignImageView = psiv;
        [self addSubview:self.plusSignImageView];
    }
    
    if(self.plusSignButton == nil)
    {
        UIButton *psb = [[UIButton alloc]initWithFrame:CGRectMake(110, 182, 101, 95)];
        psb.backgroundColor = [UIColor clearColor];
        [psb addTarget:self.viewController action:@selector(plusSignPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.plusSignButton = psb;
        [self addSubview:self.plusSignButton];
        
        
        
    }
    
    [UIView animateWithDuration:1.2 
                          delay:0 
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{ 
                         self.plusSignImageView.alpha = 0.0f;
                         //self.plusSignImageView.frame = CGRectMake(self.plusSignImageView.frame.origin.x, self.plusSignImageView.frame.origin.y, self.plusSignImageView.frame.size.width + 2, self.plusSignImageView.frame.size.height + 2);
                         self.plusSignImageView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
                         
                         
                     }    
                     completion:nil];
    
    
    
    
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
    
    
    
}

-(void)showConfigAndDate:(NSDate *)date
{
    if(self.configButton == nil)
    {
        UIButton *setupConfigButton = [[UIButton alloc] initWithFrame:CGRectMake(37, 359, 29, 29)];
        setupConfigButton.imageView.image = [UIImage imageNamed:@"config-wheel.png"];
        [setupConfigButton addTarget:self.viewController action:@selector(configButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.configButton = setupConfigButton;
        [self addSubview:self.configButton];
    }
    
    
    if(self.dateLabel == nil)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(139, 352, 129, 21)];
        label.textAlignment = UITextAlignmentRight;
        label.font = [UIFont fontWithName:@"Helvetica" size:19.0f];
      
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM / DD / YYYY"];
        if(date == nil)
        {
            label.text = [dateFormatter stringFromDate:[NSDate date]];
        }
        else
        {
            label.text = [dateFormatter stringFromDate:date];
        }
        
        self.dateLabel = label;
        [self addSubview:self.dateLabel];
    }
    
}

@end
