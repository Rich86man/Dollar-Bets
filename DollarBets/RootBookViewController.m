//
//  RootViewController.m
//  PageViewTest
//
//  Created by Richard Kirk on 8/29/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "RootBookViewController.h"

#import "BookModelController.h"
#import "TOCTableViewController.h"
#import "ModalImageViewController.h"
#import "BetPage.h"
#import "Twitter/Twitter.h"
#import "RootContainerViewController.h"



#define KEYBOARD_FRAME_UP CGRectMake(0, 244, 320, 216);
#define KEYBOARD_FRAME_DOWN CGRectMake(0, 480, 320, 216);
#define KEYBOARD_TOOLBAR_FRAME_UP CGRectMake(0,200,320,44);
#define KEYBOARD_TOOLBAR_FRAME_DOWN CGRectMake(0,480,320,44);


@interface RootBookViewController ()
@property (readonly, strong, nonatomic) BookModelController *modelController;

-(void)setupPageViewController;
-(void)changeEditStateTo:(int)state;
@end

@implementation RootBookViewController
@synthesize delegate;
@synthesize topBook;
@synthesize opponent;
@synthesize currentPageBeingEdited;
@synthesize pageViewController = _pageViewController;
@synthesize modelController = _modelController;
@synthesize imagePicker;
@synthesize keyboardToolbar,choosePhotoView, choosePhotoImageView, removePhotoButton, backroundView, chooseDidWinView;



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"padded.png"]];
    self.opponent = self.topBook.opponent;
	[self setupPageViewController];
    self.imagePicker.delegate = self;
    
    editState = 0;
    twitterKeyboard = 0;
    isHomeButtonHidden = YES;
    [self.pageViewController  disablePageViewGestures:NO];
    self.backroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"crissXcross"]];
    
    [self openBook];
}


- (void)viewDidUnload
{    
    [self setKeyboardToolbar:nil];
    [self setBackroundView:nil];
    [self setChoosePhotoView:nil];
    [self setChoosePhotoImageView:nil];
    [self setChooseDidWinView:nil];
    [self setRemovePhotoButton:nil];
    [super viewDidUnload];
    
}

- (BookModelController *)modelController
{
    /*
     Return the model controller object, creating it if necessary.
     In more complex implementations, the model controller may be passed to the view controller.
     */
    if (!_modelController) {
        _modelController = [[BookModelController alloc] initWithOpponent:self.opponent];
        _modelController.rvc = self;
    }
    return _modelController;
}


#pragma mark - TOCTableViewController Delegate Functions

-(void)didSelectPage:(int)index
{
    [self.pageViewController disablePageViewGestures:NO];
    [self flipToPage:index animated:YES forward:YES];
}


-(void)didBeginQuickAdd:(id)sender
{
    self.currentPageBeingEdited = sender;
    [self.pageViewController disablePageViewGestures:YES];
}


-(void)savedQuickBet
{
    [self.pageViewController disablePageViewGestures:NO];
    
    if ([self.currentPageBeingEdited.descriptionTextView isFirstResponder]) {
        [self.currentPageBeingEdited.descriptionTextView resignFirstResponder];
    }
}


-(void)didselectHomeButton
{
    [self closeBook];
}


-(void)didBeginEditingDescription
{
    [self changeEditStateTo:0];
}


-(void)editingTable:(BOOL)editing
{
    [self.pageViewController disablePageViewGestures:editing];
}


#pragma mark - Custom Keyboard stuff

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}


- (void)viewWillDisappear:(BOOL)animated 
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notification 
{
    
    if(twitterKeyboard == 0)
    {  
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.backroundView.frame = KEYBOARD_FRAME_UP;
                             self.keyboardToolbar.frame = KEYBOARD_TOOLBAR_FRAME_UP;} ];
        
    }
}


- (IBAction)keyboardToolbarButtonPressed:(UIBarButtonItem *)sender 
{
    [self changeEditStateTo:sender.tag];
}


- (IBAction)doneButtonSelected:(id)sender 
{
    if ([currentPageBeingEdited isKindOfClass:[BetPage class]]) {
        [currentPageBeingEdited doneEditing];
    }
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:0
                     animations:^{
                         NSLog(@"editSate: %i", editState);
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
                             [self.pageViewController disablePageViewGestures:NO];
                             
                         }
                         
                         
                     }];
    
    editState = 0;
}


- (IBAction)chooseNewPhotoButtonSelected:(id)sender 
{
    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:YES];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo", @"Choose Existing", nil];
        [actionSheet showInView:self.view];
    } 
    else 
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];     
        [self presentModalViewController:self.imagePicker animated:YES];
    }
    
}


