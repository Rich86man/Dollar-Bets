//
//  BookViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 8/22/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "BookViewController.h"
#import "Opponent.h"
#import "BookFrontView.h"
#import "BookBackView.h"
#import "FXLabel.h"

@implementation BookViewController
@synthesize frontView, backView;
@synthesize delegate;
@synthesize opponent;
@synthesize frontViewIsVisible;


-(id)initWithOpponent:(Opponent *)opp
{
    if (self = [super init])
    {
        self.opponent = opp;
        self.view.frame = CGRectMake(0, 0, 320, 480);
    }    
    return self;
}


#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    [self.view setClearsContextBeforeDrawing:YES];
    BookFrontView *bfw = [[BookFrontView alloc] initWithFrame:self.view.frame ];
    bfw.viewController = self;
    self.frontView = bfw;
    [self.view addSubview:self.frontView];
    
    BookBackView *bsw = [[BookBackView alloc] initWithFrame:self.view.frame];
    bsw.viewController = self;
    bsw.backgroundColor = [UIColor clearColor];
    self.backView = bsw;

}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];

    frontViewIsVisible = YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.frontView refresh];
}

- (void)viewDidUnload
{
    [self setFrontView:nil];
    [self setBackView:nil];
    [self setOpponent:nil];
    [super viewDidUnload];
}


/* Button methods */
- (void)configButtonSelected:(id)sender 
{
    [self flipCurrentView];    
}


-(void)backButtonSelected:(id)sender
{
    [self flipCurrentView];
}


-(void)deleteButtonSelected:(id)sender
{
    switch ([sender tag]) 
    {
        case 0:
            [self.backView showPopOver];
            [self.backView.deleteButton setSelected:YES];
            break;
        case 1:
            [self.backView.deleteButton setSelected:NO];
            [self.delegate deleteThisBook:self];
            break;
        default:
            break;
    }
}

-(void)addNewButtonSelected
{   [self.frontView.nameTextField setUserInteractionEnabled:YES];
    self.frontView.nameTextField.alpha = 1.0f;
    self.frontView.nameTextField.placeholder = @"Opponent...";
  //  self.frontView.addNewButton.alpha = 0;
    //self.frontView.addNewButton = nil;
    //self.frontView.nameTextField.alpha = 1;
    
    [self.frontView.nameTextField becomeFirstResponder];
    [self.frontView hidePlusButton];    
}

-(void)changeNamePressed
{
    [self.frontView.nameTextField setUserInteractionEnabled:YES];
    self.frontView.nameLabel.alpha = 0.0f;
    self.frontView.nameTextField.alpha = 1.0f;
    self.frontView.nameTextField.placeholder = @"Opponent...";    
    [self.frontView.nameTextField becomeFirstResponder];  
    [self flipCurrentView];
}


-(void)refreshFrontView
{
    [self.frontView refresh];
}


- (void)flipCurrentView 
{
  // disable user interaction during the flip
  self.view.userInteractionEnabled = NO;
  
    
    // swap the views and transition
    if (frontViewIsVisible == YES) 
    {
        [UIView transitionFromView:self.frontView
                            toView:self.backView
                          duration:0.75f
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished){
                        	self.view.userInteractionEnabled = YES;
                        }];
    }
    else
    {
        [UIView transitionFromView:self.backView
                            toView:self.frontView
                          duration:0.75f
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){
                        	self.view.userInteractionEnabled = YES;
                        }];
    }
    
    frontViewIsVisible=!frontViewIsVisible;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!frontViewIsVisible && self.backView.popOver.alpha == 1.0f)
    {
        [self.backView hidePopOver];
        [self.backView.deleteButton setSelected:NO];
    }
}

#pragma mark - TextField Delegate Functions
-(void)textFieldDidBeginEditing:(UITextField *)textField 
{
    [self.frontView.nameLabel setAlpha:0.0f];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.frontView.nameLabel.text = textField.text;
    self.frontView.nameLabel.alpha = 1.0f;

    textField.text = @" ";
    [textField setUserInteractionEnabled:NO];
    [textField resignFirstResponder];
    [delegate nameBookFinishedWithName:frontView.nameLabel.text by:self];
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
