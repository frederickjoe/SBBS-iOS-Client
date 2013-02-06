//
//  SearchViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/4/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SearchViewController.h"

@implementation SearchViewController
@synthesize searchString;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        searchBoardViewController = [[SearchBoardViewController alloc] initWithNibName:@"SearchBoardViewController" bundle:nil];
        searchTopicViewController = [[SearchTopicViewController alloc] initWithNibName:@"SearchTopicViewController" bundle:nil];
        searchUserViewController = [[SearchUserViewController alloc] initWithNibName:@"SearchUserViewController" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 290, self.view.frame.size.height)];
    [searchBoardViewController.view setFrame:CGRectMake(0, 44, 320, 372)];
    [searchTopicViewController.view setFrame:CGRectMake(0, 44, 320, 372)];
    [searchUserViewController.view setFrame:CGRectMake(0, 44, 320, 372)];
    
    [self.view addSubview:searchBoardViewController.view];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [super dealloc];
    [searchBoardViewController release];
    searchBoardViewController = nil;
    
    [searchTopicViewController release];
    searchTopicViewController = nil;
    
    [searchUserViewController release];
    searchUserViewController = nil;
    
    [searchString release];
    searchString = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)refreshSearching
{
    searchBoardViewController.searchString = searchString;
    searchTopicViewController.searchString = searchString;
    searchUserViewController.searchString = searchString;
    [searchBoardViewController reloadData];
    [searchTopicViewController reloadData];
    [searchUserViewController reloadData];
}

-(IBAction)segmentControlValueChanged:(id)sender
{
    UISegmentedControl *myUISegmentedControl=(UISegmentedControl *)sender;
    switch (myUISegmentedControl.selectedSegmentIndex) {
        case 0:
            [searchTopicViewController.view removeFromSuperview];
            [searchUserViewController.view removeFromSuperview];
            [self.view addSubview:searchBoardViewController.view];
            break;
        case 1:
            [searchBoardViewController.view removeFromSuperview];
            [searchUserViewController.view removeFromSuperview];
            [self.view addSubview:searchTopicViewController.view];
            break;
        case 2:
            [searchTopicViewController.view removeFromSuperview];
            [searchBoardViewController.view removeFromSuperview];
            [self.view addSubview:searchUserViewController.view];
            break;
        default:
            break;
    }
}

@end
