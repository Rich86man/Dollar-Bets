//
//  ModalImageViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 10/5/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "ModalImageViewController.h"

@implementation ModalImageViewController
@synthesize mainImageView;
@synthesize myImage;

-(id)initWithImageData:(NSData *)imageData  
{
    self = [super init];
    if (self)
    {
        
        self.myImage = [UIImage imageWithData:imageData];
        
        
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"crissXcross.png"]];
    self.mainImageView.image = self.myImage;
}

- (void)viewDidUnload
{
    [self setMainImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneButtonSelected:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
