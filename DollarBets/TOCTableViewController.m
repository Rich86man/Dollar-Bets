//
//  TOCTableViewController.m
//  DollarBets
//
//  Created by Richard Kirk on 9/4/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "TOCTableViewController.h"
#import "TOCBetsTableViewCell.h"
#import "RootBookViewController.h"

#define SAVE_BUTTON_HEIGHT 45.0f
#define SAVE_BUTTON_WIDTH 275.0f
#define SAVE_BUTTON_DEFAULT_ORIGIN_X 21.0f
#define SAVE_BUTTON_DEFAULT_ORIGIN_Y 122.0f
#define QUICKVIEW_DEFAULT_HEIGHT 122.0f
#define SAVE_BUTTON_BOTTOM_PADDING 10.0f
#define PADDING 20.0f


@interface TOCTableViewController (PrivateMethods)
-(void)addSaveButton;
-(void)removeSaveButton;
-(void)resizeQuickView;
-(void)showHomeButton:(NSInteger)duration;
-(void)hideHomeButton:(NSInteger)duration;
@end

@implementation TOCTableViewController
@synthesize editButton;
@synthesize homeButton;
@synthesize delegate;
@synthesize tableView;
@synthesize opponent, bets,  bet;
@synthesize myHomeButtonTimer;
@synthesize quickAddView, amountTextView, amountLabel, descriptionTextView, saveButton;
@synthesize overlayView, overlayLabel;
@synthesize headerView;


-(id)initWithOpponent:(Opponent *)opp
{
    self = [super init];
    if(self)
    {
        self.opponent = opp;
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    /* setup the Views */
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"handmadepaper.png"]];
    self.quickAddView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"crissXcross.png"]];
    self.headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black-Linen.png"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapHeader)];
    [self.headerView addGestureRecognizer:tap];
    tap.delegate = self;
    UITapGestureRecognizer *amountLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapAmountLabel)];
    [self.amountLabel addGestureRecognizer:amountLabelTap];
    
    /* Retrieve the list of bets for the tableview */
    NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
    self.bets = [self.opponent.bets sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    
    /* Check the current position of the Home button */ 
    if(self.homeButton.frame.size.height < 1)
        homeButtonShowing = NO;
    else
        homeButtonShowing = YES;
    
    if ([self.bets count] == 0) {
        self.editButton.alpha = 0;
    }
    else
        self.editButton.alpha = 1;
    
    self.homeButton.alpha = 1.0f;
    isQuickAdding = NO;
    isDragging = NO;
}


-(void)viewDidAppear:(BOOL)animated
{
    self.myHomeButtonTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self.myHomeButtonTimer invalidate];
    [self hideHomeButton:0.0f];
}


- (void)viewDidUnload
{
    [self setQuickAddView:nil];
    [self setHeaderView:nil];
    [self setDescriptionTextView:nil];
    [self setTableView:nil];
    [self setOverlayView:nil];
    [self setSaveButton:nil];
    [self setOverlayLabel:nil];
    [self setAmountLabel:nil];
    [self setBet:nil];
    [self setAmountTextView:nil];
    [self setHomeButton:nil];
    [self setEditButton:nil];
    [super viewDidUnload];
    
}


-(NSString *)description
{
    return @"TableOfContents Page";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bets count] + 1;    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *normalCell = @"betCell";
    static NSString *addBetCell = @"addBetCell";
    
    if (indexPath.row < [self.bets count]) 
    {
        TOCBetsTableViewCell *betCell = [self.tableView dequeueReusableCellWithIdentifier:normalCell];
        if (betCell == nil)
        {   
            betCell = [[TOCBetsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:normalCell];
        }
        betCell.amountLabel.text = [NSString stringWithFormat:@"$%@",[[[bets objectAtIndex:indexPath.row] amount] stringValue]];   
        betCell.descriptionLabel.text = [[bets objectAtIndex:indexPath.row] report];
        switch ([[[bets objectAtIndex:indexPath.row] didWin] intValue]) {
            case 0:
                             [betCell.amountLabel setTextColor:[UIColor colorWithRed:RGB256_TO_COL(178) green:RGB256_TO_COL(54) blue:RGB256_TO_COL(54) alpha:1.0]];

                break;
            case 1:
                [betCell.amountLabel setTextColor:[UIColor colorWithRed:RGB256_TO_COL(12) green:RGB256_TO_COL(134) blue:RGB256_TO_COL(24) alpha:1.0]];
                break;
            default:
                [betCell.amountLabel setTextColor:[UIColor blackColor]];
                break;
        }
        
        return betCell;  
    }
    else
    {
        TOCBetsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:addBetCell];
        if (cell == nil) 
        {
            cell = [[TOCBetsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:addBetCell];
        }
        cell.addNew.alpha = 1.0f;
        
        return cell;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.headerView.frame.size.height;    
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.bets count] +1)
        return NO;
    else
        return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.bets count])
        return UITableViewCellEditingStyleNone;
    else 
        return UITableViewCellEditingStyleDelete;
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= [self.bets count]) 
    {
        Bet *betToDelete = [self.bets objectAtIndex:indexPath.row];
        [Bet deleteBet:betToDelete];
        
        NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
        self.bets = [self.opponent.bets sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
        
        if ([self.bets count] == 0)
            self.editButton.alpha = 0;
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];   
    }

}

