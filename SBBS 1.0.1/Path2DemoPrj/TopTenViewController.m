//
//  TopTenViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "TopTenViewController.h"

@implementation TopTenViewController
@synthesize topTenArray;
@synthesize customTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)firstTimeLoad
{
    self.topTenArray = [BBSAPI topTen];
    customTableView = [[CustomNoFooterTableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44) Delegate:self];
    [self.view addSubview:customTableView];
    _timeScroller = [[TimeScroller alloc] initWithDelegate:self];
    [customTableView reloadData];
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view insertSubview:HUD atIndex:0];
	HUD.labelText = @"Loading...";
	[HUD showWhileExecuting:@selector(firstTimeLoad) onTarget:self withObject:nil animated:YES];
    [HUD release];
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
    [topTenArray release];
    topTenArray = nil;
    [customTableView release];
    customTableView = nil;
    [_timeScroller release];
    _timeScroller = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UIScrollViewDelegateMethods
//The TimeScroller needs to know what's happening with the UITableView (UIScrollView)
- (void)scrollViewDidScroll{
    [_timeScroller scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating{
    [_timeScroller scrollViewDidEndDecelerating];
}

- (void)scrollViewWillBeginDragging{
    [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(BOOL)decelerate{
    if (!decelerate) {
        [_timeScroller scrollViewDidEndDecelerating];
    }
}
//You should return an NSDate related to the UITableViewCell given. This will be
//the date displayed when the TimeScroller is above that cell.
- (UITableView *)tableViewForTimeScroller:(TimeScroller *)timeScroller {
    return customTableView.mTableView;
}
- (NSDate *)dateForCell:(UITableViewCell *)cell {
    TopTenTableViewCell * topTenCell = (TopTenTableViewCell *)cell;
    return topTenCell.time;
}



#pragma mark - 
#pragma mark tableViewDelegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [topTenArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identi = @"TopTenTableViewCell";
    TopTenTableViewCell * cell = (TopTenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TopTenTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
        
    Topic * topic = [topTenArray objectAtIndex:indexPath.row];
    cell.ID = topic.ID;
    cell.title = topic.title;
    cell.time = topic.time;
    cell.author = topic.author;
    cell.replies = topic.replies;
    cell.read = topic.read;
    cell.board = topic.board;
    [cell setReadyToShow];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 80;
}

-(void)clearCellBack:(UITableViewCell *)cell
{
    cell.backgroundColor = [UIColor clearColor];
}
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell * cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightTextColor];
    [self performSelector:@selector(clearCellBack:) withObject:cell afterDelay:0.5];
    
    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithNibName:@"SingleTopicViewController" bundle:nil];
    singleTopicViewController.rootTopic = [topTenArray objectAtIndex:indexPath.row];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HomeViewController * home = appDelegate.homeViewController;
    [home.navigationController pushViewController:singleTopicViewController animated:YES];
    [singleTopicViewController release];
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.topTenArray = [BBSAPI topTen];
    [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    [pool release];
}
-(void)refreshTableView
{
    [customTableView reloadData];
}

- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    [NSThread detachNewThreadSelector:@selector(refreshTable) toTarget:self withObject:nil];
}


@end
