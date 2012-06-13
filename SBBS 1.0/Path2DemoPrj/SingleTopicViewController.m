//
//  SingleTopicViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SingleTopicViewController.h"

@implementation SingleTopicViewController
@synthesize rootTopic;
@synthesize isForShowNotification;
@synthesize mDelegate;
@synthesize customTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isForShowNotification = NO;
        topicsArray = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)firstTimeLoad
{
    NSArray * topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Start:0 Token:myBBS.mySelf.token];
    [topicsArray addObjectsFromArray:topics];
    customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44) Delegate:self];
    [self.view addSubview:customTableView];
    _timeScroller = [[TimeScroller alloc] initWithDelegate:self];
    [customTableView reloadData];
    [HUD removeFromSuperview];
    [self addQuadCurveMenu];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    [topTitle setText:rootTopic.title];
    // Do any additional setup after loading the view from its nib.
    
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
    [customTableView release];
    customTableView  = nil;
    [_timeScroller release];
    _timeScroller = nil;
    [rootTopic release];
    rootTopic = nil;
}
-(IBAction)back:(id)sender
{
    if (isForShowNotification) {
        [mDelegate backAndRefresh];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    SingleTopicCell * topTenCell = (SingleTopicCell *)cell;
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
    return [topicsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0)
    {
        SingleTopicCell * cell = (SingleTopicCell *)[tableView dequeueReusableCellWithIdentifier:@"SingleTopicCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SingleTopicCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        Topic * topic = [topicsArray objectAtIndex:indexPath.row];
        cell.ID = topic.ID;
        cell.time = topic.time;
        cell.author = topic.author;
        cell.title = topic.title;
        cell.content = topic.content;
        [cell setReadyToShow];
        return cell;
    }
    else
    {
        SingleTopicCommentCell * cell = (SingleTopicCommentCell *)[tableView dequeueReusableCellWithIdentifier:@"SingleTopicCommentCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SingleTopicCommentCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        Topic * topic = [topicsArray objectAtIndex:indexPath.row];
        cell.ID = topic.ID;
        cell.time = topic.time;
        cell.author = topic.author;
        cell.quote = topic.quote;
        cell.quoter = topic.quoter;
        cell.content = topic.content;
        cell.num = indexPath.row;
        [cell setReadyToShow];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{

    if (indexPath.row == 0)
    {
        Topic * topic = [topicsArray objectAtIndex:0];
        UIFont *font = [UIFont systemFontOfSize:15.0];
        CGSize size2 = [topic.content sizeWithFont:font constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];
        return size2.height+75;
    }
    else {
        Topic * topic = [topicsArray objectAtIndex:indexPath.row];
        
        UIFont *font = [UIFont systemFontOfSize:15.0];
        UIFont *font2 = [UIFont systemFontOfSize:12.0];
        CGSize size1 = [topic.content sizeWithFont:font constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];
        
        CGSize size2 = [[NSString stringWithFormat:@"回复:%@\n%@",topic.quoter, topic.quote] sizeWithFont:font2 constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];
        
        return  size1.height+size2.height+50;
    }
    return 0;
}

-(void)clearCellBack:(UITableViewCell *)cell
{
    cell.backgroundColor = [UIColor clearColor];
}
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /*
    CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
    [tableView setContentOffset:CGPointMake(rect.origin.x, rect.origin.y) animated:YES];
     */
    
    UITableViewCell * cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor lightTextColor];
    [self performSelector:@selector(clearCellBack:) withObject:cell afterDelay:0.5];
    selectTopic = [[topicsArray objectAtIndex:indexPath.row] retain];
    [self showActionSheet];
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSArray * topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Start:0 Token:myBBS.mySelf.token];
    [topicsArray removeAllObjects];
    [topicsArray addObjectsFromArray:topics];
    
    [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    [pool release];
}
-(void)loadMoreTable
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSArray * topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Start:[topicsArray count] Token:myBBS.mySelf.token];
    [topicsArray addObjectsFromArray:topics];
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
- (void)refreshTableFooterDidTriggerRefresh:(UITableView *)tableView
{
    [NSThread detachNewThreadSelector:@selector(loadMoreTable) toTarget:self withObject:nil];
}


#pragma mark -
-(void)addQuadCurveMenu
{
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    UIImage *commentImage = [UIImage imageNamed:@"comment.png"];
    UIImage *writenewImage = [UIImage imageNamed:@"writenew.png"];
    UIImage *homeImage = [UIImage imageNamed:@"home.png"];
    UIImage *refreshImage = [UIImage imageNamed:@"refresh.png"];
    
    QuadCurveMenuItem * starMenuItem1 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   ContentImage:commentImage 
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem2 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   ContentImage:writenewImage 
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem3 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   ContentImage:homeImage 
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem4 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   ContentImage:refreshImage 
                                                        highlightedContentImage:nil];

    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, nil];
    [starMenuItem1 release];
    [starMenuItem2 release];
    [starMenuItem3 release];
    [starMenuItem4 release];
    
    menu = [[QuadCurveMenu alloc] initWithFrame:CGRectMake(10, 10, 200, 200) menus:menus];
    menu.delegate = self;
    [self.view addSubview:menu];
    [menu release];
}
- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    if (idx == 0) {
        if (myBBS.mySelf.ID == nil) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请先登录";
            hud.margin = 30.f;
            hud.yOffset = 0.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }
        else{
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] initWithNibName:@"PostTopicViewController" bundle:nil];
            postTopicViewController.postType = 1;
            postTopicViewController.rootTopic = rootTopic;
            postTopicViewController.mDelegate = appDelegate.homeViewController;
            [appDelegate.homeViewController presentModalViewController:postTopicViewController animated:YES];
            [postTopicViewController release];
        }
    }
    if (idx == 1) {
        UserInfoViewController * userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
        userInfoViewController.userString = rootTopic.author;
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home.navigationController pushViewController:userInfoViewController animated:YES];
        [userInfoViewController release];
    }
    if (idx == 2) {
        TopicsViewController * topicsViewController = [[TopicsViewController alloc] initWithNibName:@"TopicsViewController" bundle:nil];
        topicsViewController.boardName = rootTopic.board;
    
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home.navigationController pushViewController:topicsViewController animated:YES];
        [topicsViewController release];
    }
    if (idx == 3) {
        [customTableView.mTableView setContentOffset:CGPointMake(0, 0) animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"回到顶部";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.5];
    }
}


