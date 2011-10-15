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



#define KEYBOARD_FRAME_UP CGRectMake(0, 244, 320, 216);
#define KEYBOARD_FRAME_DOWN CGRectMake(0, 480, 320, 216);
#define KEYBOARD_TOOLBAR_FRAME_UP CGRectMake(0,200,320,44);
#define KEYBOARD_TOOLBAR_FRAME_DOWN CGRectMake(0,480,320,44);


@interface RootViewController ()
@property (readonly, strong, nonatomic) ModelController *modelController;
-(void)showBetPageOverlay;
@end

@implementation RootViewController
@synthesize delegate;
@synthesize topBook;
@synthesize opponent;
@synthesize currentPageBeingEdited;
@synthesize pageViewController = _pageViewController;
@synthesize modelController = _modelController;
@synthesize imagePicker;
@synthesize keyboardToolbar,choosePhotoView, choosePhotoImageView, removePhotoButton, backroundView, chooseDidWinView;
@synthesize betOverlayView, rightArrow, leftArrow;
@synthesize homeButton;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.opponent = self.topBook.opponent;
	// Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self.modelController;
    self.opponent = self.topBook.opponent;


    //UIViewController *startingViewController = [self.modelController viewControllerAtIndex:0];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.view sendSubviewToBack:self.pageViewController.view];
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    self.pageViewController.view.frame = pageViewRect;
    [self.pageViewController didMoveToParentViewController:self];    
    
    self.imagePicker.delegate = self;
    
    editState = 0;
    twitterKeyboard = 0;
    isHomeButtonHidden = YES;
    [self disablePageViewGestures:NO];
    
    
    
    self.backroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"crissXcross.png"]];
    
    [self openBook];
    
    
    
}



- (void)viewDidUnload
{
    
    [self setKeyboardToolbar:nil];
    [self setBackroundView:nil];
    [self setChoosePhotoView:nil];
    [self setChoosePhotoImageView:nil];
    [self setChooseDidWinView:nil];
    
    
    [self setHomeButton:nil];
    [self setBetOverlayView:nil];
    [self setRightArrow:nil];
    [self setLeftArrow:nil];
    [self setRemovePhotoButton:nil];
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

-(void)showHomeButton:(NSInteger)duration
{
    if(!duration)
    {
        duration = 1.0f;
    }
    
    if(isHomeButtonHidden)
    {
        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             self.homeButton.frame = CGRectMake(20, 0, 44, 61);
                         } completion:nil];
    }
    isHomeButtonHidden = NO;
}

-(void)hideHomeButton:(NSInteger)duration
{
    if (!duration) {
        duration = 0.05f;
    }
    if(!isHomeButtonHidden)
    {
        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             self.homeButton.frame = CGRectMake(20, -61, 44, 61);
                         } completion:nil];
        
    }
    isHomeButtonHidden = YES;
}

#pragma mark - TOCTableViewController Delegate Functions

-(void)didBeginQuickAdd:(id)sender
{
    self.currentPageBeingEdited = sender;
    // Need a blank image here
    //self.choosePhotoImageView.image =  [UIImage imageWithData:self.currentPageBeingEdited.bet.picture];
    [self disablePageViewGestures:YES];
}
-(void)didSelectPage:(int)index
{
    [self flipToPage:index animated:YES];
}

-(void)readyToSave:(_Bool)ready
{
    
}

-(void)savedQuickBet
{
    [self disablePageViewGestures:NO];
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
    
    if(twitterKeyboard == 0)
    {  
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.backroundView.frame = KEYBOARD_FRAME_UP;
                             self.keyboardToolbar.frame = KEYBOARD_TOOLBAR_FRAME_UP;} ];
    
    }
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
        [self hideBetPageOverlay:1.0f];
}

#pragma mark - Custom Keyboard delegate

- (IBAction)keyboardToolbarButtonPressed:(UIBarButtonItem *)sender 
{
    int newEditState = sender.tag;
    
    if(newEditState == editState)
        return;
    
    switch (editState) {
        case 0:
            if(self.currentPageBeingEdited.descriptionTextView.isFirstResponder)
                [self.currentPageBeingEdited.descriptionTextView resignFirstResponder]; 
            break;
        case 1:
            if(self.currentPageBeingEdited.amountTextView.isFirstResponder)
                [self.currentPageBeingEdited.amountTextView resignFirstResponder]; 
            
            break;
        case 2:
            self.choosePhotoView.frame = KEYBOARD_FRAME_DOWN;
            
            break;
        case 3:
            self.chooseDidWinView.frame = KEYBOARD_FRAME_DOWN;
            break;
            
        default:
            break;
    }
    
    switch (newEditState) {
            
        case 1:
            if([self.currentPageBeingEdited respondsToSelector:@selector(setAmountTextView:)])
                [self.currentPageBeingEdited.amountTextView becomeFirstResponder];
            break;
        case 2:
            if (self.currentPageBeingEdited.bet.picture)
                self.removePhotoButton.alpha = 1.0f;
            else
                self.removePhotoButton.alpha = 0.0f;
            
            self.choosePhotoView.frame = KEYBOARD_FRAME_UP;
            break;
        case 3:
            self.chooseDidWinView.frame = KEYBOARD_FRAME_UP;
            break;
            
        default:
            break;
    }
    
    
    editState = newEditState;
}


