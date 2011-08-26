//
//  BookSettingsViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 8/25/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "BookSettingsViewController.h"

@implementation BookSettingsViewController
@synthesize deleteButton;
@synthesize popOverController;
@synthesize popOver;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
}

- (void)viewDidUnload
{
    [self setDeleteButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)deleteButtonPressed:(id)sender 
{

        if (self.popOverController == nil) {
            self.popOverController = [[PopOverController alloc] initWithStyle:UITableViewStylePlain];
            self.popOverController.delegate = self;
            self.popOver = [[UIPopoverController alloc] initWithContentViewController:self.popOverController];               
        }
        [self.popOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];



}

-(void)didSelectOption:(_Bool)deleteBook
{
    
    
    
}





@end
