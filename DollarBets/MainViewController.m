//
//  MainViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 8/21/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "MainViewController.h"
#import "BookViewController.h"
#import "Opponent.h"
#import <CoreGraphics/CoreGraphics.h>

static NSUInteger kNumberOfPages = 10;


@interface MainViewController (PrivateMethods)
- (void)loadScrollViewWithPage:(int)page isAddBook:(bool)newBook;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
@end



@implementation MainViewController
@synthesize mainScrollView,pageControl, books;
@synthesize context;
@synthesize opponents;



-(id)initWithManagedObjectContext:(NSManagedObjectContext *)cntxt
{
    
    self =  [self initWithNibName:nil bundle:nil];
    
    self.context = cntxt;
    
    
    
    return self;
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set up the backround 
    UIImage *pattern = [UIImage imageNamed:@"pattern8.png"];
    self.mainScrollView.backgroundColor = [UIColor colorWithPatternImage:pattern];
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.books = controllers;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width * 3, self.mainScrollView.frame.size.height);
    
    
    [self retrieveOpponents];
    
    for (int i=0; i < [opponents count]; i++) {
        [self loadScrollViewWithPage:i isAddBook:NO];
    }

    [self loadScrollViewWithPage:[opponents count] isAddBook:YES];
    
    
    
    
    
}

- (void)viewDidUnload
{
    [self setMainScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - Scroll View Functions

- (void)loadScrollViewWithPage:(int)page isAddBook:(bool)newBook
{
    if (page < 0)
        return;
    if (page >= [books count])
        return;
    
    
    if (newBook)
    {
        BookViewController *controller = [books objectAtIndex:page];
        if ((NSNull *)controller == [NSNull null])
        {
            controller = [[BookViewController alloc] initAsAddBook];
            controller.delegate = self;
            [books replaceObjectAtIndex:page withObject:controller];
            
        }
        
        if (controller.view.superview == nil)
        {
            CGRect frame = mainScrollView.frame;
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0;
            controller.view.frame = frame;
            [mainScrollView addSubview:controller.view];
            
        }

        
        
    } 
    else 
    {
        // replace the placeholder if necessary
        BookViewController *controller = [books objectAtIndex:page];
        if ((NSNull *)controller == [NSNull null])
        {
            controller = [[BookViewController alloc] initWithNibName:@"BookViewController" bundle:nil];
            controller.opponentTextField.text = @"Johnny Curry";
            controller.dateLabel.text = @"01/20/2011";
            controller.debugPageNumber.text = [[NSNumber numberWithInt:page] description];
            [books replaceObjectAtIndex:page withObject:controller];
            
            
        }
        
        if (controller.view.superview == nil)
        {
            CGRect frame = mainScrollView.frame;
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0;
            controller.view.frame = frame;
            [mainScrollView addSubview:controller.view];
            
        }

    }
    
    // add the controller's view to the scroll view
   }

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = mainScrollView.frame.size.width;
    int page = floor((mainScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1 isAddBook:NO];
    [self loadScrollViewWithPage:page isAddBook:NO];
    if (page + 1 < [books count])
    {
    [self loadScrollViewWithPage:page + 1 isAddBook:NO];
    }
    
    
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1 isAddBook:NO];
    [self loadScrollViewWithPage:page isAddBook:NO];
    [self loadScrollViewWithPage:page + 1 isAddBook:NO];
    
	// update the scroll view to the appropriate page
    CGRect frame = mainScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [mainScrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}


-(void)addNewBook
{
    
    NSLog(@"The delegate worked!!");
    
    [self loadScrollViewWithPage:[books count] isAddBook:YES];

}

-(void)opponentCreatedWithName:(NSString *)oppName
{
    //NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"MM/DD/YYYY"];

    Opponent *newOpponent = [NSEntityDescription insertNewObjectForEntityForName:@"Opponent" inManagedObjectContext:self.context];
    
    newOpponent.name = oppName;
    //newOpponent.date = [dateFormatter stringFromDate:[NSDate date]];
    
    NSError *error = [[NSError alloc] init ];
    
    [context save:&error];
    
    
    if(error)
    {
         NSLog(@"%@\n", [error  description]);
    }
    
    
    [self retrieveOpponents];
    
    
}


-(void)retrieveOpponents
{
    
    
    //[self.context ]
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Opponent" inManagedObjectContext:self.context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Opponent"];
    
    //[request setEntity:entityDescription];
    
    
    
    // Set example predicate and sort orderings...
/*
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
  */  
    
    
    
    NSError *error = nil;
    
    NSArray *array = [self.context executeFetchRequest:request error:&error];
    
    if(error)
    {
          NSLog(@"%@\n", [error  description]);
    }
    
    
    
    if (array == nil)
    {
        opponents = [NSArray arrayWithObject:@"empty"];
    }
    
    opponents = array;
    
    
    
}







@end
