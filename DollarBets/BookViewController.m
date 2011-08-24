//
//  BookViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 8/22/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "BookViewController.h"
#import <CoreGraphics/CoreGraphics.h>


@implementation BookViewController
@synthesize opponentLabel;
@synthesize dateLabel;
@synthesize plusSignImageView;
@synthesize debugPageNumber;
@synthesize plusSignButton;
@synthesize opponentTextField;
@synthesize delegate;
@synthesize opponent;





-(id)initWithOpponent:(Opponent *)opp
{
    if (self = [super initWithNibName:@"BookViewController" bundle:nil])
    {
        newBook = NO;
        self.opponent = opp;
    }    
    
    
    return self;
    
}

-(id)initAsAddBook
{
    if (self = [super initWithNibName:@"BookViewController" bundle:nil])
    {
        newBook = YES;
    }
    
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    
    if(newBook)
    {
        self.debugPageNumber.text = @"newBook";
        
        [self hideOpponentLabel];
        [self hideDateLabel];
        [self showPlusButton];
                
      
    }
    else
    {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/DD/YYYY"];

//        self.dateLabel.text = [dateFormatter stringFromDate:[opponent date]];
        self.opponentTextField.text = [opponent name];
        
        [self showDateLabel];
        [self showOpponentLabel];
    }


}



- (void)viewDidUnload
{
    [self setOpponentLabel:nil];
    [self setDateLabel:nil];
    [self setDebugPageNumber:nil];
    [self setPlusSignButton:nil];
    [self setPlusSignImageView:nil];
    [self setOpponentTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




-(IBAction)plusSignPressed:(id)sender
{
    
    [self hidePlusButton];
    [self showOpponentTextField];
   
    
    [delegate addNewBook];

    
  
}

-(IBAction)enteredNewOpponentName:(UITextField *)sender
{
    [delegate opponentCreatedWithName:[sender text]];
    
}



-(void)showPlusButton
{
    
    self.plusSignButton.alpha = 1;
    self.plusSignImageView.alpha = 1;
    
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
    
    
     
}
-(void)showOpponentLabel
{
   // self.opponentLabel.alpha = 1;
    
}
-(void)hideOpponentLabel
{
    //self.opponentLabel.alpha = 0;
}
-(void)showOpponentTextField
{
    
    
    
    [UIView animateWithDuration:.5 
                          delay:0 
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{ 
                         self.opponentTextField.frame = CGRectMake(53, 113, 215, 31);
                         
                         
                     }    
                     completion:nil];
    
}

-(void)hideOpponentTextField
{
    [UIView animateWithDuration:.5 
                          delay:0 
                        options:UIViewAnimationCurveEaseInOut
                     animations:^
     { 
         self.opponentTextField.frame = CGRectMake(53, 113,0, 0);
         
         
     }    
                     completion:nil];
    
    
}

-(void)showDateLabel
{
    self.dateLabel.alpha = 1;
}

-(void)hideDateLabel
{
    self.dateLabel.alpha = 0;
}









@end
