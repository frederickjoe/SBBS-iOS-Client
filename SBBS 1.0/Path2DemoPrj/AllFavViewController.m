//
//  BoardsViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/1/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "AllFavViewController.h"

@implementation AllFavViewController
@synthesize topTenArray;
@synthesize topTitleString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)firstTimeLoad
{
    self.topTenArray = [BBSAPI allFavSections:myBBS.mySelf.token];
    customTableView = [[CustomNoFooterTableView alloc] initWithFrame:CGRectMake(0, 44, 290, self.view.frame.size.height-44) Delegate:self];
    [self.view addSubview:customTableView];
    [customTableView reloadData];
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    [topTitle setText:topTitleString];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;

    if (topTenArray == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view insertSubview:HUD atIndex:0];
        HUD.labelText = @"Loading...";
        [HUD showWhileExecuting:@selector(firstTimeLoad) onTarget:self withObject:nil animated:YES];
        [HUD release];
    }
    else {
        normalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 290, self.view.frame.size.height-44)];
        normalTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
        normalTableView.dataSource = self;
        normalTableView.delegate = self;
        [self.view addSubview:normalTableView];
        [normalTableView reloadData];
    }
}
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [customTableView release];
    [topTitleString release];
    [normalTableView release];
    
    topTenArray = nil;
    customTableView = nil;
    topTitleString = nil;
    normalTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark UIScrollViewDelegateMethods
//The TimeScroller needs to know what's happening with the UITableView (UIScrollView)
- (void)scrollViewDidScroll{
    // [_timeScroller scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating{
    // [_timeScroller scrollViewDidEndDecelerating];
}

- (void)scrollViewWillBeginDragging{
    //  [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(BOOL)decelerate{
    
}
//You should return an NSDate related to the UITableViewCell given. This will be
//the date displayed when the TimeScroller is above that cell.
- (UITableView *)tableViewForTimeScroller:(TimeScroller *)timeScroller {
    return nil;
}
- (NSDate *)dateForCell:(UITableViewCell *)cell {
    return nil;
}






#pragma mark - UITableView delegate
//指定有多少个分区(Section)，默认为1
/*
 -(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
 {
 return 1;
 }
 */
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [topTenArray count];
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
    
    Board * board = [topTenArray objectAtIndex:indexPath.row];
    
    if (board.leaf) {
        TopicsViewController * topicsViewController = [[TopicsViewController alloc] initWithNibName:@"TopicsViewController" bundle:nil];
        Board * b = [topTenArray objectAtIndex:indexPath.row];
        topicsViewController.boardName = b.name;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home restoreViewLocation];
        [home removeOldViewController];
        home.realViewController = topicsViewController;
        [home showViewController:b.description];
        [topicsViewController release];
    }
    else {
        AllFavViewController * allSectionsViewController = [[AllFavViewController alloc] initWithNibName:@"AllFavViewController" bundle:nil];
        allSectionsViewController.topTenArray= board.sectionBoards;
        allSectionsViewController.topTitleString = board.description;
        [self.navigationController pushViewController:allSectionsViewController animated:YES];
        [allSectionsViewController release];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoardsCellView * cell = (BoardsCellView *)[tableView dequeueReusableCellWithIdentifier:@"BoardsCellView"];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"BoardsCellView" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    Board * b = [topTenArray objectAtIndex:indexPath.row];
    cell.name = b.name;
    cell.description = b.description;
    cell.section = b.section;
    cell.leaf = b.leaf;
    [cell setReadyToShow];
    
    if (!b.leaf) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
	return cell;
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.topTenArray = [BBSAPI allFavSections:myBBS.mySelf.token];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 44;
}



@end
