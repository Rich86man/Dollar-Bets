//
//  TOCTableViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 9/4/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "TOCTableViewController.h"
#import "statusBarView.h"

#define SAVE_BUTTON_HEIGHT 75.0f
#define SAVE_BUTTON_WIDTH 221.0f
#define QUICKVIEW_DEFAULT_HEIGHT 100.0f

@interface TOCTableViewController (PrivateMethods)
-(void)addSaveButton;
-(void)removeSaveButton;
-(void)resizeQuickView:(BOOL)isOpening;
-(BOOL)saveQuickBet;
@end

@implementation TOCTableViewController
@synthesize saveButton;
@synthesize overlayView;
@synthesize statusBar;
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
    
    self.quickBet = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:[self.opponent managedObjectContext]];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"handmadepaper.png"]];
    
    NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
    
    self.bets = [self.opponent.bets sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    self.view.backgroundColor = [UIColor clearColor];
    self.quickAddView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_denim.png"]];
    self.statusBar.backgroundColor = [UIColor clearColor];
    self.statusBar.centerLabel.text = @"Quick Add";
    
    
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
    [self setStatusBar:nil];
    [self setSaveButton:nil];
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
        if (offset > -90 && offset < 0)
            self.overlayView.alpha = -offset / 100;
        
        
    }
    
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (scrollView.contentOffset.y < -100.0f && !isQuickAdding)
    {
        scrollView.contentInset = UIEdgeInsetsMake(100.0, 0, 0, 0 );
        isQuickAdding = YES;
        [self resizeQuickView:YES];
    }
    
    if (scrollView.contentOffset.y < -160.0f && isQuickAdding)
    {
   
        //[self removeSaveButton];
        //self.quickAddView.frame = self.quickAddView.frame = CGRectMake(0, 0, 320, 100);
        
        [UIView  animateWithDuration:0.5f delay:0.0f options:UIViewAnimationCurveEaseInOut animations:^{
                 scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0 );
            scrollView.contentOffset = CGPointMake(0, 0);
            self.quickAddView.frame = CGRectMake(0, 0, 320, 0);
        }completion:nil];
        
        
        
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
    
    if([textView.text isEqualToString:@""])
    {
        [self removeSaveButton];
    }

    
    if(textView.contentSize.height > descriptionTextView.frame.size.height)
    {
        CGRect newTextFrame = descriptionTextView.frame;
        CGRect newViewFrame = CGRectMake(self.quickAddView.frame.origin.x, self.quickAddView.frame.origin.y, self.quickAddView.frame.size.width, self.quickAddView.frame.size.height + ( textView.contentSize.height -descriptionTextView.frame.size.height ));    
        CGRect newOverlayFrame = CGRectMake(self.overlayView.frame.origin.x, self.overlayView.frame.origin.y + ( textView.contentSize.height -descriptionTextView.frame.size.height ), self.overlayView.frame.size.width , self.overlayView.frame.size.height);
        
        
        
        newTextFrame.size.height = textView.contentSize.height;
        
        
        [UIView animateWithDuration:0.02f animations:^{
            descriptionTextView.frame = newTextFrame;
            self.quickAddView.frame = newViewFrame;
            self.overlayView.frame = newOverlayFrame;
        }];
        
    }
    else if(textView.contentSize.height < descriptionTextView.frame.size.height)
    {
        CGRect newTextFrame = descriptionTextView.frame;
        CGRect newViewFrame = CGRectMake(self.quickAddView.frame.origin.x, self.quickAddView.frame.origin.y, self.quickAddView.frame.size.width, self.quickAddView.frame.size.height - ( descriptionTextView.frame.size.height - textView.contentSize.height));    
        CGRect newOverlayFrame = CGRectMake(self.overlayView.frame.origin.x, self.overlayView.frame.origin.y - ( descriptionTextView.frame.size.height - textView.contentSize.height ), self.overlayView.frame.size.width , self.overlayView.frame.size.height);
        newTextFrame.size.height = textView.contentSize.height;
        
        
        [UIView animateWithDuration:0.02f animations:^{
            descriptionTextView.frame = newTextFrame;
            self.quickAddView.frame = newViewFrame;
            self.overlayView.frame = newOverlayFrame;
            
        }];
    }
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{    
    
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        if (![self.amountTextField.text isEqualToString:@""])
        {
                 [self addSaveButton];
        }
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
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
    if([textField.text isEqualToString:@""])
    {
        [self removeSaveButton];
    }
    
    else 
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
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    if([self.descriptionTextView.text isEqualToString:@""])
    {
        [self.descriptionTextView becomeFirstResponder];
    }
    else 
    {
        [self addSaveButton];
    }
    
    [self.amountTextField resignFirstResponder];
    
    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}




