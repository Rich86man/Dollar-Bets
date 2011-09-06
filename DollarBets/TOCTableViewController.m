//
//  TOCTableViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 9/4/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "TOCTableViewController.h"

#define QUICKADD_HEIGHT 100.0f

@implementation TOCTableViewController

@synthesize tableOfContentsHeader = _tableOfContentsHeader, graphsHeader = _graphsHeader;
@synthesize quickAddView, amountTextField, descriptionTextView, refreshArrow, quickBet;
@synthesize opponent, bets;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"handmadepaper.png"]];
    
    NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
    
    self.bets = [self.opponent.bets sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    self.quickAddView.frame = CGRectMake(0, 0 - QUICKADD_HEIGHT, 320, QUICKADD_HEIGHT);
    self.quickAddView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_denim.png"]];
    [self.tableView addSubview:self.quickAddView];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardDidShowNotification 
                                               object:nil];     
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardDidShow:) 
                                                 name:UIKeyboardDidShowNotification 
                                               object:nil];     
    
    self.tableView.contentOffset = CGPointMake(<#CGFloat x#>, <#CGFloat y#>)
    
    isQuickAdding = NO;
    isDragging = NO;
}

- (void)viewDidUnload
{
    [self setQuickAddView:nil];
    [self setAmountTextField:nil];
    [self setTableOfContentsHeader:nil];
    [self setGraphsHeader:nil];
    [self setDescriptionTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{   
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didselect IndexPath: %@", [indexPath description]);
}


#pragma mark - ScrollViewDelegate Functions
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isQuickAdding) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
   // if (self.tableView.contentOffset.y < -130.0f)
     //   self.tableView.contentOffset = CGPointMake(-100.0f, 0);
    
    if (isQuickAdding) 
    {
        // Update the content inset, good for section headers
       
        NSLog(@"is QA : %@ scrollview.contentoffset.y : %f", isQuickAdding ? @"yes" : @"no",  scrollView.contentOffset.y );
        if (scrollView.contentOffset.y > 0)
        {

            self.tableView.contentInset = UIEdgeInsetsZero;
        }
        else if (scrollView.contentOffset.y >= -QUICKADD_HEIGHT)
        {
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        NSLog(@"scrollviewContentInsets.top : %f .bottom : %f", scrollView.contentInset.top, scrollView.contentInset.bottom);
    } 
    else if (isDragging && scrollView.contentOffset.y < 0) 
    {
    
    }
    else 
    {
            NSLog(@"is QA : %@ scrollview.contentoffset.y : %f", isQuickAdding ? @"yes" : @"no",  scrollView.contentOffset.y );    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isQuickAdding) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -QUICKADD_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

#pragma mark - QuickAdd Functions
- (void)startLoading {
    
    if(!isQuickAdding){
    isQuickAdding = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentInset = UIEdgeInsetsMake(QUICKADD_HEIGHT, 0, 0, 0);
    
    refreshArrow.hidden = YES;
    
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
    }
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
    
    self.quickBet = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:[opponent managedObjectContext]];
    self.quickBet.date = [NSDate date];
    self.quickBet.opponent = self.opponent;
    
    
    
}


#pragma mark - TextView Delegate Functions
- (void)keyboardWillShow:(NSNotification *)note {
    
    //self.tableView.contentOffset = CGPointMake(0, -100);
    
}

- (void)keyboardDidShow:(NSNotification *)note {
    
    self.tableView.contentOffset = CGPointMake(0, -100);
    
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewDidBeginEditing");
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textViewDidEndEditing");
    
    [quickBet setReport:textView.text];
    
}


- (void)textViewDidChange:(UITextView *)textView
{
    
    
    if(textView.contentSize.height > descriptionTextView.frame.size.height)
    {
        CGRect newTextFrame = descriptionTextView.frame;
        CGRect newViewFrame = CGRectMake(self.quickAddView.frame.origin.x, self.quickAddView.frame.origin.y, self.quickAddView.frame.size.width, self.quickAddView.frame.size.height + ( textView.contentSize.height -descriptionTextView.frame.size.height ));    
        
        newTextFrame.size.height = textView.contentSize.height;
        
        
        [UIView animateWithDuration:0.02f animations:^{
            descriptionTextView.frame = newTextFrame;
            self.quickAddView.frame = newViewFrame;
            
        }];
        
    }
    else if(textView.contentSize.height < descriptionTextView.frame.size.height)
    {
        CGRect newTextFrame = descriptionTextView.frame;
        CGRect newViewFrame = CGRectMake(self.quickAddView.frame.origin.x, self.quickAddView.frame.origin.y, self.quickAddView.frame.size.width, self.quickAddView.frame.size.height - ( descriptionTextView.frame.size.height - textView.contentSize.height));    
        
        newTextFrame.size.height = textView.contentSize.height;
        
        
        [UIView animateWithDuration:0.02f animations:^{
            descriptionTextView.frame = newTextFrame;
            self.quickAddView.frame = newViewFrame;
            
        }];
    }
    
    
}


 #pragma mark - TextField Delegate Functions
 -(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
 {
 return YES;
 }
 
 -(void)textFieldDidBeginEditing:(UITextField *)textField
 {
 
 }
 
 -(void)textFieldDidEndEditing:(UITextField *)textField
 {
 NSNumberFormatter *numFormat =  [[NSNumberFormatter alloc] init];
 
 NSNumber *number = [numFormat numberFromString:amountTextField.text];
 
 if(number == nil)
 {
 
 textField.font = [UIFont systemFontOfSize:14.0f];
 textField.text = @"Must Be a Valid Number";
 textField.textColor = [UIColor redColor];
 textField.alpha = 0;
 
 [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionAutoreverse animations:^{
 textField.alpha = 1;
 }completion:^(BOOL finished){
 self.amountTextField.text = @"";
 self.amountTextField.font = [UIFont fontWithName:@"STHeitiJ-Light" size:14.0f];
 self.amountTextField.textColor = [UIColor blackColor];
 self.amountTextField.alpha = 1;
 
 
 
 
 }];
 
 }
 else
 {
 [quickBet setAmount:number];
 }
 }
 
 
 -(BOOL)textFieldShouldReturn:(UITextField *)textField
 {
 
 
 if([self.descriptionTextView.text isEqualToString:@""])
 {
 [self.descriptionTextView becomeFirstResponder];
 }
 [self.amountTextField resignFirstResponder];
 
 
 return YES;
 }
 -(BOOL)textFieldShouldEndEditing:(UITextField *)textField
 {
 return YES;
 }
 
 
 -(BOOL)saveQuickBet
 {
 
 NSError *error =  nil;
 [self.opponent.managedObjectContext save:&error];
 
 if(error)
 {
 NSLog(@"%@\n", [error  description]);
 return NO;
 }
 else 
 return YES;
 
 
 
 }
 

#pragma mark - Custom Headers

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







@end