- (IBAction)editButtonSelected:(id)sender 
{
    
    [self.tableView setEditing:!self.tableView.editing];
    [self.delegate editingTable:self.tableView.editing];
    [self.editButton setHighlighted:![self.editButton isHighlighted]];
    
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(!isQuickAdding)
    {
        if (!self.tableView.editing) 
        {
            NSUInteger page = indexPath.row + 1;
            [self.delegate didSelectPage:page];
            
        }
        else if (indexPath.row == [self.bets count])
        {
            NSUInteger page = indexPath.row + 1;
            [self.delegate didSelectPage:page];
            ; 
            
        }
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];    
    
    
}



#pragma mark - ScrollViewDelegate Functions

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -1.0) 
    {
        [self.myHomeButtonTimer invalidate];
        [self hideHomeButton:0.0f];
    }
    
    if( scrollView.contentOffset.y <= -1.0f && scrollView.contentOffset.y > -122.0f && !isQuickAdding)
    {
        CGFloat offset =   scrollView.contentOffset.y;
        self.quickAddView.frame = CGRectMake(0, 0, 305, -offset);
        
        if (offset > -90 && offset < 0)
            self.overlayView.alpha = -offset / 100;
    }
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // If you pull past 100px Begin Quick adding
    if (scrollView.contentOffset.y < -122.0f && !isQuickAdding)
    {
        self.overlayLabel.text = @"Pull Down To Cancel";
        scrollView.contentInset = UIEdgeInsetsMake(122.0, 0, 0, 0 );
        isQuickAdding = YES;
        [self.delegate didBeginQuickAdd:self];
        if(!self.bet)
        {
            self.bet = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.opponent.managedObjectContext];
            self.bet.opponent = self.opponent;
            self.bet.didWin = [NSNumber numberWithInt:2];
            self.bet.amount = [NSNumber numberWithInt:1];
            self.bet.date = [NSDate date];
        }
        [self hideHomeButton:0.0f];
        [self.myHomeButtonTimer invalidate];
        [self resizeQuickView];
    }
    // If they are currently quickadding and they pull past 160 px, cancel quick add.
    if (scrollView.contentOffset.y < -160.0f && isQuickAdding)
    {
        isQuickAdding = NO;
        [self.delegate savedQuickBet];        
        [UIView  animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState
                          animations:^{
                              scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0 );
                              
                          }completion:^(BOOL finished){        
                              self.overlayLabel.text = @"Pull Down To Add New";
                              
                          }];
        
        self.overlayLabel.text = @"Pull Down To Add New";
        self.myHomeButtonTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showHomeButton:) userInfo:nil repeats:NO];
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y == 0 && ![self.myHomeButtonTimer isValid])
    {
        self.myHomeButtonTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
    }
    
}

#pragma mark - TextView Delegate Functions

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.tag == 0)
        [self.delegate didBeginEditingDescription];
}


