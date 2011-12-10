//
//  MainViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 8/21/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "MainViewController.h"
#import "BookViewController.h"
#import "RootBookViewController.h"
#import "BookFrontView.h"
#import "RootContainerViewController.h"
#import "Opponent.h"
#import "Bet.h"


@interface MainViewController (PrivateMethods)
//-(void)loadScrollViewWithPage:(int)page;
-(void)scrollViewDidScroll:(UIScrollView *)sender;
-(NSInteger)currentPage;
-(void) easterEgg:(Opponent *)newOpponent;
@end



@implementation MainViewController
@synthesize bookScrollView;
@synthesize books;
@synthesize context;
@synthesize opponents;
@synthesize parent;
@synthesize sliderPageControl;



#pragma mark - View lifecycle

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)cntxt
{    
    self =  [self init];
    if(self)
    {
        self.context = cntxt;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, 320, 460);
    /* Create a scroll view for the books */
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"padded.png"]]];
    [scrollView setPagingEnabled:YES];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setDirectionalLockEnabled:YES];
    [scrollView setDelegate:self];
    [self setBookScrollView:scrollView];
    [self.view addSubview:self.bookScrollView];
    /* Retreive all Opponents to help setup the Controller */
    self.opponents = [Opponent allOponentsSortedBy:@"date"];
    [self resizeScrollView];    // Resize to fit number of Opponents

    
    /* ScrollView Setup */
    // self.bookScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"padded.png"]];
    
    /* view controllers are created lazily
     in the meantime, load the array with placeholders which will be replaced on demand */
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [self.opponents count] + 1; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.books = controllers;
    
    /* Load the first few Book Covers on the ScrollView */
    if ([self.opponents count] == 0)
        [self loadScrollViewWithPage:0 ];
    else 
    {
        for (int i = 0; i <= [self.opponents count] && i < 3; i++) 
        {
            [self loadScrollViewWithPage:i ];
        }
    }
    
    [self setupSlider];
    


}


- (void)viewDidUnload
{
    [self setBookScrollView:nil];
    [self setBooks:nil];
    [self setOpponents:nil];
    [self setSliderPageControl:nil];
    [super viewDidUnload];
}


-(void)setupSlider
{
    self.sliderPageControl = [[SliderPageControl  alloc] initWithFrame:CGRectMake(0,[self.view bounds].size.height-20,[self.view bounds].size.width,20)];
    [self.sliderPageControl addTarget:self action:@selector(onPageChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sliderPageControl setDelegate:self];
    [self.sliderPageControl setShowsHint:YES];
    [self.view addSubview:self.sliderPageControl];
    
    [self.sliderPageControl setNumberOfPages:[self.opponents count] + 1];
    [self.sliderPageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
    [self changeToPage:0 animated:NO];
}



#pragma mark - Scroll View Functions

/*
 This function is a modified function from an Apple example named : ScrollViewWithPaging
 The purpose of this funtion is to supply the Page-enabled ScrollView with new viewcontrollers
 */
- (void)loadScrollViewWithPage:(int)page
{   
    /* if the page being requested is out of bounds, leave the function */
    if (page < 0 || page > [opponents count] )
        return;
    if (page == [books count])
        [books addObject:[NSNull null]];

    
    /* We will take our lazily loaded controllers, test for null and init
     new Book View controllers to supply to the ScrollView */
    BookViewController *controller = [books objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {   
        /* If the requested page is equal to the number of opponents
         the correct page to supply is an add new page. 
         Initing with a nil opponent causes it to be set up as an add new page */
        if (page == [self.opponents count]) 
        {
            controller = [[BookViewController alloc] initWithOpponent:nil];
        }
        else
        {
            controller = [[BookViewController alloc] initWithOpponent:[self.opponents objectAtIndex:page]];
        }
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectBook:)];
        tapGesture.delegate = self;
        for (UIGestureRecognizer *gesture in self.bookScrollView.gestureRecognizers) {
            [tapGesture requireGestureRecognizerToFail:gesture];
        }
        
        
        [controller.frontView addGestureRecognizer:tapGesture];
        controller.delegate = self;
        [books replaceObjectAtIndex:page withObject:controller];
    }
    
    /* Add the controller's view to the scroll view */
    if (controller.view.superview == nil)
    {   
        CGRect frame = bookScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.bookScrollView addSubview:controller.view];
    }
    
}


