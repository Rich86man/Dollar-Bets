
//
//  BookViewController.h
//  DollarBets
//
// This view controller is the view controller that is supllied to the MainViewController's
// scrollview as a page. This view controller is broken up into two views, frontView and backView.  
// the frontView is the bookface and the backview is the settings view for the book. 
// There is a transition between the two views.
// I decided not to use a .xib here intentionally to show the ablity to make views without Interface Builder
// The delegate has been put in place to inform the MainViewController about the actions selected by the book 
// 
//  Created by Richard Kirk on 8/22/11.
//  Copyright (c) 2011 Home. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Opponent.h"

@class BookFrontView, BookBackView, BookViewController, Opponent;

@protocol BookViewControllerDelegate <NSObject>
-(void)nameBookFinishedWithName:(NSString *)oppName by:(BookViewController *)book;
-(void)deleteThisBook:(BookViewController *)book;
-(void)didSelectBook:(BookViewController *)book;
@end


@interface BookViewController : UIViewController < UITextFieldDelegate> 
{
    BookFrontView *frontView;
    BookBackView *backView;
    Opponent *opponent;
    BOOL frontViewIsVisible;        
}
@property (strong, nonatomic)Opponent *opponent;
@property (strong, nonatomic)BookFrontView *frontView;
@property (strong, nonatomic)BookBackView *backView;
@property (readonly, nonatomic) BOOL frontViewIsVisible;
@property (assign)id delegate;

-(id)initWithOpponent:(Opponent *)opp;

-(void)configButtonSelected:(id)sender;
-(void)backButtonSelected:(id)sender;
-(void)deleteButtonSelected:(id)sender;
-(void)addNewButtonSelected;
-(void)changeNamePressed;

-(void)flipCurrentView;
-(void)refreshFrontView;

@end
