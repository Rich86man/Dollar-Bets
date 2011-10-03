//
//  BetPage.h
//  DollarBets
//
//  Created by Richard Kirk on 9/8/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Bet.h"

@interface BetPage : UIViewController <MKMapViewDelegate,UIImagePickerControllerDelegate, UIGestureRecognizerDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UITextViewDelegate>
{
    Bet *bet;
    UIScrollView *scrollView;
    UILabel *titleLabel;
    UILabel *dateLabel;
    UIImageView *dollarImageView;
    UIImageView *mapViewCoverUpImageView;
    UITextView *descriptionTextView;
    MKMapView *mapView;
    UIImagePickerController *imagePicker;
    int editState;
    

}
@property (strong, nonatomic) Bet *bet;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIToolbar *keyboardToolbar;
@property (strong, nonatomic) IBOutlet UIView *choosePhotoView;
@property (strong, nonatomic) IBOutlet UIView *chooseAmountView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cameraBarButton;
@property (strong, nonatomic) IBOutlet UIPickerView *amountPicker;




-(id)initWithBet:(Bet*)aBet;

- (IBAction)editButtonSelected:(id)sender;
- (IBAction)amountBarButtonSelected:(id)sender;
- (IBAction)photoBarButtonSelected:(id)sender;
- (IBAction)locationBarButtonSelected:(id)sender;


- (IBAction)doneBarButtonSelected:(id)sender;

- (IBAction)takeNewPhotoSelected:(id)sender;
- (IBAction)chooseFromLibrarySelected:(id)sender;

@end


