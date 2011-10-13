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
    id currentPageBeingEdited;
    UIImagePickerController *imagePicker;
    int editState;
    int twitterKeyboard;
    NSMutableArray *gestureRecognizers;
    
    bool isHomeButtonHidden;
    
    
}
@property (assign)id delegate;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) Opponent *opponent;
@property (strong, nonatomic) BookViewController *currentBook;
@property (strong, nonatomic) BetPage *currentPageBeingEdited;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;

//@property (strong, nonatomic) id currentPageBeingEdited;
@property (strong, nonatomic) IBOutlet UIToolbar *keyboardToolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cameraBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (strong, nonatomic) IBOutlet UIView *chooseAmountView;
@property (strong, nonatomic) IBOutlet UIPickerView *amountPicker;

@property (strong, nonatomic) IBOutlet UIView *choosePhotoView;
@property (strong, nonatomic) IBOutlet UIImageView *choosePhotoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *choosePhotoPoloroidImageView;
@property (strong, nonatomic) IBOutlet UIButton *chooseNewPhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *removePhotoButton;

@property (strong, nonatomic) IBOutlet UIView *chooseDidWinView;

@property (strong, nonatomic) IBOutlet UIView *betOverlayView;

@property (strong, nonatomic) IBOutlet UIButton *betPageBackButton;
@property (strong, nonatomic) IBOutlet UIButton *betPageEditButton;

@property (strong, nonatomic) IBOutlet UIImageView *rightArrow;
@property (strong, nonatomic) IBOutlet UIImageView *leftArrow;

- (IBAction)amountButtonSelected:(id)sender;
- (IBAction)cameraButtonSelected:(id)sender;
- (IBAction)doneButtonSelected:(id)sender;
- (IBAction)ribbonBarButtonSelected:(id)sender;

- (IBAction)chooseNewButtonSelected:(id)sender;

- (IBAction)deletePhotoButtonSelected:(id)sender;


- (IBAction)didWinButtonPresses:(id)sender;
- (IBAction)homeButtonSelected:(id)sender;

- (IBAction)betPageBackButtonPressed:(id)sender;
- (IBAction)betPageEditButtonSelected:(id)sender;

-(void)showHomeButton:(NSInteger)duration;
-(void)hideHomeButton:(NSInteger)duration;

-(void)hideBetPageOverlay:(NSInteger)duration;




@end
