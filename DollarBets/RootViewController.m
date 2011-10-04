//
//  RootViewController.m
//  PageViewTest
//
//  Created by Richard Kirk on 8/29/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "RootViewController.h"

#import "ModelController.h"
#import "TOCTableViewController.h"
#import "BetPage.h"

#define DEFAULT_KEYBOARD_HEIGHT 240

@interface RootViewController ()
@property (readonly, strong, nonatomic) ModelController *modelController;
-(void)disablePageViewGestures:(bool)disable;

@end

@implementation RootViewController


@synthesize pageViewController = _pageViewController;
@synthesize modelController = _modelController;
@synthesize opponent;
@synthesize currentPageBeingEdited;

@synthesize keyboardToolbar;
@synthesize cameraBarButton;
@synthesize chooseAmountView;
@synthesize amountPicker;
@synthesize imagePicker;
@synthesize choosePhotoView;
@synthesize choosePhotoImageView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    
    UIViewController *startingViewController = [self.modelController viewControllerAtIndex:0];
    
    
    
    NSArray *viewControllers = [NSArray arrayWithObject:startingViewController];
    
    
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    
    self.pageViewController.dataSource = self.modelController;
    
    [self addChildViewController:self.pageViewController];
    //[self.view insertSubview:self.pageViewController.view atIndex:3];
    [self.view addSubview:self.pageViewController.view];
    [self.view sendSubviewToBack:self.pageViewController.view];
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    self.pageViewController.view.frame = pageViewRect;
    
    [self.pageViewController didMoveToParentViewController:self];    
    
    /*
    for (UIGestureRecognizer* gesture  in self.pageViewController.gestureRecognizers) {
        [gestureRecognizers addObject:gesture];
       
        
    }
    */
    
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    //self.modelController.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        [self.cameraBarButton setEnabled:NO];
    
    self.imagePicker.delegate = self;
    
    editState = 0;
    [self disablePageViewGestures:NO];
    
}