- (IBAction)deletePhotoButtonSelected:(id)sender 
{
    removePhotoButton.alpha = 0.0f;
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         self.choosePhotoView.frame = KEYBOARD_FRAME_DOWN;
                     }
                     completion:^(BOOL finished)
     {
         self.currentPageBeingEdited.bet.picture = nil;
         self.choosePhotoImageView.image = nil;
         
         [UIView animateWithDuration:1.0f
                               delay:0.5f
                             options:UIViewAnimationCurveLinear
                          animations:^{
                              self.choosePhotoView.frame = KEYBOARD_FRAME_UP;
                          }
                          completion:nil];
         
     }];
}


- (IBAction)didWinButtonPressed:(id)sender 
{
    NSNumber *betOutcome = [NSNumber numberWithInt:[(UIButton *)sender tag]];
    
    if (![betOutcome isEqualToNumber:self.currentPageBeingEdited.bet.didWin]) 
    {
        self.currentPageBeingEdited.bet.didWin = betOutcome;
        [self.currentPageBeingEdited setUpAmountLabel];
    }
}


#pragma mark - BetPage Delegate functions

-(void)betPageWillAppear:(BetPage *)betPage
{
    self.currentPageBeingEdited = betPage;
    isBetPageOverlayShowing = NO;
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
        [self dismissModalViewControllerAnimated:YES];
    } ];
    
    NSString *tweetString = [NSString stringWithFormat:@"%@ bet me $%@ that: %@",onPage.bet.opponent.name , [onPage.bet.amount stringValue],onPage.bet.report] ;
    if([tweetString length] > 160)
    {
        NSRange range = NSMakeRange(0, 160);
        tweetString = [tweetString substringWithRange:range];
    }
    
    [tweet setInitialText:tweetString];
    
    if(onPage.bet.picture)
        [tweet addImage:[UIImage imageWithData:onPage.bet.picture]];
    
    [self presentModalViewController:tweet animated:YES];
}


#pragma mark - Bet Page Overlay Functions

-(void)didselectBack:(BetPage *)onPage
{
    [self flipToPage:0 animated:YES forward:NO];
}

-(void)didselectEdit:(BetPage *)onPage
{
    currentPageBeingEdited = onPage;
    self.choosePhotoImageView.image =  [UIImage imageWithData:self.currentPageBeingEdited.bet.picture];
    [self.pageViewController disablePageViewGestures:YES];
    
}


#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
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
    
    self.choosePhotoView.frame = KEYBOARD_FRAME_UP;
    
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
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (buttonIndex == 0) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;     
    }    
    [self presentModalViewController:self.imagePicker animated:YES];
}


#pragma mark - UIPageViewController Helper Functions

-(void)setupPageViewController
{
    RKPageViewController *pageView = [[RKPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [pageView setDelegate:self];
    [pageView setDataSource:self.modelController];
    
    [self addChildViewController:pageView];
    [self.view insertSubview:pageView.view atIndex:1];
    self.view.gestureRecognizers = pageView.gestureRecognizers;
    //[self.view addSubview:pageView.view];
    
    //[self.view sendSubviewToBack:pageView.view];
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    // CGRect pageViewRect = self.view.bounds;
    pageView.view.frame = CGRectMake(0, 11, 305, 438);
    self.pageViewController = pageView;
    [self.pageViewController didMoveToParentViewController:self];    
    
    
}


-(void)flipToPage:(int)page animated:(_Bool)animated forward:(_Bool)forward
{
    UIViewController *selectedPage = [self.modelController viewControllerAtIndex:page];
    NSArray *viewControllers = [NSArray arrayWithObject:selectedPage];
    
    if (forward) 
    {
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:animated completion:NULL];
    }
    else
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:animated completion:NULL];
    
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
    [topBook refreshFrontView];
    NSArray *viewControllers = [NSArray arrayWithObject:self.topBook];
    
    /* staying away from retain cycles */
    __block typeof(self) bself = self;
    
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:YES
                                     completion:^(BOOL finished){    
                                         if(finished)
                                             [bself.delegate closeBook:bself.topBook];
                                     }];
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    if(completed)
    {
    
        if( [[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[BookViewController class]])
        {
                       [self.delegate closeBook:self.topBook];
        }
    }
}


-(void)changeEditStateTo:(int)state
{
    int newEditState = state;
    
    if(newEditState == editState)
        return;
    
    if (!self.pageViewController.gesturesDisabled)
        [self.pageViewController disablePageViewGestures:YES];
    
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
    
    switch (newEditState) 
    {
            
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

@end