#pragma mark - Quick Add Functions

-(void)resizeQuickView:(BOOL)isOpening
{
    
    if (isOpening) {
        

        
        
        CGRect newQuickViewFrame = CGRectMake(0, 0, 320, QUICKVIEW_DEFAULT_HEIGHT + self.descriptionTextView.frame.size.height + saveButton.frame.size.height - 21 );
        
        [UIView animateWithDuration:0.5f animations:^{
            self.quickAddView.frame = newQuickViewFrame;
        }];
        
        
    }
    
    
    
    
}

-(void)addSaveButton
{
        if (self.saveButton.alpha == 0)
        {
        CGRect newQuickAddFrame = CGRectMake(self.quickAddView.frame.origin.x, self.quickAddView.frame.origin.y , self.quickAddView.frame.size.width, self.quickAddView.frame.size.height + SAVE_BUTTON_HEIGHT + 10);
        CGRect newSaveButtonFrame = CGRectMake( (self.quickAddView.frame.size.width - SAVE_BUTTON_WIDTH) / 2, newQuickAddFrame.size.height - SAVE_BUTTON_HEIGHT - 10,SAVE_BUTTON_WIDTH, SAVE_BUTTON_HEIGHT);
        self.saveButton.frame = newSaveButtonFrame;
        CGFloat alphaValue = 1;
        
        
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationCurveEaseInOut animations:^() {
            self.quickAddView.frame = newQuickAddFrame;
            self.saveButton.alpha = alphaValue;
            
        } completion:nil];
        }
           
    
}

-(void)removeSaveButton{
    
    if(self.saveButton.alpha == 1)
    {
        CGRect newQuickAddFrame = CGRectMake(self.quickAddView.frame.origin.x, self.quickAddView.frame.origin.y , self.quickAddView.frame.size.width, self.quickAddView.frame.size.height - SAVE_BUTTON_HEIGHT + 10);
        CGRect newSaveButtonFrame = CGRectMake(0,0,0,0);
        self.saveButton.frame = newSaveButtonFrame;
        CGFloat alphaValue = 0;
        
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationCurveEaseInOut animations:^() {
            self.quickAddView.frame = newQuickAddFrame;
            self.saveButton.alpha = alphaValue;
            
        } completion:nil];
    }
    
}


- (IBAction)save:(UIButton *)sender {
    if([self saveQuickBet])
    {
        
        [self removeSaveButton];
        self.amountTextField.text = @"";
        self.descriptionTextView.text = @"";
        
        
        [UIView  animateWithDuration:0.5f delay:0.5f options:UIViewAnimationCurveEaseInOut animations:^{

            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0 );
            self.tableView.contentOffset = CGPointMake(0, 0); 
            self.quickAddView.frame = CGRectMake(0, 0, 320, 0);
        }completion:nil];
        
        
        
        isQuickAdding = NO;
        
        
        NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
        self.bets = [self.opponent.bets sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
        
        
        
        self.quickBet = nil;
        self.quickBet = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:[self.opponent managedObjectContext]];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.bets count] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        
        
    }

    
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
        
        UILabel *tl = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 280, 46)];    
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
