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
@class BookViewController;

@protocol BookViewControllerDelegate <NSObject>

-(void)addNewBook;
-(void)opponentCreatedWithName:(NSString *)oppName by:(BookViewController *) cont;
-(void)deleteThisBook:(BookViewController *)sender;

@end


@interface BookViewController : UIViewController {
    BOOL newBook;
    BOOL frontViewIsVisible;
    
    UILabel * debugLabel;
    
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


@property (strong, nonatomic)UILabel *debugLabel;



- (void)flipCurrentView;
- (void)myTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

-(void)deleteButtonSelected:(id)sender;










-(id)initAsAddBook;
-(id)initWithOpponent:(Opponent *)opp;
-(IBAction)plusSignPressed:(id)sender;
-(void)enteredNewOpponentName:(UITextField *)sender;
- (IBAction)configButtonPressed:(id)sender;
-(void)backButtonSelected:(id)sender;
-(void)setDateLabel:(NSDate *)date;
-(void)showConfigAndDate;




@end