/*
 This function is a modified function from an Apple example named : ScrollViewWithPaging
 This scrollView delegate function determines which page the the scrollView is on
 and loads the viewcontrollers to the left and right to make the user expierience seamless.
 The example function did not include the section where pages are being nulled out. 
 This was done for memory savings and to allow infinite pages without slow down.
 */
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    NSUInteger page = [self currentPage];
    
    /* load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling) */
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    /* update our sliderControl */
    [sliderPageControl setCurrentPage:page animated:YES];
    
    // Apple : A possible optimization would be to unload the views+controllers which are no longer visible
    /* Me    : We Shall */
    for (NSUInteger i = 0; i < [books count]; i++)
    {
        if( i == page - 1 || i == page || i == page + 1)
        {
            /* ignore the pages currently surrounding the page in view */
        }
        else
        {   
            /* If this Book is not null, then it will become null */
            BookViewController *testBook = [books objectAtIndex:i];
            
            if ((NSNull*)testBook != [NSNull null]) 
            {
                /* if the book is a subview of another view then remove it */
                if (testBook.view.superview != nil ) 
                {
                    [testBook.view removeFromSuperview];
                }
                
                [books replaceObjectAtIndex:i withObject:[NSNull null]];
            }  
        }
    }
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	pageControlUsed = NO;
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	pageControlUsed = NO;
}


#pragma mark - Special BookScrollView Functions

/*
 resizeScrollView - Since the book scroll view uses paging, it must be as wide as all
 of the pages. This function Updates its width with this in mind
 width = pageWidth * (numberOfOpponents + AddNewBook page)
 */
-(void)resizeScrollView
{
    self.bookScrollView.contentSize = CGSizeMake(320 * ([opponents count] + 1), self.bookScrollView.frame.size.height);
    [self.sliderPageControl setNumberOfPages:[self.opponents count] + 1];
}


-(NSInteger)currentPage
{
    CGFloat pageWidth = bookScrollView.frame.size.width;
    int page = floor((bookScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    return page;
}


-(void)reloadBooks
{
    [self loadScrollViewWithPage:[self currentPage]];
}

#pragma mark - BookViewController Delegate Functions

/* 
 This delegate Function occurs when the user has completed
 entering a name on the AddNewBook. It creates a new opponent in 
 Core Data, configures and saves it. 
 */
-(void)nameBookFinishedWithName:(NSString *)oppName by:(BookViewController *)book
{
    
    if(!book.opponent)
    {
        Opponent *newOpponent = [NSEntityDescription insertNewObjectForEntityForName:@"Opponent" inManagedObjectContext:self.context];
        
        newOpponent.name = oppName;
        newOpponent.date = [NSDate date];
        
        /* If for some reason it does not save, show an alert asking the user
         to send an email with details */
        if(![newOpponent save])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Did not save" message:@"There is a problem with coredata plese email RichardBKirk@gmail.com and let him know how this happened" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", "Email", nil];
            [alert show];
        }
        
        self.opponents = [self.opponents arrayByAddingObject:newOpponent];
        book.opponent = newOpponent;
        
        [self easterEgg:newOpponent];
        [book refreshFrontView];
        [self loadScrollViewWithPage:[books indexOfObject:book] + 1];
        [self resizeScrollView];
    }
    else
    {
        [book.opponent setName:oppName];
        if(![book.opponent save])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Did not save" message:@"There is a problem with coredata plese email RichardBKirk@gmail.com and let him know how this happened" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", "Email", nil];
            [alert show];
        }
    }
    
    
}


/*
 Delegate Function called when a user chooses the delete button
 on the flipside of the BookViewController
 */
