//
//  TopTenViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "MailsViewController.h"

@implementation MailsViewController
@synthesize mailBoxType;
@synthesize topTenArray;
@synthesize mDelegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        topTenArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)firstTimeLoad
{
    NSArray * topics = [BBSAPI getMails:myBBS.mySelf.token Type:mailBoxType Start:0];
    [topTenArray addObjectsFromArray:topics];
    customTableView = [[CustomTableWithDeleteView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44) Delegate:self];
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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
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
    MailsViewCell * mailCell = (MailsViewCell *)cell;
    return mailCell.mail.time;
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
    MailsViewCell * cell = (MailsViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MailsViewCell"];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"MailsViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    Mail * mail = [topTenArray objectAtIndex:indexPath.row];
    cell.mail = mail;
    [cell setReadyToShow];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 70;
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
    
    
    SingleMailViewController * singleMailViewController = [[SingleMailViewController alloc] initWithNibName:@"SingleMailViewController" bundle:nil];
    singleMailViewController.rootMail = [topTenArray objectAtIndex:indexPath.row];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HomeViewController * home = appDelegate.homeViewController;
    [home.navigationController pushViewController:singleMailViewController animated:YES];
    [singleMailViewController release];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Mail * mail = [topTenArray objectAtIndex:indexPath.row];
    BOOL success = [BBSAPI deleteSingleMail:myBBS.mySelf.token Type:mail.type ID:mail.ID];
    if (success) {
        NSMutableArray * newTopTen = [[NSMutableArray alloc] init];
        for (int i = 0; i < [topTenArray count]; i++) {
            if (i != indexPath.row) {
                [newTopTen addObject:[topTenArray objectAtIndex:i]];
            }
        }
        topTenArray = newTopTen;
        [customTableView.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}



#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSArray * topics = [BBSAPI getMails:myBBS.mySelf.token Type:mailBoxType Start:0];
    [topTenArray removeAllObjects];
    [topTenArray addObjectsFromArray:topics];
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

-(void)loadMoreTable
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSArray * topics = [[BBSAPI getMails:myBBS.mySelf.token Type:mailBoxType Start:[topTenArray count]] retain];
    [topTenArray addObjectsFromArray:topics];
    [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    [pool release];
}

- (void)refreshTableFooterDidTriggerRefresh:(UITableView *)tableView
{
    [NSThread detachNewThreadSelector:@selector(loadMoreTable) toTarget:self withObject:nil];
}


@end