- (void)textViewDidChange:(UITextView *)textView
{
    
    if(textView.tag == 0)
    {
        if([textView.text isEqualToString:@""])
        {
            [self removeSaveButton];
        }
        else 
        {
            [self addSaveButton];
        }
        
        if(textView.contentSize.height > descriptionTextView.frame.size.height)
        {
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
    else
    {
        
        NSNumberFormatter *nf = [[NSNumberFormatter alloc]init];
        NSNumber *newAmount = [nf numberFromString:textView.text]; 
        
        if([newAmount intValue] < 101 && [newAmount intValue] >= 0)
        {
            self.bet.amount = newAmount;
            [self setUpAmountLabel];
        }
        
    }
    
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 0) 
    {
        self.bet.report = self.descriptionTextView.text;
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView.tag == 1)
    {
    if (range.length > 2 || range.location > 2)
        return NO;
    else 
        return YES;
    }
    
    return YES;
}


#pragma mark - Quick Add Functions

-(void)resizeQuickView;
{
    if(self.saveButton.alpha == 1)
    {
        self.saveButton.frame = CGRectMake(SAVE_BUTTON_DEFAULT_ORIGIN_X, SAVE_BUTTON_DEFAULT_ORIGIN_Y + self.descriptionTextView.frame.size.height - 31, SAVE_BUTTON_WIDTH, SAVE_BUTTON_HEIGHT);
    }
    else if(self.saveButton.alpha == 0)
    {
        self.saveButton.frame = CGRectMake(SAVE_BUTTON_DEFAULT_ORIGIN_X, SAVE_BUTTON_DEFAULT_ORIGIN_Y, SAVE_BUTTON_WIDTH, 0);
    }
    
    CGRect newQuickViewFrame;
    
    if (self.saveButton.alpha == 0.0f)
        newQuickViewFrame = CGRectMake(0, 0, 305, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height + PADDING);
    else
        newQuickViewFrame = CGRectMake(0, 0, 305, self.saveButton.frame.origin.y + self.saveButton.frame.size.height + PADDING);
    
    CGRect newOverlayFrame = self.overlayLabel.frame;
    newOverlayFrame.origin.y = newQuickViewFrame.size.height + PADDING;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                            self.quickAddView.frame = newQuickViewFrame;
                            self.overlayLabel.frame = newOverlayFrame; } completion:nil];
    
}


-(void)addSaveButton
{
    if (self.saveButton.alpha == 0)
    {        
        self.saveButton.alpha = 1;
        [self resizeQuickView];
    }
}


-(void)removeSaveButton
{    
    if(self.saveButton.alpha == 1)
    {
        self.saveButton.alpha = 0;
        [self resizeQuickView];
    }    
}


- (IBAction)save:(UIButton *)sender 
{    
    [self.delegate doneButtonSelected:nil];
    
    if([bet save])
    {
        [self removeSaveButton];
        self.amountLabel.text = @"+1";
        self.descriptionTextView.text = @"";
        CGRect frame =  self.descriptionTextView.frame;
        frame.size.height = 31;
        self.descriptionTextView.frame = frame;
        self.overlayLabel.text = @"Pull Down To Add New";
        
        [UIView  animateWithDuration:0.5f delay:0.5f options:UIViewAnimationCurveEaseInOut animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0 );
            self.tableView.contentOffset = CGPointMake(0, 0); 
            self.quickAddView.frame = CGRectMake(0, 0, 305, 0);
            self.overlayView.alpha = 0;
        }completion:nil];
        
        isQuickAdding = NO;
        
        NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
        self.bets = [self.opponent.bets sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
        
        if ([self.bets count] > 0) 
        {
            self.editButton.alpha = 1.0f;
        }
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.bets count] -1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        [self.delegate savedQuickBet];
        self.bet = nil;
        [self.amountLabel setTextColor:[UIColor grayColor]];
        
    }
}


-(void)didTapHeader
{
    [self.myHomeButtonTimer invalidate];
    [self showHomeButton:0.0f];
}


-(void)didTapAmountLabel
{
    [self.delegate changeEditStateTo:1];
}

- (IBAction)homeButtonSelected:(id)sender 
{
    [self.delegate didselectHomeButton];
}


-(void)setUpAmountLabel
{
    UILabel *label = self.amountLabel;
    
    switch ([self.bet.didWin intValue]) 
    {
        case 0:
            label.text = [NSString stringWithFormat:@"- $%i",[self.bet.amount intValue]];
            label.textColor = [UIColor redColor];
            break;
        case 1:
            label.text = [NSString stringWithFormat:@"+ $%i",[self.bet.amount intValue]];
            label.textColor = [UIColor greenColor];
            break;
        case 2:
            label.text = [NSString stringWithFormat:@"-/+ $%i",[self.bet.amount intValue]];
            label.textColor = [UIColor grayColor];
            break;
        default:
            break;
    }
}


-(void)timerFired
{
    if(!isQuickAdding)
        [self showHomeButton:1.0];
}


-(void)showHomeButton:(NSInteger)duration
{
    if(!duration)
    {
        duration = 1.0f;
    }
    
    if(!homeButtonShowing)
    {
        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             self.homeButton.frame = CGRectMake(20, 0, 44, 61);
                         } completion:nil];
        homeButtonShowing = YES;
    }
    
}


-(void)hideHomeButton:(NSInteger)duration
{
    if (!duration) 
    {
        duration = 0.05f;
    }
    if(homeButtonShowing)
    {
        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             self.homeButton.frame = CGRectMake(20, 0, 44, 0);
                         } completion:nil];
        homeButtonShowing = NO;    
    }
    
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    else return YES;
}


@end