-(void)deleteThisBook:(BookViewController *)bookToDelete
{
    /* Capture the bookToDeletes' frame for later use */
    CGRect bookToDeleteFrame = bookToDelete.view.frame;
    
    /* if the book is sucessfully Deleted from Core Data
     Remove it from the view, move the next book over and resize the view */
    if([Opponent deleteOpponent:bookToDelete.opponent])
    {
        
        /* Book Deletion animation which causes the book to slide down
         offscreen and slide the next book to the right in its place */
        [UIView animateWithDuration:0.8f 
                              delay:0 
                            options:UIViewAnimationCurveEaseOut 
                         animations:^{ 
                             bookToDelete.view.frame = CGRectMake(bookToDeleteFrame.origin.x, 480, bookToDeleteFrame.size.width, bookToDeleteFrame.size.height);    
                             bookToDelete.view.alpha = 0;
                         }    
                         completion:^(BOOL finished){
                             [bookToDelete.view removeFromSuperview];
                         }];
        self.opponents = [Opponent allOponentsSortedBy:@"date"];
        
        /* Shift the next books' frame left to replace the one deleted */
        NSUInteger indexOfBookOnTheRight = [books indexOfObject:bookToDelete] + 1;
        BookViewController *bookOnTheRight = [books objectAtIndex:indexOfBookOnTheRight];
        
        /* This moves the book to the rights frame to where the deleted book was
         Since we saved the frame before we altered it, we can use it here */
        [UIView animateWithDuration:0.8f 
                              delay:0 
                            options:UIViewAnimationCurveEaseIn 
                         animations:^{ 
                             bookOnTheRight.view.frame = bookToDeleteFrame;                         
                         }    
                         completion:nil];
        
        [books removeObject:bookToDelete];
        [self loadScrollViewWithPage:[books indexOfObject:bookOnTheRight] + 1 ];
    }
    /* Finally, since we have a new amount of books, resize the scroll view */
    
    [self resizeScrollView];
}


/* 
 didSelectBook - Gets called when a user opens a book
 The purpose of this function is to expand the bookcover
 and pass control over to the parent view controller. 
 */
-(void)didSelectBook:(UIGestureRecognizer *)gesture
{
    [self.parent OpenBook:[self.books objectAtIndex:[self currentPage]]];        
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if ([touch.view isKindOfClass:[UIButton class]]) 
    {
        return NO;
    }
    if ([touch.view isKindOfClass:[UIImageView class]])
    {
        return YES;
    }
    else return NO;
}


/* 
 Slider page Control delegate Functions
 These functions are needed by the Slider Page control 
 on the bottom of the page
 */
#pragma mark sliderPageControlDelegate

/* Returns the Title for the OverlayView when Choosing by SlideControl */
- (NSString *)sliderPageController:(id)controller hintTitleForPage:(NSInteger)page
{
    if( page == [self.opponents count] )
        return @"Create New";
    
    Opponent *currentOpponent = [self.opponents objectAtIndex:page];
    return currentOpponent.name;
}


- (void)onPageChanged:(id)sender
{
	pageControlUsed = YES;
	[self slideToCurrentPage:YES];	
}


- (void)slideToCurrentPage:(bool)animated 
{
	int page = sliderPageControl.currentPage;
	
    CGRect frame = bookScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.bookScrollView scrollRectToVisible:frame animated:animated]; 
}


- (void)changeToPage:(int)page animated:(BOOL)animated
{
	[sliderPageControl setCurrentPage:page animated:YES];
	[self slideToCurrentPage:animated];
}


#pragma mark - UIAlertViewDelegate functions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2)
    {
        NSString *url = [NSString stringWithString: @"mailto:RichardBKirk@gmail.com?cc=&subject=Dollar%20bets%20bug&body=Core%20Data%20is%20Broken%20"];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }
}

/* 
 The easteregg function
 If someone that I know downloads the app and puts their own name 
 as a new opponent, on the book, then it will load that book with all 
 of the bets they have had with me and the name will change to my name
 */
