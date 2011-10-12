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
#import "RootViewController.h"
#import "BookFrontView.h"
#import "RootContainerViewController.h"
#import "Opponent.h"
#import "Bet.h"




@interface MainViewController (PrivateMethods)
-(void)loadScrollViewWithPage:(int)page;
-(void)scrollViewDidScroll:(UIScrollView *)sender;
-(NSInteger)currentPage;
-(void) easterEgg:(Opponent *)newOpponent;
@end



@implementation MainViewController
@synthesize scrollView;
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
    /* Retreive all Opponents to help setup the Controller */
    self.opponents = [self retrieveOpponents];  
    [self resizeScrollView];    // Resize to fit number of Opponents
                                // + 1 for the add page 
    
    /* ScrollView Setup */
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"padded.png"]];

    /* view controllers are created lazily
       in the meantime, load the array with placeholders which will be replaced on demand */
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [self.opponents count] + 1; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.books = controllers;
    
    /* Load the first few Book Covers on the ScrollView */
    for (int i = 0; i < [self.opponents count] && i < 3; i++) {
        [self loadScrollViewWithPage:i ];
    }
    
    
    [self setupSlider];
}


- (void)viewDidUnload
{
    [self setScrollView:nil];
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
    
    [self changeToPage:1 animated:NO];
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
    /*************************************************************************************************
    if (page == [books count] - 2) 
        [books addObject:[NSNull null]];
    **************************************************************************************************/
    
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
        
        controller.delegate = self;
        [books replaceObjectAtIndex:page withObject:controller];
        controller.debugLabel.text =  [NSString stringWithFormat:@"page : %i\tbooks index : %i",page, [self.books indexOfObject:controller]];        
    }
    
    /* Add the controller's view to the scroll view */
    if (controller.view.superview == nil)
    {   
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.scrollView addSubview:controller.view];
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
            if ((NSNull*)[books objectAtIndex:i] != [NSNull null]) 
            {
                BookViewController *testBook = [books objectAtIndex:i];
              
                if (testBook.view.superview != nil ) 
                {
                    [testBook.view removeFromSuperview];
                }
                [books replaceObjectAtIndex:i withObject:[NSNull null]];
                
            }  
            
            
            
        }
            
    }
    

/*
    if (page > 1 && (NSNull *)[books objectAtIndex:page -2 ] != [NSNull null])
    {
        BookViewController *tempBook = [books objectAtIndex:page -2];
        if (tempBook.view.superview != nil)
        {
            [tempBook.view removeFromSuperview];
            //[tempBook removeFromParentViewController];
        }
        [books replaceObjectAtIndex:page -2 withObject:[NSNull null]];
        
    }
    if (page < [self.opponents count] -1 && (NSNull *)[books objectAtIndex:page +2] !=[NSNull null] )
    {
        BookViewController *tempBook = [books objectAtIndex:page +2];
        if (tempBook.view.superview != nil)
        {
            [tempBook.view removeFromSuperview];
            //[tempBook removeFromParentViewController];
        }
        [books replaceObjectAtIndex:page + 2 withObject:[NSNull null]];
    }
    
  */  
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_
{
	pageControlUsed = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView_
{
	pageControlUsed = NO;
}


#pragma mark - Special BookScrollView Functions

-(void)resizeScrollView
{
    self.scrollView.contentSize = CGSizeMake(320 * ([opponents count] + 1), self.scrollView.frame.size.height);
}

-(NSInteger)currentPage
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    return page;
}


#pragma mark - BookViewController Delegate Functions

-(void)opponentCreatedWithName:(NSString *)oppName by:(BookViewController *)cont
{
    
    Opponent *newOpponent = [NSEntityDescription insertNewObjectForEntityForName:@"Opponent" inManagedObjectContext:self.context];
    
    newOpponent.name = oppName;
    newOpponent.date = [NSDate date];
    
    
    NSError *error =  nil;
    [context save:&error];
    
    if(error)
    {
        NSLog(@"%@\n", [error  description]);
    }
    [self.opponents addObject:newOpponent];
    cont.opponent = newOpponent;
    // [cont setDateLabel:newOpponent.date];
    ///[cont showConfigAndDate];
    [cont refreshFrontView];
    
    // [self retrieveOpponents];
    
    [self resizeScrollView];
    
    [self easterEgg:newOpponent];
    
}


