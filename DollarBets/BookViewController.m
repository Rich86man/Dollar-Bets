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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        newBook = NO;
        
        
        
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
        self.opponentLabel.hidden = YES;
        self.dateLabel.hidden = YES;
        self.plusSignImageView.hidden = NO;
        
        
        [UIView animateWithDuration:1.2 
                              delay:0 
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut
                         animations:^{ 
                             self.plusSignImageView.alpha = 0.0f;
                             //self.plusSignImageView.frame = CGRectMake(self.plusSignImageView.frame.origin.x, self.plusSignImageView.frame.origin.y, self.plusSignImageView.frame.size.width + 2, self.plusSignImageView.frame.size.height + 2);
                             self.plusSignImageView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
                             
                             
                         }    
                         completion:nil];
    }
    else
    {
        self.plusSignImageView.alpha = 0;
    }
    
    
    
    
}

- (void)viewDidUnload
{
    [self setOpponentLabel:nil];
    [self setDateLabel:nil];
    [self setPlusSignImageView:nil];
    [self setDebugPageNumber:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(id)initAsAddBook
{
    if (self = [super initWithNibName:@"BookViewController" bundle:nil])
    {   
        newBook = YES;
    }
    return self;
}



@end
