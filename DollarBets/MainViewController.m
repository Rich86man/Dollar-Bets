//
//  MainViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 8/21/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "MainViewController.h"
#import "BookViewController.h"
#import "RootViewController.h"
#import "BookFrontView.h"
#import "RootContainerViewController.h"
#import "Opponent.h"
#import "Bet.h"
#import <CoreGraphics/CoreGraphics.h>

static NSUInteger kNumberOfPages = 10;


@interface MainViewController (PrivateMethods)
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
@end



@implementation MainViewController
@synthesize mainScrollView, books;
@synthesize context;
@synthesize opponents;
@synthesize parent;




-(id)initWithManagedObjectContext:(NSManagedObjectContext *)cntxt
{
    self =  [self initWithNibName:nil bundle:nil];
    if(self)
    {
        self.context = cntxt;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set up the backround 
    UIImage *pattern = [UIImage imageNamed:@"padded.png"];
    
    self.mainScrollView.backgroundColor = [UIColor colorWithPatternImage:pattern];
    self.mainScrollView.pagingEnabled = YES;
    [self.mainScrollView setUserInteractionEnabled:YES];
    [self.view setUserInteractionEnabled:YES];
    
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.books = controllers;
    
    self.opponents = [[NSMutableArray alloc] init];
    
    [self retrieveOpponents];
    
    [self resizeScrollView];
    
    
    
    for (int i = 0; i < [self.opponents count] && i < 2; i++) {
        [self loadScrollViewWithPage:i ];
    }
    
    
    
    NSLog(@"%i",[self.opponents count]);
    //[self loadScrollViewWithPage:[self.opponents count] ];
    
    
    
    
    
}

- (void)viewDidUnload
{
    [self setMainScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}





#pragma mark - Scroll View Functions

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page > [opponents count] )
        return;
    
    if (page == [books count] - 2) 
        [books addObject:[NSNull null]];
    
    
    BookViewController *controller = [books objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {   
        if (page == [self.opponents count]) 
        {
            controller = [[BookViewController alloc] initWithOpponent:nil];
        }
        else
        {
            controller = [[BookViewController alloc] initWithOpponent:[self.opponents objectAtIndex:page]];
        }
        
        controller.delegate = self;
        [controller.view setUserInteractionEnabled:YES];
        [books replaceObjectAtIndex:page withObject:controller];
        controller.debugLabel.text =  [NSString stringWithFormat:@"page : %i\tbooks index : %i",page, [self.books indexOfObject:controller]];        
       // controller.debugLabel.text =  [NSString stringWithFormat:@"%d = 4 - 5     %d = 5 - 4", (4 - 5 ), ( 5 - 4)];
        
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {   
        CGRect frame = mainScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        //[self addChildViewController:controller];
        
        
        
        [self.mainScrollView addSubview:controller.view];
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = mainScrollView.frame.size.width;
    int page = floor((mainScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1 ];
    [self loadScrollViewWithPage:page ];
    [self loadScrollViewWithPage:page + 1 ];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
    
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
    
    
}


#pragma mark - Special BookScrollView Functions

-(void)resizeScrollView
{
    self.mainScrollView.contentSize = CGSizeMake(320 * ([opponents count] + 1), self.mainScrollView.frame.size.height);
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
    
    if ([newOpponent.name isEqualToString:@"test"]) {
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM / DD / YYYY"];
        

        
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
        
        
        [context save:&error];
        
        if(error)
        {
            NSLog(@"%@\n", [error  description]);
        }

        
    }
    
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
                CGRect frame = mainScrollView.frame;
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
                            sender.frontView.bookImgView.frame = [[UIScreen mainScreen] bounds];
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
 
 -(void)retrieveOpponents
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
     
     opponents = [array mutableCopy];
     
     //-------Delete all --------
     /*
      for (NSManagedObject *opp in opponents) {
      [self.context deleteObject:opp ];
      }
      
      [self.context save:nil];
      */
     //  NSLog(@"%@",[opponents description]);
     
 }
 
 
 
 
 
 
 
 @end
