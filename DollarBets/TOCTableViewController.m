//
//  TOCTableViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 9/4/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "TOCTableViewController.h"
#import "statusBarView.h"
#import "TOCBetsTableViewCell.h"


#define SAVE_BUTTON_HEIGHT 75.0f
#define SAVE_BUTTON_WIDTH 221.0f
#define SAVE_BUTTON_DEFAULT_ORIGIN_X 50.0f
#define SAVE_BUTTON_DEFAULT_ORIGIN_Y 122.0f
#define QUICKVIEW_DEFAULT_HEIGHT 122.0f
#define SAVE_BUTTON_BOTTOM_PADDING 10.0f
#define PADDING 20.0f


@interface TOCTableViewController (PrivateMethods)
-(void)addSaveButton;
-(void)removeSaveButton;
-(void)resizeQuickView;
-(BOOL)saveQuickBet;
@end

@implementation TOCTableViewController
@synthesize delegate;
@synthesize saveButton;
@synthesize overlayView;
@synthesize overlayLabel;
@synthesize statusBar;
@synthesize tableView;

@synthesize tableOfContentsHeader = _tableOfContentsHeader, graphsHeader = _graphsHeader;
@synthesize quickAddView, amountTextField, descriptionTextView, refreshArrow, quickBet;
@synthesize opponent, bets;




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    
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
    [self setOverlayLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    static NSString *sec1 = @"section1";
    static NSString *sec0 = @"section0";
    
    if (indexPath.section == 0) {
        TOCBetsTableViewCell *betCell = [self.tableView dequeueReusableCellWithIdentifier:sec0];
        if (betCell == nil)
        {   
            betCell = [[TOCBetsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sec0];
        }
        
        
        betCell.amountLabel.text = [NSString stringWithFormat:@"$%@",[[[bets objectAtIndex:indexPath.row] amount] stringValue]];     
        betCell.descriptionLabel.text = [[bets objectAtIndex:indexPath.row] report];
        
        return betCell;   
        
    }
    else
    {
        
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:sec1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sec1];
        }
        
        cell.textLabel.text = @"Testing";
        
        
        return cell;
    }
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
            return self.tableOfContentsHeader.frame.size.height;
            break;
        case 1:
            return self.graphsHeader.frame.size.height;
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
    NSUInteger index = indexPath.row + 1;
    [self.delegate didSelectPage:index];
}



#pragma mark - ScrollViewDelegate Functions



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if( scrollView.contentOffset.y <= 0.0f && scrollView.contentOffset.y > -100.0f && !isQuickAdding)
    {
        CGFloat offset =   scrollView.contentOffset.y;
        
        self.quickAddView.frame = CGRectMake(0, 0, 320, -offset);
                if (offset > -90 && offset < 0)
            self.overlayView.alpha = -offset / 100;
        
        
    }
    
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // If you pull past 100px Begin Quick adding
    if (scrollView.contentOffset.y < -100.0f && !isQuickAdding)
    {
        self.overlayLabel.text = @"Pull Down To Cancel";
        scrollView.contentInset = UIEdgeInsetsMake(100.0, 0, 0, 0 );
        isQuickAdding = YES;
        [self resizeQuickView];
        
    }
    // If they are currently quickadding and they pull past 160 px, cancel quick add.
    if (scrollView.contentOffset.y < -160.0f && isQuickAdding)
    {
        
        //[self removeSaveButton];
        //self.quickAddView.frame = self.quickAddView.frame = CGRectMake(0, 0, 320, 100);
        
        [UIView  animateWithDuration:3.5f delay:0.0f options:UIViewAnimationCurveEaseInOut animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0 );
            scrollView.contentOffset = CGPointMake(0, 0);
            self.quickAddView.frame = CGRectMake(0, 0, 320, 0);
        }completion:^(BOOL finished){        
            self.overlayLabel.text = @"Pull Down To Add New";
            
        }];
        
        
        
        isQuickAdding = NO;
    }
    
    
    
}



#pragma mark - TextView Delegate Functions


