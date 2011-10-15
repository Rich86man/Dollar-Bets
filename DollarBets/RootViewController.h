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


@interface RootViewController : UIViewController <UINavigationControllerDelegate, UIPageViewControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, TOCTableViewControllerDelegate, BetPageControllerDelegate>
{
    Opponent *opponent;
    UIViewController *currentPageBeingEdited;
    UIImagePickerController *imagePicker;
    int editState;
    int twitterKeyboard;
    NSMutableArray *gestureRecognizers;
    bool isHomeButtonHidden;
    
    
}
@property (assign) id delegate;
@property (assign) BookViewController *topBook;
@property (strong, nonatomic) Opponent *opponent;
@property (strong, nonatomic) UIViewController *currentPageBeingEdited;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) UIImagePickerController *imagePicker;


/*Table of Contents Overlay */
@property (strong, nonatomic) IBOutlet UIButton *homeButton;

/* Fancy Keyboard */
@property (strong, nonatomic) IBOutlet UIToolbar *keyboardToolbar;
@property (strong, nonatomic) IBOutlet UIView *backroundView;
@property (strong, nonatomic) IBOutlet UIView *choosePhotoView;
@property (strong, nonatomic) IBOutlet UIImageView *choosePhotoImageView;
@property (strong, nonatomic) IBOutlet UIButton *removePhotoButton;

@property (strong, nonatomic) IBOutlet UIView *chooseDidWinView;
@property (strong, nonatomic) IBOutlet UIView *betOverlayView;
@property (strong, nonatomic) IBOutlet UIImageView *rightArrow;
@property (strong, nonatomic) IBOutlet UIImageView *leftArrow;


- (IBAction)doneButtonSelected:(id)sender;


- (IBAction)chooseNewButtonSelected:(id)sender;

- (IBAction)deletePhotoButtonSelected:(id)sender;


- (IBAction)didWinButtonPresses:(id)sender;
- (IBAction)homeButtonSelected:(id)sender;

- (IBAction)betPageBackButtonPressed:(id)sender;
- (IBAction)betPageEditButtonSelected:(id)sender;
- (IBAction)keyboardToolbarButtonPressed:(UIBarButtonItem *)sender;

-(void)showHomeButton:(NSInteger)duration;
-(void)hideHomeButton:(NSInteger)duration;

-(void)hideBetPageOverlay:(NSInteger)duration;


-(void)disablePageViewGestures:(_Bool)disable;
-(void)flipToPage:(int)page animated:(bool)animated;
-(void)openBook;
-(void)closeBook;



@end