-(void)showActionSheet
{
    NSMutableString * string = [@"" mutableCopy];
    [string appendString:selectTopic.author];
    [string appendString:@"的帖子"];
    if ([myBBS.mySelf.ID isEqualToString:selectTopic.author]) {
        UIActionSheet*actionSheet = [[UIActionSheet alloc] 
                                     initWithTitle:string
                                     delegate:self
                                     cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:@"回复", @"查看我的资料", @"修改文章", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view]; //show from our table view (pops up in the middle of the table)
        [actionSheet release];

    }
    else {
        UIActionSheet*actionSheet = [[UIActionSheet alloc] 
                                 initWithTitle:string
                                 delegate:self
                                 cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:@"回复", @"查看此用户资料", nil];
    
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view]; //show from our table view (pops up in the middle of the table)
        [actionSheet release];
    }
}
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if (myBBS.mySelf.ID == nil) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请先登录";
            hud.margin = 30.f;
            hud.yOffset = 0.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }
        else {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] initWithNibName:@"PostTopicViewController" bundle:nil];
        postTopicViewController.postType = 1;
        postTopicViewController.rootTopic = selectTopic;
        postTopicViewController.mDelegate = appDelegate.homeViewController;
        //[self presentModalViewController:postTopicViewController animated:YES];
        [appDelegate.homeViewController presentModalViewController:postTopicViewController animated:YES];
        }
    }
    if(buttonIndex == 1)
    {
        UserInfoViewController * userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
        userInfoViewController.userString = selectTopic.author;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home.navigationController pushViewController:userInfoViewController animated:YES];
        [userInfoViewController release];
    }
    if(buttonIndex == 2 && [myBBS.mySelf.ID isEqualToString:selectTopic.author])
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] initWithNibName:@"PostTopicViewController" bundle:nil];
        postTopicViewController.postType = 2;
        postTopicViewController.rootTopic = selectTopic;
        postTopicViewController.mDelegate = appDelegate.homeViewController;
        //[self presentModalViewController:postTopicViewController animated:YES];
        [appDelegate.homeViewController presentModalViewController:postTopicViewController animated:YES];
        [postTopicViewController release];
    }
}


-(void)dismissPostTopicView
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