-(void)deleteThisBook:(BookViewController *)sender
{
    CGRect bookFrame = sender.view.frame;
    
    
    
    
    [UIView animateWithDuration:0.8f 
                          delay:0 
                        options:UIViewAnimationCurveEaseOut 
                     animations:^{ 
                         sender.view.frame = CGRectMake(bookFrame.origin.x, 480, bookFrame.size.width, bookFrame.size.height);    
                         sender.view.alpha = 0;
                     }    
                     completion:^(BOOL finished){
                         
                         [sender.view removeFromSuperview];
                         sender.view.frame = CGRectMake(bookFrame.origin.x   , 480, bookFrame.size.width, bookFrame.size.height);    
                     }];
    
    
    
    if([self deleteOpponent:sender.opponent])
    {
        NSUInteger index = [books indexOfObject:sender];
        [self loadScrollViewWithPage:index + 1 ];
        
        for (BookViewController *book in books) {
            NSUInteger bookIndex = [books indexOfObject:book];
            
            if ( bookIndex > index && (NSNull *)book != [NSNull null] )
            {
                CGRect frame = scrollView.frame;
                frame.origin.x = 320 * (bookIndex - 1);
                frame.origin.y = 0;
                
                [UIView animateWithDuration:0.8f 
                                      delay:0 
                                    options:UIViewAnimationCurveEaseIn 
                                 animations:^{ 
                                     book.view.frame = frame;                         
                                 }    
                                 completion:nil];
                
            }
        }
        
        
        [books removeObject:sender];
        
        
        
        
    }
    
    [self resizeScrollView];
    
}

-(void)didSelectBook:(BookViewController *)sender
{
    /*
     RootViewController *root = [[RootViewController alloc]init];
     
     [self presentViewController:root animated:NO completion:nil];
     
     [UIView transitionWithView:root.view 
     duration:0.8f 
     options:UIViewAnimationCurveEaseInOut 
     animations:^{
     sender.frontView.bookImgView.frame = [[UIScreen mainScreen] bounds];
     } completion:nil];
     
     
     
     [self transitionFromViewController:self 
     toViewController:root 
     duration:1.0f 
     options:UIViewAnimationCurveEaseInOut 
     animations:^{
     sender.frontView.bookImgView.frame = [[UIScreen mainScreen] bounds];}
     completion:nil ];
     
     */
    NSLog(@"MainViewController : didSelectBook:");
    
    
    [UIView animateWithDuration:1.0f 
                          delay:0.0f 
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            sender.view.frame = [[UIScreen mainScreen] bounds];
                        } completion:^(BOOL finished){  
                            [self.parent OpenBookWithOpponent:[sender opponent]];
                        } ];
    
    
    
}




#pragma mark - Manged Object Functions

-(bool)deleteOpponent:(Opponent *)opp
{
    
    [self.context deleteObject:opp];
    NSError *error = nil;
    [self.context save:&error];
    if(error)
    {  
        NSLog(@"%@\n", [error  description]);
        return NO;
    }
    else
    {
        [self.opponents removeObject:opp];        
        return YES;
    }
    
}

-(NSMutableArray *)retrieveOpponents
{

    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Opponent"];
    
    
    // Set example predicate and sort orderings...
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error = nil;
    NSArray *array = [self.context executeFetchRequest:request error:&error];
    
    if(error)
    {   NSLog(@"%@\n", [error  description]);   }
    
    if (array == nil)
    {   array = [NSArray arrayWithObject:@"empty"]; }
    

    
    
    
    //-------Delete all --------
    /*
    for (NSManagedObject *opp in opponents) {
        [self.context deleteObject:opp ];
    }
    
    [self.context save:nil];
    */
    //  NSLog(@"%@",[opponents description]);
    
    return [array mutableCopy];
}

