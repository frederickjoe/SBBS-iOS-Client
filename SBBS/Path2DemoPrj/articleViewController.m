//
//  articleViewController.m
//  FTCoreText
//
//  Created by Francesco Frison on 18/08/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "articleViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation articleViewController
@synthesize scrollView;
@synthesize coreTextView;


- (NSString *)textForView
{
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"text" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
}


- (NSArray *)coreTextStyle
{
    NSMutableArray *result = [NSMutableArray array];
    
	FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
	defaultStyle.name = FTCoreTextTagDefault;	//thought the default name is already set to FTCoreTextTagDefault
    defaultStyle.color = [UIColor grayColor];
	defaultStyle.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:16.f];
	defaultStyle.textAlignment = FTCoreTextAlignementCenter;
	[result addObject:defaultStyle];
	
	FTCoreTextStyle *titleStyle = [FTCoreTextStyle styleWithName:@"title"]; // using fast method
	titleStyle.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:20.f];
	titleStyle.paragraphInset = UIEdgeInsetsMake(0, 0, 25, 0);
	titleStyle.textAlignment = FTCoreTextAlignementCenter;
	[result addObject:titleStyle];
	
	FTCoreTextStyle *imageStyle = [FTCoreTextStyle new];
	imageStyle.paragraphInset = UIEdgeInsetsMake(0,0,0,0);
	imageStyle.name = FTCoreTextTagImage;
	imageStyle.textAlignment = FTCoreTextAlignementCenter;
	[result addObject:imageStyle];
	[imageStyle release];	
	
	FTCoreTextStyle *firstLetterStyle = [FTCoreTextStyle new];
	firstLetterStyle.name = @"firstLetter";
	firstLetterStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:30.f];
	[result addObject:firstLetterStyle];
	[firstLetterStyle release];
	
	FTCoreTextStyle *linkStyle = [defaultStyle copy];
	linkStyle.name = FTCoreTextTagLink;
	linkStyle.color = [UIColor blackColor];
	[result addObject:linkStyle];
	[linkStyle release];
	
	FTCoreTextStyle *subtitleStyle = [FTCoreTextStyle styleWithName:@"subtitle"];
	subtitleStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:16.f];
	subtitleStyle.color = [UIColor blackColor];
    subtitleStyle.textAlignment = FTCoreTextAlignementCenter;
	subtitleStyle.paragraphInset = UIEdgeInsetsMake(10, 0, 10, 0);
	[result addObject:subtitleStyle];
	
	FTCoreTextStyle *bulletStyle = [defaultStyle copy];
	bulletStyle.name = FTCoreTextTagBullet;
	bulletStyle.bulletFont = [UIFont fontWithName:@"TimesNewRomanPSMT" size:16.f];
	bulletStyle.bulletColor = [UIColor orangeColor];
	bulletStyle.bulletCharacter = @"❧";
	[result addObject:bulletStyle];
	[bulletStyle release];
    
    FTCoreTextStyle *italicStyle = [defaultStyle copy];
	italicStyle.name = @"italic";
	italicStyle.underlined = YES;
    italicStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:16.f];
	[result addObject:italicStyle];
	[italicStyle release];
    
    FTCoreTextStyle *boldStyle = [defaultStyle copy];
	boldStyle.name = @"bold";
    boldStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:16.f];
	[result addObject:boldStyle];
	[boldStyle release];
    
    FTCoreTextStyle *coloredStyle = [defaultStyle copy];
    [coloredStyle setName:@"colored"];
    [coloredStyle setColor:[UIColor redColor]];
	[result addObject:coloredStyle];
    [defaultStyle release];
    
    return  result;
}

- (void)coreTextView:(FTCoreTextView *)acoreTextView receivedTouchOnData:(NSDictionary *)data {
    
    CGRect frame = CGRectFromString([data objectForKey:FTCoreTextDataFrame]);
    
    if (CGRectEqualToRect(CGRectZero, frame)) return;
    
    frame.origin.x -= 3;
    frame.origin.y -= 1;
    frame.size.width += 6;
    frame.size.height += 6;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view.layer setCornerRadius:3];
    [view setBackgroundColor:[UIColor orangeColor]];
    [view setAlpha:0];
    [acoreTextView.superview addSubview:view];
    [UIView animateWithDuration:0.2 animations:^{
        [view setAlpha:0.4];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            [view setAlpha:0];
        }];
    }];
    
    NSURL *url = [data objectForKey:FTCoreTextDataURL];
    if (!url) return;
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - View Controller Methods

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
	//add coretextview
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    coreTextView = [[FTCoreTextView alloc] initWithFrame:CGRectMake(20, 20, 280, 0)];
	coreTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // set text
    [coreTextView setText:[self textForView]];
    // set styles
    [coreTextView addStyles:[self coreTextStyle]];
    // set delegate
    [coreTextView setDelegate:self];
	[coreTextView fitToSuggestedHeight];
    
    scrollView.directionalLockEnabled = YES;
    scrollView.decelerationRate = 0;
    [scrollView addSubview:coreTextView];
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.bounds), CGRectGetHeight(coreTextView.frame) + 40)];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    
    /*
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 30)];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"backnromal.png"] forState:UIControlStateNormal];
    [backButton setAlpha:0.7];
    [self.view addSubview:backButton];
    */
    
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizer];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.bounds), CGRectGetHeight(coreTextView.frame) + 40)];
}

- (void)dealloc
{
	[coreTextView release];
	[scrollView release];
	[super dealloc];
}

@end
