//
//  ModalImageViewController.h
//  DollarBets
//
//  Created by Richard Kirk on 10/5/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalImageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) UIImage *myImage;
- (IBAction)doneButtonSelected:(id)sender;

-(id)initWithImageData:(NSData *)imageData;

@end
