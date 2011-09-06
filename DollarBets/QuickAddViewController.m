//
//  QuickAddViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 9/3/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "QuickAddViewController.h"

@implementation QuickAddViewController
@synthesize descriptionTextView;
@synthesize amountTextField;
@synthesize opponent, bet;



-(id)initWithOpponent:(Opponent *)opp
{
    self = [super init];
    if (self) {
        self.opponent = opp;
        //self.bet = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:[opponent managedObjectContext]];
   //     self.bet = [NSEntityDescription entityForName:@"Bet"inManagedObjectContext:[opponent managedObjectContext]];
        
       // self.bet [
        
     //   bet.date = [NSDate date];
        //bet.opponent = opp;
    
    
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_denim.png"]];
    
}

- (void)viewDidUnload
{
    [self setDescriptionTextView:nil];
    [self setAmountTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - TextView Delegate Functions


- (void)textViewDidBeginEditing:(UITextView *)textView
{
     NSLog(@"textViewDidBeginEditing");

    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textViewDidEndEditing");
    
    [bet setReport:textView.text];
    
}


- (void)textViewDidChange:(UITextView *)textView
{
   
    
    if(textView.contentSize.height > descriptionTextView.frame.size.height)
    {
        CGRect newTextFrame = descriptionTextView.frame;
        CGRect newViewFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height + ( textView.contentSize.height -descriptionTextView.frame.size.height ));    
        
        newTextFrame.size.height = textView.contentSize.height;
        
        
        [UIView animateWithDuration:0.02f animations:^{
            descriptionTextView.frame = newTextFrame;
            self.view.frame = newViewFrame;
            
        }];
    }
    else if(textView.contentSize.height < descriptionTextView.frame.size.height)
    {
        CGRect newTextFrame = descriptionTextView.frame;
        CGRect newViewFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - ( descriptionTextView.frame.size.height - textView.contentSize.height));    
        
        newTextFrame.size.height = textView.contentSize.height;
        
        
        [UIView animateWithDuration:0.02f animations:^{
            descriptionTextView.frame = newTextFrame;
            self.view.frame = newViewFrame;
            
        }];
    }

    
}


#pragma mark - TextField Delegate Functions
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSNumberFormatter *numFormat =  [[NSNumberFormatter alloc] init];
    
    NSNumber *number = [numFormat numberFromString:amountTextField.text];
    
    if(number == nil)
    {
        
        textField.font = [UIFont systemFontOfSize:14.0f];
        textField.text = @"Must Be a Valid Number";
        textField.textColor = [UIColor redColor];
        textField.alpha = 0;
        
        [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionAutoreverse animations:^{
            textField.alpha = 1;
         }completion:^(BOOL finished){
             self.amountTextField.text = @"";
             self.amountTextField.font = [UIFont fontWithName:@"STHeitiJ-Light" size:14.0f];
             self.amountTextField.textColor = [UIColor blackColor];
             self.amountTextField.alpha = 1;

             
             
                
         }];
        
    }
    else
    {
        [bet setAmount:number];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    if([self.descriptionTextView.text isEqualToString:@""])
    {
        [self.descriptionTextView becomeFirstResponder];
    }
    [self.amountTextField resignFirstResponder];
    
    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}


-(BOOL)saveQuickBet
{
    
    NSError *error =  nil;
   [self.opponent.managedObjectContext save:&error];
    
    if(error)
    {
        NSLog(@"%@\n", [error  description]);
        return NO;
    }
    else 
        return YES;
    
    
    
}


@end
