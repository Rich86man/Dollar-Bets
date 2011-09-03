//
//  QuickAddViewController.h
//  DollarBets
//
//  Created by Richard Kirk on 9/3/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bet.h"
#import "Opponent.h"


@interface QuickAddViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate> {
    UITextView *descriptionTextView;
    UITextField *amountTextField;
    Bet *bet;
    Opponent *opponent;
}

@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) Bet *bet;
@property (strong, nonatomic) Opponent *opponent;

-(id)initWithOpponent:(Opponent *)opp;
-(BOOL)saveQuickBet;

@end


