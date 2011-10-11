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
#import "ModalImageViewController.h"
#import "BetPage.h"
#import "Twitter/Twitter.h"
#import "RootContainerViewController.h"


#define DEFAULT_KEYBOARD_HEIGHT 240

@interface RootViewController ()
@property (readonly, strong, nonatomic) ModelController *modelController;


-(void)disablePageViewGestures:(bool)disable;
-(void)showBetPageOverlay;
-(void)hideBetPageOverlay;

@end

@implementation RootViewController
@synthesize rightArrow;
@synthesize leftArrow;


@synthesize pageViewController = _pageViewController;
@synthesize modelController = _modelController;
@synthesize opponent;
@synthesize currentPageBeingEdited;

@synthesize keyboardToolbar;
@synthesize cameraBarButton;
@synthesize doneBarButton;
@synthesize chooseAmountView;
@synthesize amountPicker;
@synthesize imagePicker;
@synthesize homeButton;
@synthesize choosePhotoView;
@synthesize choosePhotoImageView;
@synthesize removePhotoButton;
@synthesize chooseDidWinView;
@synthesize betOverlayView;
@synthesize betPageBackButton;
@synthesize betPageEditButton;
@synthesize delegate;




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
    
    
  
    
    self.imagePicker.delegate = self;
    
    editState = 0;
    twitterKeyboard = 0;
    
    [self disablePageViewGestures:NO];
    
    UIColor *pattern = [UIColor colorWithPatternImage:[UIImage imageNamed:@"crissXcross.png"]];
    
    self.chooseAmountView.backgroundColor = pattern;
    self.choosePhotoView.backgroundColor = pattern;
    self.chooseDidWinView.backgroundColor = pattern;
    
                        
    
    
}

- (void)viewDidUnload
{
    
    [self setKeyboardToolbar:nil];
    [self setChooseAmountView:nil];
    [self setChoosePhotoView:nil];
    [self setAmountPicker:nil];
    [self setCameraBarButton:nil];
    [self setChoosePhotoImageView:nil];
    [self setChooseDidWinView:nil];
    [self setDoneBarButton:nil];
    [self setRemovePhotoButton:nil];
    [self setHomeButton:nil];
    [self setBetOverlayView:nil];
    [self setBetPageBackButton:nil];
    [self setBetPageEditButton:nil];
    [self setRightArrow:nil];
    [self setLeftArrow:nil];
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

-(void)showHomeButton:(_Bool)on
{
    
    if(on && self.homeButton.frame.origin.y < 0)
    {
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             self.homeButton.frame = CGRectMake(20, 0, 44, 61);
                         } completion:nil];
        
    }
   else  if(!on && self.homeButton.frame.origin.y == 0)
    {
        [UIView animateWithDuration:0.05f
                              delay:0.0f
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             self.homeButton.frame = CGRectMake(20, -61, 44, 61);
                         } completion:nil];
        
    }
    else if (self.homeButton.frame.origin.y <= 0){
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             self.homeButton.frame = CGRectMake(20, 0, 44, 61);
                         } completion:nil];
    }
    
}

#pragma mark - TOCTableViewController Delegate Functions

-(void)didBeginQuickEdit:(id)sender
{
    self.currentPageBeingEdited = sender;
    [self.amountPicker selectRow:1 inComponent:0 animated:NO];
//  self.doneBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doneButtonSelected:)]; 
    
    
    // Need a blank image here
    //self.choosePhotoImageView.image =  [UIImage imageWithData:self.currentPageBeingEdited.bet.picture];
    [self disablePageViewGestures:YES];

    
    
    
    
}
-(void)didSelectPage:(int)index
{
    
    
    NSLog(@"didSelectPage:%i",index);
    
    UIViewController *selectedPage = [self.modelController viewControllerAtIndex:index];
    NSArray *viewControllers = [NSArray arrayWithObject:selectedPage];
    
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    
    
}

-(void)readyToSave:(_Bool)ready
{

        self.doneBarButton.enabled = ready;

    
}

