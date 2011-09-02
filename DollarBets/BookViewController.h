//
//  BookViewController.h
//  DollarBets
//
//  Created by Richard Kirk on 8/22/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opponent.h"
//#import "BookSettingsViewController.h"

@class BookFrontView;
@class BookSettingsView;
@class BookViewController;
@class Opponent;

@protocol BookViewControllerDelegate <NSObject>

-(void)opponentCreatedWithName:(NSString *)oppName by:(BookViewController *) cont;
-(void)deleteThisBook:(BookViewController *)sender;
-(void)didSelectBook:(BookViewController *)sender;

@end


@interface BookViewController : UIViewController<UIGestureRecognizerDelegate> {

    BOOL frontViewIsVisible;
    
    UILabel * debugLabel;
    
    BookFrontView *frontView;
    BookSettingsView *backView;

    UIView *containerView;	
    
    id<BookViewControllerDelegate> delegate;

}
@property (assign)BOOL frontViewIsVisible;
@property (strong, nonatomic)Opponent *opponent;
@property (strong, nonatomic)UIView *containerView;
@property (strong, nonatomic)id delegate;
@property (strong, nonatomic)BookFrontView *frontView;
@property (strong, nonatomic)BookSettingsView *backView;


@property (strong, nonatomic)UILabel *debugLabel;

-(id)initWithOpponent:(Opponent *)opp;

-(void)configButtonSelected:(id)sender;
-(void)backButtonSelected:(id)sender;
-(void)deleteButtonSelected:(id)sender;
-(void)enteredNewOpponentName:(UITextField *)sender;
-(void)didDoubleClick;

-(void)flipCurrentView;
-(void)refreshFrontView;



@end
