//
//  BetPage.m
//  DollarBets
//
//  Created by Richard Kirk on 9/8/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "BetPage.h"
#import "Opponent.h"

@interface BetPage(PrivateMethods)
-(void)setUpMap;
-(void)setUpDollars;


@end

@implementation BetPage
@synthesize bet;
@synthesize scrollView;
@synthesize titleLabel;
@synthesize dateLabel;
@synthesize dollarImageView;
@synthesize mapViewCoverUpImageView;
@synthesize descriptionTextView;
@synthesize mapView;

-(id)initWithBet:(Bet *)aBet
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.bet = aBet;
        
    }
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
    // Do any additional setup after loading the view from its nib.
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperMain2.png"]];
    self.titleLabel.text = self.bet.opponent.name;
    
    [self setUpMap];
    [self setUpDollars];
    
    self.descriptionTextView.text = self.bet.report;
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init ];
    
    [df setDateStyle:NSDateFormatterMediumStyle];
    
    self.dateLabel.text = [df stringFromDate:self.bet.date];
    
    
    /*
    MKCoordinateRegion newRegion;
    // newRegion.center.latitude = [self.bet.latitude doubleValue];
    //newRegion.center.longitude = [self.bet.longitude doubleValue];
    newRegion.center.latitude = 37.37;
    newRegion.center.longitude = -96.24;
    newRegion.span.latitudeDelta = 28.49;
    newRegion.span.longitudeDelta = 31.025;    
    [self.mapView setRegion:newRegion animated:NO];
     */
    
    }

-(void)setUpMap
{
    if ([self.bet.latitude intValue] == 0 && [self.bet.longitude intValue] == 0)
    {
        self.mapViewCoverUpImageView.alpha = 1;
        self.mapView.alpha = 0;
    }
    else
    {
        self.mapViewCoverUpImageView.alpha = 0;
        self.mapView.alpha = 1;
    }
   /*
    if (self.bet.latitude)
    {
    MKCoordinateRegion newRegion;
   // newRegion.center.latitude = [self.bet.latitude doubleValue];
    //newRegion.center.longitude = [self.bet.longitude doubleValue];
        newRegion.center.latitude = 37.37;
        newRegion.center.longitude = -96.24;
        newRegion.span.latitudeDelta = 28.49;
        newRegion.span.longitudeDelta = 31.025;    
        [self.mapView setRegion:newRegion animated:NO];
    }
    */
    
    
}

-(void)setUpDollars
{
    int betAmount = [self.bet.amount intValue];
    if(betAmount == 1)
    {
        self.dollarImageView.image = [UIImage imageNamed:@"oneDollar.png"];
    }
    else if(betAmount == 5)
    {
        self.dollarImageView.image = [UIImage imageNamed:@"fiveDollar.png"];
    }
    else
        self.dollarImageView.alpha = 0;
    
    
}


- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setScrollView:nil];
    [self setMapView:nil];
    [self setDateLabel:nil];
    [self setDollarImageView:nil];
    [self setMapViewCoverUpImageView:nil];
    [self setDescriptionTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