- (void)textViewDidChange:(UITextView *)textView
{
    
    if([textView.text isEqualToString:@""])
    {
        [self removeSaveButton];
    }
    else if (![self.amountTextField.text isEqualToString:@""])
    {
        [self addSaveButton];
    }
    
    
    if(textView.contentSize.height > descriptionTextView.frame.size.height)
    {
        NSLog(@"New descriptionTextView.contentSize.height = %f",textView.contentSize.height);
        CGRect newTextFrame = descriptionTextView.frame;
        CGRect newViewFrame = CGRectMake(self.quickAddView.frame.origin.x, self.quickAddView.frame.origin.y, self.quickAddView.frame.size.width, self.quickAddView.frame.size.height + ( textView.contentSize.height -descriptionTextView.frame.size.height ));    
        CGRect newOverlayFrame = CGRectMake(self.overlayView.frame.origin.x, self.overlayView.frame.origin.y + ( textView.contentSize.height -descriptionTextView.frame.size.height ), self.overlayView.frame.size.width , self.overlayView.frame.size.height);
        
        CGRect newSaveButtonFrame = CGRectMake(SAVE_BUTTON_DEFAULT_ORIGIN_X, self.saveButton.frame.origin.y + ( textView.contentSize.height -descriptionTextView.frame.size.height ), SAVE_BUTTON_WIDTH, self.saveButton.frame.size.height);
        
        
        
        
        newTextFrame.size.height = textView.contentSize.height;
        
        
        [UIView animateWithDuration:0.02f animations:^{
            descriptionTextView.frame = newTextFrame;
            self.quickAddView.frame = newViewFrame;
            self.overlayView.frame = newOverlayFrame;
            self.saveButton.frame = newSaveButtonFrame;
        }];
        
    }
    else if(textView.contentSize.height < descriptionTextView.frame.size.height)
    {
        NSLog(@"New descriptionTextView.contentSize.height = %f",textView.contentSize.height);
        CGRect newTextFrame = descriptionTextView.frame;
        CGRect newViewFrame = CGRectMake(self.quickAddView.frame.origin.x, self.quickAddView.frame.origin.y, self.quickAddView.frame.size.width, self.quickAddView.frame.size.height - ( descriptionTextView.frame.size.height - textView.contentSize.height));    
        CGRect newOverlayFrame = CGRectMake(self.overlayView.frame.origin.x, self.overlayView.frame.origin.y - ( descriptionTextView.frame.size.height - textView.contentSize.height ), self.overlayView.frame.size.width , self.overlayView.frame.size.height);
        
        CGRect newSaveButtonFrame = CGRectMake(SAVE_BUTTON_DEFAULT_ORIGIN_X, self.saveButton.frame.origin.y - ( descriptionTextView.frame.size.height - textView.contentSize.height ), SAVE_BUTTON_WIDTH, self.saveButton.frame.size.height);
        
        
        
        newTextFrame.size.height = textView.contentSize.height;
        
        
        [UIView animateWithDuration:0.02f animations:^{
            descriptionTextView.frame = newTextFrame;
            self.quickAddView.frame = newViewFrame;
            self.overlayView.frame = newOverlayFrame;
            self.saveButton.frame = newSaveButtonFrame;
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
        
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}



#pragma mark - TextField Delegate Functions

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.text.length > 20)
        return NO;
    
    if([string length] < 1 && range.location == 0)
    {
        [self removeSaveButton];
    }
    else if (![self.descriptionTextView.text isEqualToString:@""])
    {
        [self addSaveButton];
    }
    
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:@""])
    {
        [self removeSaveButton];
    }
    else 
    {
        
        if(![self.descriptionTextView.text isEqualToString:@""])
        {
            [self addSaveButton];
        }
        
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
            [self removeSaveButton];
            
        }
        else
        {
            
            
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




#pragma mark - Quick Add Functions

-(void)resizeQuickView;
{
    
    
    
    if(self.saveButton.alpha == 1){
        self.saveButton.frame = CGRectMake(SAVE_BUTTON_DEFAULT_ORIGIN_X, SAVE_BUTTON_DEFAULT_ORIGIN_Y + self.descriptionTextView.frame.size.height - 31, SAVE_BUTTON_WIDTH, SAVE_BUTTON_HEIGHT);
        
    }
    else if(self.saveButton.alpha == 0)
    {
        self.saveButton.frame = CGRectMake(SAVE_BUTTON_DEFAULT_ORIGIN_X, SAVE_BUTTON_DEFAULT_ORIGIN_Y, SAVE_BUTTON_WIDTH, 0);
    }
    
    
    CGRect newQuickViewFrame = CGRectMake(0, 0, 320, PADDING + self.amountTextField.frame.size.height + PADDING + self.descriptionTextView.frame.size.height + PADDING + saveButton.frame.size.height + (self.saveButton.alpha == 1 ? SAVE_BUTTON_BOTTOM_PADDING : 0) );
    
    
    [UIView animateWithDuration:0.5f animations:^{
        self.quickAddView.frame = newQuickViewFrame;
    }];
    
    
    
    
    
}

-(void)addSaveButton
{
    if (self.saveButton.alpha == 0)
    {        
        
        CGRect newSaveButtonFrame = CGRectMake(SAVE_BUTTON_DEFAULT_ORIGIN_X, SAVE_BUTTON_DEFAULT_ORIGIN_Y + self.descriptionTextView.frame.size.height - 31, SAVE_BUTTON_WIDTH, SAVE_BUTTON_HEIGHT);
        
        CGRect newQuickViewFrame = CGRectMake(0, 0, 320, PADDING + self.amountTextField.frame.size.height + PADDING + self.descriptionTextView.frame.size.height + PADDING + newSaveButtonFrame.size.height + SAVE_BUTTON_BOTTOM_PADDING);   
        
        self.saveButton.frame = newSaveButtonFrame;
        CGFloat alphaValue = 1;
        
        
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationCurveEaseInOut animations:^() {
            self.saveButton.frame = newSaveButtonFrame;
            self.quickAddView.frame = newQuickViewFrame;
            self.saveButton.alpha = alphaValue;
            
        } completion:nil];
    }
    
    
}

