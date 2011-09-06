//
//  TOCTableViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 9/4/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "TOCTableViewController.h"



@implementation TOCTableViewController
@synthesize overlayView;
@synthesize tableView;

@synthesize tableOfContentsHeader = _tableOfContentsHeader, graphsHeader = _graphsHeader;
@synthesize quickAddView, amountTextField, descriptionTextView, refreshArrow, quickBet;
@synthesize opponent, bets;



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
    
    // Uncomment the following line to preserve selection between presentations.
   
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"handmadepaper.png"]];
    
    NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
    
    self.bets = [self.opponent.bets sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];

    self.quickAddView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_denim.png"]];

    
    
      
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
    [self setTableView:nil];
    [self setOverlayView:nil];
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
            return self.tableOfContentsHeader.frame.size.height + 20;
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


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if( scrollView.contentOffset.y <= 0.0f && scrollView.contentOffset.y > -100.0f)
    {
        CGFloat offset =   scrollView.contentOffset.y;
        
        self.quickAddView.frame = CGRectMake(0, 0, 320, -offset);
        if (offset > -90)
        self.overlayView.alpha = -offset / 100;
        
        
    }
    
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (scrollView.contentOffset.y < -100.0f && !isQuickAdding)
    {
        scrollView.contentInset = UIEdgeInsetsMake(100.0, 0, 0, 0 );
        isQuickAdding = YES;
    }
    
        if (scrollView.contentOffset.y < -150.0f && isQuickAdding)
        {
             scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0 );
            isQuickAdding = NO;
        }
    
    
    
}

#pragma mark - TextView Delegate Functions

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
