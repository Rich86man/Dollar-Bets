//
//  RootViewController.h
//  PageViewTest
//
//  Created by Richard Kirk on 8/29/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opponent.h"
#import "TOCTableViewController.h"
#import "BetPage.h"
#import "BookViewController.h"
#import "RKPageViewController.h"

@interface RootBookViewController : UIViewController <UINavigationControllerDelegate, UIPageViewControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, TOCTableViewControllerDelegate, BetPageControllerDelegate>
{
    Opponent *opponent;
    BetPage *currentPageBeingEdited;
    UIImagePickerController *imagePicker;
    int editState;
    int twitterKeyboard;
    NSMutableArray *gestureRecognizers;
    bool isHomeButtonHidden;
    bool isBetPageOverlayShowing;
    
    
    
}
@property (assign) id delegate;
@property (assign) BookViewController *topBook;
@property (strong, nonatomic) Opponent *opponent;
@property (strong, nonatomic) BetPage *currentPageBeingEdited;
@property (strong, nonatomic) RKPageViewController *pageViewController;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
/* Fancy Keyboard */
@property (strong, nonatomic) IBOutlet UIToolbar *keyboardToolbar;
@property (strong, nonatomic) IBOutlet UIView *backroundView;
@property (strong, nonatomic) IBOutlet UIView *choosePhotoView;
@property (strong, nonatomic) IBOutlet UIImageView *choosePhotoImageView;
@property (strong, nonatomic) IBOutlet UIButton *removePhotoButton;
@property (strong, nonatomic) IBOutlet UIView *chooseDidWinView;

/* Custom Keyboard Functions */
- (IBAction)keyboardToolbarButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)doneButtonSelected:(id)sender;
- (IBAction)chooseNewPhotoButtonSelected:(id)sender;
- (IBAction)deletePhotoButtonSelected:(id)sender;
- (IBAction)didWinButtonPressed:(id)sender;
-(void)changeEditStateTo:(int)state;

/* UIPageViewController helper functions */
-(void)flipToPage:(int)page animated:(bool)animated forward:(bool)forward;
-(void)openBook;
-(void)closeBook;

@end
