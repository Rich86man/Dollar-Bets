//
//  BookViewController.h
//  DollarBets
//
//  Created by Richard Kirk on 8/22/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opponent.h"
#import "BookSettingsViewController.h"

@class BookFrontView;
@class BookSettingsView;

@protocol BookViewControllerDelegate <NSObject>

-(void)addNewBook;
-(void)opponentCreatedWithName:(NSString *)oppName;

@end


@interface BookViewController : UIViewController {
    BOOL newBook;
    BOOL frontViewIsVisible;
    
    BookFrontView *frontView;
    BookSettingsView *backView;

    UIView *containerView;	
    
    id<BookViewControllerDelegate> delegate;

}
@property (assign)BOOL frontViewIsVisible;
@property (strong, nonatomic) Opponent * opponent;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic)id delegate;
@property (strong, nonatomic)BookFrontView *frontView;
@property (strong, nonatomic)BookSettingsView *backView;




- (void)flipCurrentView;
- (void)myTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

-(void)deleteButtonSelected;










-(id)initAsAddBook;
-(id)initWithOpponent:(Opponent *)opp;
-(IBAction)plusSignPressed:(id)sender;
-(IBAction)enteredNewOpponentName:(UITextField *)sender;
- (IBAction)configButtonPressed:(id)sender;





@end