#pragma mark sliderPageControlDelegate

- (NSString *)sliderPageController:(id)controller hintTitleForPage:(NSInteger)page
{
    if(page == [self.opponents count])
    {
        return @"Create New";
    }
    
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
	
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:animated]; 
}

- (void)changeToPage:(int)page animated:(BOOL)animated
{
	[sliderPageControl setCurrentPage:page animated:YES];
	[self slideToCurrentPage:animated];
}




-(void)easterEgg:(Opponent *)newOpponent
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM / DD / YYYY"];
    
    
    
    if ([newOpponent.name isEqualToString:@"test"]) {
        
        
        
        
        Bet *newBet1 = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet1.date = [NSDate date];
        newBet1.amount = [NSNumber numberWithInt:5];
        newBet1.report = @"A couple of hotdogs";
        newBet1.opponent = newOpponent;
        
        Bet *newBet2 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet2.date = [dateFormatter dateFromString:@"05 / 12 / 2011"];
        newBet2.amount = [NSNumber numberWithInt:12];
        newBet2.report = @"Tijuana Flatts";
        newBet2.opponent = newOpponent;
        
        
        Bet *newBet3 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet3.date = [dateFormatter dateFromString:@"01 / 21 / 2010"];
        newBet3.amount = [NSNumber numberWithInt:3];
        newBet3.report = @"lunch money";
        newBet3.opponent = newOpponent;
        
        NSError *error =  nil;
        
        [context save:&error];
        
        if(error)
        {
            NSLog(@"%@\n", [error  description]);
        }
        
        
    }
    else if ([newOpponent.name isEqualToString:@"Johnny Curry"])
    {
        Bet *newBet1 = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet1.date = [dateFormatter dateFromString:@"05 / 12 / 2010"];
        newBet1.amount = [NSNumber numberWithInt:5];
        newBet1.report = @"Will at least 3 people at this party know about the North Korea Missle incident";
        newBet1.didWin = [NSNumber numberWithInt:0];
        newBet1.opponent = newOpponent;
        
        Bet *newBet2 =[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.context];
        newBet2.date = [dateFormatter dateFromString:@"05 / 12 / 2010"];
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
        
        NSError *error =  nil;
        
        [context save:&error];
        
        if(error)
        {
            NSLog(@"%@\n", [error  description]);
        }
        
        
    }
    else if ([newOpponent.name isEqualToString:@"Matt Carmichael"])
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
        newBet3.date = [dateFormatter dateFromString:@"11 / 22 / 2010"];
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
        newBet5.date = [dateFormatter dateFromString:@"04 / 09 / 2011"];
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
        
        NSError *error =  nil;
        
        [context save:&error];
        
        if(error)
        {
            NSLog(@"%@\n", [error  description]);
        }
        
        
    }
    else if ([newOpponent.name isEqualToString:@"Konrad Gungor"])
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
        newBet3.date = [dateFormatter dateFromString:@"11 / 12 / 2010"];
        newBet3.amount = [NSNumber numberWithInt:1];
        newBet3.report = @"Beer pong shot";
        newBet3.didWin = [NSNumber numberWithInt:0];
        newBet3.opponent = newOpponent;
        
        
        
        newOpponent.name = @"Captain";
        
        NSError *error =  nil;
        
        [context save:&error];
        
        if(error)
        {
            NSLog(@"%@\n", [error  description]);
        }
        
        
    }  else if ([newOpponent.name isEqualToString:@"Mary Thomas"])
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
              
        newOpponent.name = @"Richard";
        
        NSError *error =  nil;
        
        [context save:&error];
        
        if(error)
        {
            NSLog(@"%@\n", [error  description]);
        }
        
        
    }
    else if ([newOpponent.name isEqualToString:@"Carlos Gardinali"])
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
        
        NSError *error =  nil;
        
        [context save:&error];
        
        if(error)
        {
            NSLog(@"%@\n", [error  description]);
        }
        
        
    }




    
    
}




@end
