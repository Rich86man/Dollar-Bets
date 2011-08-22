//
//  BookViewController.h
//  DollarBets
//
//  Created by Richard Kirk on 8/22/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookViewController : UIViewController {
    UILabel *opponentLabel;
    UILabel *dateLabel;
    UIImageView *plusSignImageView;
    UILabel *debugPageNumber;
    bool newBook;
}

@property (strong, nonatomic) IBOutlet UILabel *opponentLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *plusSignImageView;
@property (strong, nonatomic) IBOutlet UILabel *debugPageNumber;


-(id)initAsAddBook;

@end