-(void)savedQuickBet
{
    [self disablePageViewGestures:NO];
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

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    /*
    NSLog(@"didFinishAnimating :  %@\ttransitionCompleted : %@", finished ? @"yes" : @"no",completed ? @"yes" : @"no");
    
    for (UIViewController *vc in previousViewControllers) {
        NSLog(@"\t%@",[vc description]);
    }
     */
    
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
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSLog(@"keyboard Size height = %f  width = %f",keyboardSize.height, keyboardSize.width);
                                                                         
                                                                         
    if(twitterKeyboard == 0)
    {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height - 260.0;
    self.keyboardToolbar.frame = frame;
    
    [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification 
{
    
}

#pragma mark - BetPage Delegate functions

-(void)betPageWillAppear:(BetPage *)betPage
{
    self.currentPageBeingEdited = betPage;
}


-(void)didSelectphoto:(BetPage *)onPage
{
    ModalImageViewController *modal = [[ModalImageViewController alloc]initWithImageData:onPage.bet.picture];
    
    [self presentModalViewController:modal animated:YES];
    
    
}

-(void)didSelectTweet:(BetPage *)onPage
{
    twitterKeyboard = 1;
    TWTweetComposeViewController *tweet = [[TWTweetComposeViewController alloc]init];
    [tweet setCompletionHandler:^(TWTweetComposeViewControllerResult result){
        
        twitterKeyboard = 0;
        [tweet dismissModalViewControllerAnimated:YES];
    } ];
    
    NSString *tweetString = [NSString stringWithFormat:@"%@ bet me $%@ that:%@",onPage.bet.opponent.name , [onPage.bet.amount stringValue],onPage.bet.report];
    
    
    [tweet setInitialText:tweetString];
    
    if(onPage.bet.picture)
        [tweet addImage:[UIImage imageWithData:onPage.bet.picture]];
    
    [self presentModalViewController:tweet animated:YES];
    
    
}

-(void)didTapPage:(BetPage *)onPage
{
    
    if (self.betOverlayView.alpha == 0)
        [self showBetPageOverlay];
    else
        [self hideBetPageOverlay];
}

#pragma mark - Custom Keyboard delegate

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
            break;
        case 3:
            self.chooseAmountView.frame = self.chooseDidWinView.frame;
            self.chooseDidWinView.frame = CGRectMake(0, 480, 320, DEFAULT_KEYBOARD_HEIGHT);
            break;
            
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
            break;
            case 2:
            self.choosePhotoView.frame = CGRectMake(0, 240, 320, DEFAULT_KEYBOARD_HEIGHT);
            break;
            
        case 3:
            self.choosePhotoView.frame = self.chooseDidWinView.frame;
            self.chooseDidWinView.frame = CGRectMake(0, 480, 320, DEFAULT_KEYBOARD_HEIGHT);
            break;
        default:
            break;
    }
    
    
    
    editState = 2;
}

- (IBAction)ribbonBarButtonSelected:(id)sender 
{

    
    
    
    
    
    switch (editState) {
        case 0:
            self.chooseDidWinView.frame = CGRectMake(0, 240, 320, DEFAULT_KEYBOARD_HEIGHT);
            if(self.currentPageBeingEdited.descriptionTextView.isFirstResponder)
                [self.currentPageBeingEdited.descriptionTextView resignFirstResponder]; 
            break;
        case 1:
            self.chooseDidWinView.frame = self.chooseAmountView.frame;
            self.chooseAmountView.frame = CGRectMake(0, 480, 320, DEFAULT_KEYBOARD_HEIGHT);
            break;
        case 2:
            self.chooseDidWinView.frame = self.choosePhotoView.frame;
            self.choosePhotoView.frame = CGRectMake(0, 480, 320, DEFAULT_KEYBOARD_HEIGHT);
            break;
        default:
            break;
    }
    
    
    
    editState = 3;
    
    
}


- (IBAction)doneButtonSelected:(id)sender 
{
    
       
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
            case 3:
                self.chooseDidWinView.frame = CGRectMake(0, 480, 320, DEFAULT_KEYBOARD_HEIGHT);
                break;
            default:
                break;
        }
        
        self.keyboardToolbar.frame = frame;
        
        
        
        
        
    }completion:^(BOOL finished){
        
        
                
        if([self.currentPageBeingEdited respondsToSelector:@selector(setEditButton:)])
        {
            [self.currentPageBeingEdited.descriptionTextView setEditable:NO];  

            self.currentPageBeingEdited.bet.report = self.currentPageBeingEdited.descriptionTextView.text;
                    self.currentPageBeingEdited.editButton.alpha = 1;  
            
            [self disablePageViewGestures:NO];
            
            NSError *error =  nil;
            [self.currentPageBeingEdited.bet.managedObjectContext save:&error];
            
            if(error)
            {
                NSLog(@"%@\n", [error  description]);
            }
            

            
            
        }
        

        
    }];
    /*
     CGRect pageFrame = self.currentPageBeingEdited.view.frame;
     pageFrame.origin.x = pageFrame.origin.x + 45;
     pageFrame.origin.y = pageFrame.origin.y + 45;
     
     
     [UIView animateWithDuration:0.3f animations:^{
     self.currentPageBeingEdited.view.frame = pageFrame;
     
     }];
     */
    
      
    editState = 0;
}