- (void)viewDidUnload
{
    
    [self setKeyboardToolbar:nil];
    [self setChooseAmountView:nil];
    [self setChoosePhotoView:nil];
    [self setAmountPicker:nil];
    [self setCameraBarButton:nil];
    [self setChoosePhotoImageView:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (ModelController *)modelController
{
    /*
     Return the model controller object, creating it if necessary.
     In more complex implementations, the model controller may be passed to the view controller.
     */
    if (!_modelController) {
        _modelController = [[ModelController alloc] initWithOpponent:self.opponent];
        _modelController.rvc = self;
    }
    return _modelController;
}

-(void)disablePageViewGestures:(_Bool)disable   
{
    if(disable)
    {
        for (UIGestureRecognizer *gesture in self.pageViewController.gestureRecognizers) {
            [gesture setEnabled:NO];
        }
        

    }
    else if(!disable)
    {
        for (UIGestureRecognizer *gesture in self.pageViewController.gestureRecognizers) {
            [gesture setEnabled:YES];
        }
        

        
    }
    
}
-(void)didSelectPage:(int)index
{
    
    
    NSLog(@"didSelectPage:%i",index);
    
    UIViewController *selectedPage = [self.modelController viewControllerAtIndex:index];
    NSArray *viewControllers = [NSArray arrayWithObject:selectedPage];
    
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    
    
}

#pragma mark - UIPageViewController delegate methods

/*
 - (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
 {
 
 
 }
 */

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

#pragma mark - Custom Keyboard stuff

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

#pragma mark - BetPage Delegate functions

-(void)didSelectEdit:(BetPage *)onPage
{
    self.currentPageBeingEdited = onPage;
    [self.amountPicker selectRow:[self.currentPageBeingEdited.bet.amount integerValue] inComponent:0 animated:NO];
    self.choosePhotoImageView.image =  [UIImage imageWithData:self.currentPageBeingEdited.bet.picture];
    [self disablePageViewGestures:YES];
   /*
    CGRect frame = self.currentPageBeingEdited.view.frame;
   
    frame.origin.x = frame.origin.x - 45;
    frame.origin.y = frame.origin.y - 45;
    
    
    [UIView animateWithDuration:0.3f animations:^{
        self.currentPageBeingEdited.view.frame = frame;
        
    }];
    */
    
}





- (IBAction)amountButtonSelected:(id)sender 
{
    switch (editState) {
        case 0:
            
            self.chooseAmountView.frame = CGRectMake(0, 240, 320, DEFAULT_KEYBOARD_HEIGHT);
            if(self.currentPageBeingEdited.descriptionTextView.isFirstResponder)
                [self.currentPageBeingEdited.descriptionTextView resignFirstResponder]; 
            
            break;
        case 2:
            
            self.chooseAmountView.frame = self.choosePhotoView.frame;
            self.choosePhotoView.frame = CGRectMake(0, 480, 320, DEFAULT_KEYBOARD_HEIGHT);
            
        default:
            break;
    }
    
    editState = 1;
    
}

- (IBAction)cameraButtonSelected:(id)sender 
{
    switch (editState) {
        case 0:
            self.choosePhotoView.frame = CGRectMake(0, 240, 320, DEFAULT_KEYBOARD_HEIGHT);
            if(self.currentPageBeingEdited.descriptionTextView.isFirstResponder)
                [self.currentPageBeingEdited.descriptionTextView resignFirstResponder]; 
            
            break;
        case 1:
            self.choosePhotoView.frame = self.chooseAmountView.frame;
            self.chooseAmountView.frame = CGRectMake(0, 480, 320, DEFAULT_KEYBOARD_HEIGHT);
            
        default:
            break;
    }
    
    
    
    editState = 2;
}

- (IBAction)doneButtonSelected:(id)sender 
{
    
    [self.currentPageBeingEdited.descriptionTextView setEditable:NO];  
    
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height;
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        
        switch (editState) {
            case 0:
                if(self.currentPageBeingEdited.descriptionTextView.isFirstResponder)
                    [self.currentPageBeingEdited.descriptionTextView resignFirstResponder]; 
                
                break;
            case 1:
                self.chooseAmountView.frame = CGRectMake(0, 480, 320, DEFAULT_KEYBOARD_HEIGHT);
                break;
            case 2:
                self.choosePhotoView.frame = CGRectMake(0, 480, 320, DEFAULT_KEYBOARD_HEIGHT);
                break;
            default:
                break;
        }
        
        self.keyboardToolbar.frame = frame;
        
        
        
        
        
    }completion:^(BOOL finished){
        
        
        self.currentPageBeingEdited.bet.report = self.currentPageBeingEdited.descriptionTextView.text;
        self.currentPageBeingEdited.editButton.alpha = 1;    

    }];
    /*
    CGRect pageFrame = self.currentPageBeingEdited.view.frame;
    pageFrame.origin.x = pageFrame.origin.x + 45;
    pageFrame.origin.y = pageFrame.origin.y + 45;
    
    
    [UIView animateWithDuration:0.3f animations:^{
        self.currentPageBeingEdited.view.frame = pageFrame;
        
    }];
    */
    
    
    [self disablePageViewGestures:NO];
    
    NSError *error =  nil;
    [self.currentPageBeingEdited.bet.managedObjectContext save:&error];
    
    if(error)
    {
        NSLog(@"%@\n", [error  description]);
    }
    
 
    editState = 0;
}

- (IBAction)newPhotoButttonSelected:(id)sender 
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [self presentModalViewController:self.imagePicker animated:YES];
    

}

- (IBAction)photoLibraryButtonSelected:(id)sender 
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
    self.choosePhotoImageView.image = image;
    
    self.currentPageBeingEdited.bet.picture =  UIImagePNGRepresentation(image);
    
    
    [self.currentPageBeingEdited.descriptionTextView becomeFirstResponder];
    self.choosePhotoView.frame = CGRectMake(0, 480, 320, DEFAULT_KEYBOARD_HEIGHT);
    
    
       
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
    self.currentPageBeingEdited.bet.amount = [NSNumber numberWithInteger:row];
    [self.currentPageBeingEdited setUpAmountLabel];
    
}







@end