- (IBAction)doneButtonSelected:(id)sender 
{
      
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:nil
                     animations:^{
                         
                         switch (editState) 
                         {
                             case 0:
                                 if(self.currentPageBeingEdited.descriptionTextView.isFirstResponder)
                                     [self.currentPageBeingEdited.descriptionTextView resignFirstResponder]; 
                                 break;
                             case 1:
                                 if(self.currentPageBeingEdited.amountTextView.isFirstResponder)
                                     [self.currentPageBeingEdited.amountTextView resignFirstResponder]; 
                                 
                                 break;
                             case 2:
                                 self.choosePhotoView.frame = KEYBOARD_FRAME_DOWN;
                                 
                                 break;
                             case 3:
                                 self.chooseDidWinView.frame = KEYBOARD_FRAME_DOWN;
                                 break;
                             default:
                                 break;
                         }        
                         self.backroundView.frame = KEYBOARD_FRAME_DOWN;
                         self.keyboardToolbar.frame = KEYBOARD_TOOLBAR_FRAME_DOWN;
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                         if([self.currentPageBeingEdited isKindOfClass:[BetPage class]])
                         {
                             [self.currentPageBeingEdited.descriptionTextView setEditable:NO];  
                             self.currentPageBeingEdited.bet.report = self.currentPageBeingEdited.descriptionTextView.text;            
                             [self.currentPageBeingEdited.bet save];
                         }
                         
                         [self disablePageViewGestures:NO];
                     }];
    
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


- (IBAction)deletePhotoButtonSelected:(id)sender 
{self.removePhotoButton.alpha = 0.0f;
    CGRect frame = self.choosePhotoView.frame;
    frame.origin.y = 480;
    
    
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         self.choosePhotoView.frame = frame;
                     }
                     completion:^(BOOL finished)
     {
         self.currentPageBeingEdited.bet.picture = nil;
         self.choosePhotoImageView.image = nil;
         CGRect aFrame = self.choosePhotoView.frame;
         aFrame.origin.y = 240;
         
         
         [UIView animateWithDuration:1.0f
                               delay:0.5f
                             options:UIViewAnimationCurveLinear
                          animations:^{
                              self.choosePhotoView.frame = aFrame;
                          }
                          completion:nil];
         
     }];
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
    [self closeBook];
}




- (IBAction)betPageBackButtonPressed:(id)sender 
{   [self hideBetPageOverlay:0.0];
    [self flipToPage:0 animated:YES];
}

- (IBAction)betPageEditButtonSelected:(id)sender 
{
    
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
        self.removePhotoButton.alpha = 1.0;
    };
    
    myBlock();
    
    
    
    //[self.currentPageBeingEdited.descriptionTextView becomeFirstResponder];
    self.choosePhotoView.frame = KEYBOARD_FRAME_UP;
    
    //  self.imagePicker = nil;
    //  [self cameraButtonSelected:self];
    [self.imagePicker dismissModalViewControllerAnimated:YES];
    if([self.currentPageBeingEdited isKindOfClass:[BetPage class]])
        [self.currentPageBeingEdited.photoButton setEnabled:YES];
    
    
}

- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    // in case of cancel, get rid of picker
    [self.imagePicker dismissModalViewControllerAnimated:YES];
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
    
    if(self.betOverlayView.alpha < 1.0f)
    {
        
        
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             //   [self.betPageBackButton setAlpha:1.0f];
                             // [self.betPageEditButton setAlpha:1.0f];
                             [self.rightArrow setAlpha:1.0f];
                             [self.leftArrow setAlpha:1.0f];
                             [self.betOverlayView setAlpha:1.0f];
                             
                         }
                         completion:nil];
        
        
    }
    
}


-(void)hideBetPageOverlay:(NSInteger)duration
{
    if(self.betOverlayView.alpha > 0.0f)
    {
        
        
        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             // [self.betPageBackButton setAlpha:0.0f];
                             //[self.betPageEditButton setAlpha:0.0f];
                             [self.rightArrow setAlpha:0.0f];
                             [self.leftArrow setAlpha:0.0f];
                             [self.betOverlayView setAlpha:0.0f];                             
                         }
                         completion:nil];
        
        
    }
    
}


-(void)disablePageViewGestures:(_Bool)disable   
{
    if(disable)
    {NSLog(@"Disabling Gestures");
        for (UIGestureRecognizer *gesture in self.pageViewController.gestureRecognizers) {
            if([gesture isEnabled])
                [gesture setEnabled:NO];
        }
        
        
    }
    else if(!disable)
    {NSLog(@"Enabling Gestures");
        for (UIGestureRecognizer *gesture in self.pageViewController.gestureRecognizers) {
            if(![gesture isEnabled])
                [gesture setEnabled:YES];
        }
        
        
        
    }
    
}

-(void)flipToPage:(int)page animated:(_Bool)animated
{
    UIViewController *selectedPage = [self.modelController viewControllerAtIndex:page];
    NSArray *viewControllers = [NSArray arrayWithObject:selectedPage];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:animated completion:NULL];
    
}

-(void)openBook
{
    NSArray *viewControllers = [NSArray arrayWithObjects:self.topBook,nil];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    UIViewController *startingViewController = [self.modelController viewControllerAtIndex:0];
    [self.pageViewController  setViewControllers:[NSArray arrayWithObject:startingViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

-(void)closeBook
{
    topBook.view.frame = CGRectMake(0, 0, 320, 460);
    
    NSArray *viewControllers = [NSArray arrayWithObject:self.topBook];
    
    
    [self.pageViewController setViewControllers:viewControllers
                   direction:UIPageViewControllerNavigationDirectionReverse
                    animated:NO
                  completion:^(BOOL finished){    
                      [self.delegate closeBook:self.topBook];
                  }];
}


@end