- (IBAction)chooseNewButtonSelected:(id)sender 
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    [self.imagePicker setDelegate:self];
    self.imagePicker.allowsEditing = YES;

    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo", @"Choose Existing", nil];
        [actionSheet showInView:self.view];
    } else {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;     
        [self presentModalViewController:self.imagePicker animated:YES];
    }
    
}


- (IBAction)deletePhotoButtonSelected:(id)sender {
}

- (IBAction)didWinButtonPresses:(id)sender 
{
    
    NSNumber *betOutcome = [NSNumber numberWithInt:[(UIButton *)sender tag]];
    
    if (![betOutcome isEqualToNumber:self.currentPageBeingEdited.bet.didWin]) {
        
  
        self.currentPageBeingEdited.bet.didWin = betOutcome;
        [self.currentPageBeingEdited setUpAmountLabel];
    }
    
    
    
}

- (IBAction)homeButtonSelected:(id)sender 
{
    [self.delegate closeBook];
    
}

- (IBAction)betPageBackButtonPressed:(id)sender 
{
    UIViewController *startingViewController = [self.modelController viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];

}

- (IBAction)betPageEditButtonSelected:(id)sender 
{
    [self.amountPicker selectRow:[self.currentPageBeingEdited.bet.amount integerValue] inComponent:0 animated:NO];
    self.choosePhotoImageView.image =  [UIImage imageWithData:self.currentPageBeingEdited.bet.picture];
    [self disablePageViewGestures:YES];
    [self.currentPageBeingEdited editButtonSelected];
    
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *newImage = [info valueForKey:UIImagePickerControllerEditedImage];
    if(!newImage)
        newImage = [info valueForKey:UIImagePickerControllerOriginalImage];

    
    void (^myBlock) () = ^{
    self.currentPageBeingEdited.bet.picture =  UIImagePNGRepresentation(newImage);
            self.choosePhotoImageView.image = newImage;
    };
    
    myBlock();
    
    

    //[self.currentPageBeingEdited.descriptionTextView becomeFirstResponder];
    self.choosePhotoView.frame = CGRectMake(0, 240, 320, DEFAULT_KEYBOARD_HEIGHT);
    
  //  self.imagePicker = nil;
  //  [self cameraButtonSelected:self];
    [self.currentPageBeingEdited.photoButton setEnabled:YES];
    [self.imagePicker dismissModalViewControllerAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    // in case of cancel, get rid of picker
    [self.imagePicker dismissModalViewControllerAnimated:YES];
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

#pragma mark - ActionSheet delegate functions
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;     
    }
    
    [self presentModalViewController:self.imagePicker animated:YES];
  
}


-(void)showBetPageOverlay
{
    
    if(self.betPageBackButton.alpha < 1.0f)
    {
    
        
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.betPageBackButton setAlpha:1.0f];
                             [self.betPageEditButton setAlpha:1.0f];
                             [self.rightArrow setAlpha:1.0f];
                             [self.leftArrow setAlpha:1.0f];
                             [self.betOverlayView setAlpha:1.0f];
                             
                         }
                         completion:nil];

    
    }
    
}


-(void)hideBetPageOverlay
{
    if(self.betPageBackButton.alpha > 0.0f)
    {
        
        
        [UIView animateWithDuration:0.05f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.betPageBackButton setAlpha:0.0f];
                             [self.betPageEditButton setAlpha:0.0f];
                             [self.rightArrow setAlpha:0.0f];
                             [self.leftArrow setAlpha:0.0f];
                             [self.betOverlayView setAlpha:0.0f];                             
                         }
                         completion:nil];
        
        
    }
    
}



@end
