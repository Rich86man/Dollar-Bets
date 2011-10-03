//
//  BetPage.m
//  DollarBets
//
//  Created by Richard Kirk on 9/8/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "BetPage.h"
#import "Opponent.h"

#define DEFAULT_KEYBOARD_SIZE 220.0f

@interface BetPage(PrivateMethods)
-(void)setUpMap;
-(void)setUpDollars;
-(void)setUpAmountLabel;


@end

@implementation BetPage

@synthesize bet;
@synthesize scrollView;
@synthesize titleLabel;
@synthesize dateLabel;
@synthesize descriptionTextView;
@synthesize amountLabel;
@synthesize editButton;
@synthesize keyboardToolbar;
@synthesize choosePhotoView;
@synthesize chooseAmountView;
@synthesize imagePicker;
@synthesize cameraBarButton;
@synthesize amountPicker;


-(id)initWithBet:(Bet *)aBet
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.bet = aBet;
        
    }
    return self;
    
}


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
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperBackround.png"]];
    self.titleLabel.text = self.bet.opponent.name;
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        self.cameraBarButton = nil;
    
    [self setUpAmountLabel];
  
    
    self.descriptionTextView.text = self.bet.report;
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init ];
    
    [df setDateStyle:NSDateFormatterMediumStyle];
    
    self.dateLabel.text = [df stringFromDate:self.bet.date];
    
    /*
     MKCoordinateRegion newRegion;
     // newRegion.center.latitude = [self.bet.latitude doubleValue];
     //newRegion.center.longitude = [self.bet.longitude doubleValue];
     newRegion.center.latitude = 37.37;
     newRegion.center.longitude = -96.24;
     newRegion.span.latitudeDelta = 28.49;
     newRegion.span.longitudeDelta = 31.025;    
     [self.mapView setRegion:newRegion animated:NO];
     */
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    

        
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height - 260.0;
    self.keyboardToolbar.frame = frame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification 
{

}

-(void)setUpAmountLabel
{
    UILabel *label = self.amountLabel;
    
    
    switch ([self.bet.didWin intValue]) {
        case 0:
            label.text = [NSString stringWithFormat:@"- $%i",[self.bet.amount intValue]];
            label.textColor = [UIColor redColor];
            break;
        case 1:
            label.text = [NSString stringWithFormat:@"+ $%i",[self.bet.amount intValue]];
            label.textColor = [UIColor greenColor];
            break;
        case 2:
            label.text = [NSString stringWithFormat:@"-/+ $%i",[self.bet.amount intValue]];
            label.textColor = [UIColor grayColor];
            break;
        default:
            break;
    }
    
    
}



/*
 -(void)setUpMap
 {
 if ([self.bet.latitude intValue] == 0 && [self.bet.longitude intValue] == 0)
 {
 self.mapViewCoverUpImageView.alpha = 1;
 self.mapView.alpha = 0;
 }
 else
 {
 self.mapViewCoverUpImageView.alpha = 0;
 self.mapView.alpha = 1;
 }
 
 if (self.bet.latitude)
 {
 MKCoordinateRegion newRegion;
 // newRegion.center.latitude = [self.bet.latitude doubleValue];
 //newRegion.center.longitude = [self.bet.longitude doubleValue];
 newRegion.center.latitude = 37.37;
 newRegion.center.longitude = -96.24;
 newRegion.span.latitudeDelta = 28.49;
 newRegion.span.longitudeDelta = 31.025;    
 [self.mapView setRegion:newRegion animated:NO];
 }
 
 
 
 }
 */


/*
 -(void)setUpDollars
 {
 int betAmount = [self.bet.amount intValue];
 if(betAmount == 1)
 {
 self.dollarImageView.image = [UIImage imageNamed:@"oneDollar.png"];
 }
 else if(betAmount == 5)
 {
 self.dollarImageView.image = [UIImage imageNamed:@"fiveDollar.png"];
 }
 else
 self.dollarImageView.alpha = 0;
 
 
 }
 */

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setScrollView:nil];
    [self setDateLabel:nil];
    [self setDescriptionTextView:nil];
    [self setAmountLabel:nil];
    [self setEditButton:nil];

    [self setKeyboardToolbar:nil];
    [self setChoosePhotoView:nil];

    [self setCameraBarButton:nil];
    [self setAmountPicker:nil];
    [self setChooseAmountView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}







- (IBAction)editButtonSelected:(id)sender 
{
    [self.descriptionTextView setEditable:YES];
    [self.descriptionTextView becomeFirstResponder];
    
    editState = 0;
    
    
}

- (IBAction)amountBarButtonSelected:(id)sender 
{
    switch (editState) {
        case 0:
            
            self.choosePhotoView.frame = CGRectMake(0, 240, 320, 240);
            if(self.descriptionTextView.isFirstResponder)
                [self.descriptionTextView resignFirstResponder]; 
            
            break;
        case 2:
            
            self.chooseAmountView.frame = self.choosePhotoView.frame;
            self.choosePhotoView.frame = CGRectMake(0, 240, 320, 0);
            
        default:
            break;
    }
    
    

    
    
    editState = 1;
    
    
}

- (IBAction)photoBarButtonSelected:(id)sender 
{
    switch (editState) {
        case 0:
            
            self.choosePhotoView.frame = CGRectMake(0, 240, 320, 240);
            if(self.descriptionTextView.isFirstResponder)
                [self.descriptionTextView resignFirstResponder]; 
            
            break;
            case 1:
            
            
            self.choosePhotoView.frame = self.chooseAmountView.frame;
            self.chooseAmountView.frame = CGRectMake(0, 240, 320, 0);
            
            
        default:
            break;
    }
 
    
 
       editState = 2;
}

- (IBAction)locationBarButtonSelected:(id)sender 
{
    editState = 3;
}

- (IBAction)doneBarButtonSelected:(id)sender 
{
    
    if(self.descriptionTextView.isFirstResponder)
        [self.descriptionTextView resignFirstResponder];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height;
    self.keyboardToolbar.frame = frame;
    switch (editState) {
        case 1:
            self.chooseAmountView.frame = CGRectMake(0, 280, 320, DEFAULT_KEYBOARD_SIZE);
            break;
        case 2:
            self.choosePhotoView.frame = CGRectMake(0, 280, 320, DEFAULT_KEYBOARD_SIZE);
            break;
        default:
            break;
    }
    
    [UIView commitAnimations];

    self.bet.report = self.descriptionTextView.text;
    
    
    
}

- (IBAction)takeNewPhotoSelected:(id)sender 
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [self presentModalViewController:self.imagePicker animated:YES];
    
    

}


- (IBAction)chooseFromLibrarySelected:(id)sender 
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [self presentModalViewController:self.imagePicker animated:YES];

}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.bet.picture =  UIImagePNGRepresentation(image);
    
    
    [self.descriptionTextView becomeFirstResponder];
    self.choosePhotoView.frame = CGRectMake(0, 480, 320, 0);
    
    
}


#pragma mark - UIPickerControl delegate Fucntions



// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 20;
    
}






// these methods return either a plain UIString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse. 
// If you return back a different object, the old one will be released. the view will be centered in the row rect  
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return @"Amount";
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *tempLabel = [[UILabel alloc]init];
    tempLabel.text  = [NSString stringWithFormat:@"%i",row];
    
    
    
    return tempLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.bet.amount = [NSNumber numberWithInteger:row];
    [self setUpAmountLabel ];
    
}













@end