-(void)easterEgg:(Opponent *)newOpponent
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM / dd / yyyy"];
    
    NSString *name = [newOpponent.name lowercaseString];
    
    if ([name isEqualToString:@"johnny curry"])
    {
        Bet *newBet1 = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet1.date = [dateFormatter dateFromString:@"05 / 12 / 2010"];
        newBet1.amount = [NSNumber numberWithInt:5];
        newBet1.report = @"Will at least 3 people at this party know about the North Korea Missle incident";
        newBet1.didWin = [NSNumber numberWithInt:0];
        newBet1.opponent = newOpponent;
        
        Bet *newBet2 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet2.date = [dateFormatter dateFromString:@"05 / 11 / 2010"];
        newBet2.amount = [NSNumber numberWithInt:1];
        newBet2.report = @"Will Hannah walk out of the Complex in the next 20 min";
        newBet2.didWin = [NSNumber numberWithInt:0];
        newBet2.opponent = newOpponent;
        
        
        Bet *newBet3 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet3.date = [dateFormatter dateFromString:@"04 / 21 / 2010"];
        newBet3.amount = [NSNumber numberWithInt:1];
        newBet3.report = @"Were Helicopters around in ww2";
        newBet3.didWin = [NSNumber numberWithInt:1];
        newBet3.opponent = newOpponent;
        
        
        Bet *newBet4 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet4.date = [dateFormatter dateFromString:@"03 / 11 / 2010"];
        newBet4.amount = [NSNumber numberWithInt:1];
        newBet4.report = @"They said Chewie in that movie, not Chewit";
        newBet4.didWin = [NSNumber numberWithInt:0];
        newBet4.opponent = newOpponent;
        
        Bet *newBet5 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet5.date = [dateFormatter dateFromString:@"03 / 10 / 2010"];
        newBet5.amount = [NSNumber numberWithInt:1];
        newBet5.report = @"Something about Banjo Kazooie";
        newBet5.didWin = [NSNumber numberWithInt:0];
        newBet5.opponent = newOpponent;
        
        Bet *newBet6 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet6.date = [dateFormatter dateFromString:@"02 / 23 / 2010"];
        newBet6.amount = [NSNumber numberWithInt:1];
        newBet6.report = @"Captain would beat Chuckie in beerpong";
        newBet6.didWin = [NSNumber numberWithInt:0];
        newBet6.opponent = newOpponent;
        
        Bet *newBet7 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet7.date = [dateFormatter dateFromString:@"02 / 21 / 2010"];
        newBet7.amount = [NSNumber numberWithInt:1];
        newBet7.report = @"Something having to do with Tania Raymond";
        newBet7.didWin = [NSNumber numberWithInt:0];
        newBet7.opponent = newOpponent;
        
        newOpponent.name = @"Captain";
        [newOpponent save];
    }
    else if ([name isEqualToString:@"matt carmichael"])
    {
        Bet *newBet1 = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet1.date = [dateFormatter dateFromString:@"10 / 12 / 2010"];
        newBet1.amount = [NSNumber numberWithInt:2];
        newBet1.report = @"Coins are Magnetic";
        newBet1.didWin = [NSNumber numberWithInt:0];
        newBet1.opponent = newOpponent;
        
        Bet *newBet2 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet2.date = [dateFormatter dateFromString:@"11 / 22 / 2010"];
        newBet2.amount = [NSNumber numberWithInt:1];
        newBet2.report = @"Beer Pong Shot";
        newBet2.didWin = [NSNumber numberWithInt:0];
        newBet2.opponent = newOpponent;
        
        
        Bet *newBet3 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet3.date = [dateFormatter dateFromString:@"11 / 21 / 2010"];
        newBet3.amount = [NSNumber numberWithInt:1];
        newBet3.report = @"Beer Pong Shot";
        newBet3.didWin = [NSNumber numberWithInt:1];
        newBet3.opponent = newOpponent;
        
        
        Bet *newBet4 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet4.date = [dateFormatter dateFromString:@"01 / 14 / 2011"];
        newBet4.amount = [NSNumber numberWithInt:1];
        newBet4.report = @"Beer Pong Behind the Back shot";
        newBet4.didWin = [NSNumber numberWithInt:0];
        newBet4.opponent = newOpponent;
        
        Bet *newBet5 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet5.date = [dateFormatter dateFromString:@"04 / 08 / 2011"];
        newBet5.amount = [NSNumber numberWithInt:1];
        newBet5.report = @"Can Captain catch a frog?";
        newBet5.didWin = [NSNumber numberWithInt:0];
        newBet5.opponent = newOpponent;
        
        Bet *newBet6 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet6.date = [dateFormatter dateFromString:@"04 / 09 / 2011"];
        newBet6.amount = [NSNumber numberWithInt:1];
        newBet6.report = @"Can Carmichael catch a frog";
        newBet6.didWin = [NSNumber numberWithInt:0];
        newBet6.opponent = newOpponent;
        
        newOpponent.name = @"Captain";
        [newOpponent save];
        
    }
    else if ([name isEqualToString:@"konrad gungor"])
    {
        Bet *newBet1 = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet1.date = [dateFormatter dateFromString:@"05 / 12 / 2010"];
        newBet1.amount = [NSNumber numberWithInt:1];
        newBet1.report = @"Martone can fit through those bars";
        newBet1.didWin = [NSNumber numberWithInt:0];
        newBet1.opponent = newOpponent;
        
        Bet *newBet2 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet2.date = [dateFormatter dateFromString:@"11 / 12 / 2010"];
        newBet2.amount = [NSNumber numberWithInt:1];
        newBet2.report = @"Will the night nole drop us off at the strip";
        newBet2.didWin = [NSNumber numberWithInt:0];
        newBet2.opponent = newOpponent;
        
        
        Bet *newBet3 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet3.date = [dateFormatter dateFromString:@"11 / 11 / 2010"];
        newBet3.amount = [NSNumber numberWithInt:1];
        newBet3.report = @"Beer pong shot";
        newBet3.didWin = [NSNumber numberWithInt:0];
        newBet3.opponent = newOpponent;
        
        
        
        newOpponent.name = @"Captain";
        [newOpponent save];
        
    }  
    else if ([name isEqualToString:@"mary thomas"])
    {
        Bet *newBet1 = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet1.date = [dateFormatter dateFromString:@"05 / 12 / 2010"];
        newBet1.amount = [NSNumber numberWithInt:1];
        newBet1.report = @"Richard will die at least 15 in this game";
        newBet1.didWin = [NSNumber numberWithInt:0];
        newBet1.opponent = newOpponent;
        
        Bet *newBet2 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet2.date = [dateFormatter dateFromString:@"01 / 12 / 2011"];
        newBet2.amount = [NSNumber numberWithInt:1];
        newBet2.report = @"Unkown reason!!";
        newBet2.didWin = [NSNumber numberWithInt:1];
        newBet2.opponent = newOpponent;
        
        
        Bet *newBet3 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet3.date = [dateFormatter dateFromString:@"01 / 21 / 2011"];
        newBet3.amount = [NSNumber numberWithInt:1];
        newBet3.report = @"Richard will mess up a check";
        newBet3.didWin = [NSNumber numberWithInt:0];
        newBet3.opponent = newOpponent;
        
        
        Bet *newBet4 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet4.date = [dateFormatter dateFromString:@"03 / 11 / 2011"];
        newBet4.amount = [NSNumber numberWithInt:1];
        newBet4.report = @"Cat Cora will win in this iron chef";
        newBet4.didWin = [NSNumber numberWithInt:1];
        newBet4.opponent = newOpponent;
        
        Bet *newBet5 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet5.date = [dateFormatter dateFromString:@"04 / 10 / 2011"];
        newBet5.amount = [NSNumber numberWithInt:1];
        newBet5.report = @"Game of BattleShip";
        newBet5.didWin = [NSNumber numberWithInt:1];
        newBet5.opponent = newOpponent;
        
        newOpponent.name = @"Richard Kirk";
        [newOpponent save];        
    }
    else if ([name isEqualToString:@"carlos gardinali"])
    {
        Bet *newBet1 = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet1.date = [dateFormatter dateFromString:@"10 / 10 / 2010"];
        newBet1.amount = [NSNumber numberWithInt:1];
        newBet1.report = @"Jersey Shore will change their cast up";
        newBet1.didWin = [NSNumber numberWithInt:1];
        newBet1.opponent = newOpponent;
        
        Bet *newBet2 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet2.date = [dateFormatter dateFromString:@"01 / 12 / 2011"];
        newBet2.amount = [NSNumber numberWithInt:1];
        newBet2.report = @"There's gunna be a nutshot in this montage";
        newBet2.didWin = [NSNumber numberWithInt:0];
        newBet2.opponent = newOpponent;
        
        newOpponent.name = @"Captain";
        [newOpponent save];
    }
    
}




@end