-(void)removeSaveButton{
    
    if(self.saveButton.alpha == 1)
    {
        
        
        CGRect newSaveButtonFrame = CGRectMake(SAVE_BUTTON_DEFAULT_ORIGIN_X, SAVE_BUTTON_DEFAULT_ORIGIN_Y, SAVE_BUTTON_WIDTH, 0);
        CGRect newQuickViewFrame = CGRectMake(0, 0, 320, PADDING + self.amountTextField.frame.size.height + PADDING + self.descriptionTextView.frame.size.height + PADDING);   
        
        
        CGFloat alphaValue = 0;
        
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationCurveEaseInOut animations:^() {
            self.quickAddView.frame = newQuickViewFrame;
            self.saveButton.frame = newSaveButtonFrame;
            self.saveButton.alpha = alphaValue;
            
            
        } completion:nil];
    }
    
}


- (IBAction)save:(UIButton *)sender {
    
    if([self.amountTextField isFirstResponder])
        [self.amountTextField resignFirstResponder];
    
    if([self.descriptionTextView isFirstResponder])
        [self.descriptionTextView resignFirstResponder];
    
    
    if([self saveQuickBet])
    {
        
        [self removeSaveButton];
        self.amountTextField.text = @"";
        self.descriptionTextView.text = @"";
        self.overlayLabel.text = @"Pull Down To Add New";
        
        [UIView  animateWithDuration:0.5f delay:0.5f options:UIViewAnimationCurveEaseInOut animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0 );
            self.tableView.contentOffset = CGPointMake(0, 0); 
            self.quickAddView.frame = CGRectMake(0, 0, 320, 0);
            self.overlayView.alpha = 0;
        }completion:^(BOOL finished){
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.bets count] -1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            
            
        }];
        
        
        
        isQuickAdding = NO;
        
        
        NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
        self.bets = [self.opponent.bets sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
        
    }
    
    
}

-(BOOL)saveQuickBet
{
    NSNumberFormatter *numFormat =  [[NSNumberFormatter alloc] init];
    
    
    
    
    Bet *newBet = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:[self.opponent managedObjectContext]];
    newBet.opponent = self.opponent;
    newBet.amount = [numFormat numberFromString:amountTextField.text];
    newBet.report = self.descriptionTextView.text;
    newBet.date = [NSDate date];
    newBet.didWin = [NSNumber numberWithInt:2];
    
    
    
    NSError *error =  nil;
    [newBet.managedObjectContext save:&error];
    
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
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black-Linen.png"]];
        
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
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black-Linen.png"]];
        
        
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
