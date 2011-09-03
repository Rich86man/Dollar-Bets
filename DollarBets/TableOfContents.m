//
//  TableOfContents.m
//  DollarBets
//
//  Created by Richard Kirk on 9/1/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "TableOfContents.h"
#import "Bet.h"
#import "Opponent.h"
#import "QuickAddViewController.h"
#import <QuartzCore/QuartzCore.h>

#define REFRESH_HEADER_HEIGHT 100.0f

@interface TableOfContents (PrivateMethods)
//-(UIView *)createHeader;


@end

@implementation TableOfContents
@synthesize tableView;
@synthesize opponent;
@synthesize bets;
@synthesize tableOfContentsHeader = _tableOfContentsHeader;
@synthesize graphsHeader = _graphsHeader;
@synthesize quickAddView = _quickAddView;
@synthesize refreshArrow;
@synthesize bet;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"handmadepaper.png"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
    
    self.bets = [self.opponent.bets sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    [self.tableView addSubview:self.quickAddView.view];
    isQuickAdding = NO;
    isDragging = NO;
    
    
    
}



#pragma mark - Custom setters
-(UIView *)tableOfContentsHeader
{
    if (!_tableOfContentsHeader) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 100)];
        view.backgroundColor = [UIColor clearColor];
        
        UILabel *tl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 280, 46)];    
        tl.backgroundColor = [UIColor clearColor];
        tl.font = [UIFont fontWithName:@"STHeitiJ-Light" size:40.0f];
        tl.text = @"Table of";
        tl.textColor = [UIColor lightGrayColor];
        tl.textAlignment = UITextAlignmentCenter;
        
        UILabel *tl1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 49, 280, 51)];    
        tl1.backgroundColor = [UIColor clearColor];
        tl1.font = [UIFont fontWithName:@"STHeitiJ-Light" size:40.0f];
        tl1.text = @"Contents";
        tl1.textColor = [UIColor lightGrayColor];
        tl1.textAlignment = UITextAlignmentCenter;
        
        
        
        [view addSubview:tl];
        [view addSubview:tl1];
        
        _tableOfContentsHeader = view;
        
    }
    
    
    return _tableOfContentsHeader;
    
    
}

-(UIView *)graphsHeader
{
    
    if (!_graphsHeader){
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 60)];
        view.backgroundColor = [UIColor clearColor];
        
        
        UILabel *tl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 280, 46)];    
        tl.backgroundColor = [UIColor clearColor];
        tl.font = [UIFont fontWithName:@"STHeitiJ-Light" size:30.0f];
        tl.text = @"Graphs";
        tl.textColor = [UIColor lightGrayColor];
        tl.textAlignment = UITextAlignmentCenter;
        
        
        
        
        
        [view addSubview:tl];
        
        
        
        _graphsHeader =  view;
        
        
        
    }
    
    
    return _graphsHeader;
}


-(QuickAddViewController *)quickAddView
{
    if(!_quickAddView)
    {
        QuickAddViewController *qav = [[QuickAddViewController alloc] initWithOpponent:self.opponent];
        qav.view.frame = CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT);
  
        _quickAddView = qav;
    }
    return _quickAddView;
}

- (void)viewDidUnload
{
    tableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - TableView Functions 


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [self.bets count];
            break;
        case 1:
            return 6;
            break;
        default:
            return 0;
            break;
    }
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"testingCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.textLabel.font = [UIFont fontWithName:@"STHeitiJ-Light" size:16.0f];
    if(indexPath.section == 0){
        UILabel *report = [[UILabel alloc] initWithFrame:CGRectMake(70 ,12,250, 24)];
        report.backgroundColor = [UIColor clearColor];
        report.font = [UIFont fontWithName:@"STHeitiJ-Light" size:16.0f];
        report.text = [[bets objectAtIndex:indexPath.row] report];
        [cell addSubview:report];
        
        UILabel *amount = [[UILabel alloc] initWithFrame:CGRectMake(20 ,12,71, 24)];
        amount.font = [UIFont fontWithName:@"STHeitiJ-Light" size:24.0f];
        amount.text = [NSString stringWithFormat:@"$%@",[[[bets objectAtIndex:indexPath.row] amount] stringValue]]; 
        amount.backgroundColor = [UIColor clearColor];
        //cell.textLabel.text = [[bets objectAtIndex:indexPath.row] report];
        //cell.textLabel.frame = CGRectMake(158,12,227,68);
        [cell addSubview:amount];
        
        
    }    
    else if(indexPath.section == 1)
        cell.textLabel.text = @"Testing";
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat{
    NSLog(@"didselect row");
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0)
    { 
        return self.tableOfContentsHeader;
    }
    else if (section == 1)    { 
        return self.graphsHeader;        
        
    }
    return nil;   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return self.tableOfContentsHeader.frame.size.height + 10;
            break;
        case 1:
            return self.graphsHeader.frame.size.height + 10;
            break;
        default:
            return 40.0f;
            break;
    }
    
}


#pragma mark - ScrollViewDelegate Functions
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isQuickAdding) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isQuickAdding) 
    {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
        {
            self.tableView.contentInset = UIEdgeInsetsZero;
        }
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
        {
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
    
    } 
    else if (isDragging && scrollView.contentOffset.y < 0) 
    {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) 
        {
            // User is scrolling above the header
            
            //NSLog(@"1");
            
            
        } else { // User is scrolling somewhere within the header
            
            //NSLog(@"2");
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isQuickAdding) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isQuickAdding = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    
    refreshArrow.hidden = YES;
    
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isQuickAdding = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsZero;
    
    
    //CATransform3DMakeRotation(MY_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    
    refreshArrow.hidden = NO;
    
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
   // [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
    
    NSLog(@"Refresh");
}

#pragma mark - QuickAdd functions







@end
