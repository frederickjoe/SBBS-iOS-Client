//
//  SingleTopicViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "NotificationTopicViewController.h"
#import "PostTopicViewController.h"

@implementation NotificationTopicViewController
@synthesize rootTopic;
@synthesize isForShowNotification;
@synthesize mDelegate;
@synthesize customTableView;
@synthesize selectedCell;

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view insertSubview:HUD atIndex:0];
	HUD.labelText = @"载入中...";
    [HUD showWhileExecuting:@selector(firstTimeLoad) onTarget:self withObject:nil animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    _timeScroller = nil;
}
-(IBAction)back:(id)sender
{
    [mDelegate dismissNotification];
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
        }
        Topic * topic = [topicsArray objectAtIndex:indexPath.row];
        cell.ID = topic.ID;
        cell.time = topic.time;
        cell.author = topic.author;
        cell.title = topic.title;
        cell.content = topic.content;
        cell.content = topic.content;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if ([topic.attachments count] != 0) {
            cell.attExist = YES;
        }
        else{
            cell.attExist = NO;
        }
        
        if ([[self getPicList:topic.attachments] count] == 0) {
            cell.attExistPhoto = NO;
        }
        else
        {
            cell.attExistPhoto = YES;
            cell.attachments = topic.attachments;
        }
        
        [cell setReadyToShow];
        return cell;
    }
    else
    {
        SingleTopicCommentCell * cell = (SingleTopicCommentCell *)[tableView dequeueReusableCellWithIdentifier:@"SingleTopicCommentCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SingleTopicCommentCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        Topic * topic = [topicsArray objectAtIndex:indexPath.row];
        
        cell.ID = topic.ID;
        cell.time = topic.time;
        cell.author = topic.author;
        cell.quote = topic.quote;
        cell.quoter = topic.quoter;
        cell.content = topic.content;
        cell.num = indexPath.row;
        cell.content = topic.content;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if ([topic.attachments count] != 0) {
            cell.attExist = YES;
        }
        else{
            cell.attExist = NO;
        }
        
        if ([[self getPicList:topic.attachments] count] == 0) {
            cell.attExistPhoto = NO;
        }
        else
        {
            cell.attExistPhoto = YES;
            cell.attachments = topic.attachments;
        }

        [cell setReadyToShow];
        return cell;
    }
}

-(NSArray *)getPicList:(NSArray *)attachments
{
    NSMutableArray * picArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [attachments count]; i++) {
        NSString * attUrlString=[[attachments objectAtIndex:i] attUrl];
        if ([attUrlString hasSuffix:@".png"] || [attUrlString hasSuffix:@".jpg"] || [attUrlString hasSuffix:@".jpeg"] || [attUrlString hasSuffix:@".PNG"] || [attUrlString hasSuffix:@".JPG"] || [attUrlString hasSuffix:@".JPEG"])
        {
            [picArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:attUrlString]]];
        }
    }
    return picArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int returnHeight;
    if (indexPath.row == 0)
    {
        Topic * topic = [topicsArray objectAtIndex:0];
        UIFont *font = [UIFont systemFontOfSize:15.0];
        CGSize size2 = [topic.content sizeWithFont:font constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        BOOL ShowAttachments = [defaults boolForKey:@"ShowAttachments"];
        if (ShowAttachments && [[self getPicList:topic.attachments] count] != 0) {
            size2.height = size2.height + 400;
        }
        
        if (indexPath.row == [topicsArray count]-1)
            returnHeight = size2.height+115;
        else
            returnHeight = size2.height+75;
    }
    else {
        Topic * topic = [topicsArray objectAtIndex:indexPath.row];
        
        UIFont *font = [UIFont systemFontOfSize:15.0];
        UIFont *font2 = [UIFont systemFontOfSize:12.0];
        CGSize size1 = [topic.content sizeWithFont:font constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];
        
        CGSize size2 = [[NSString stringWithFormat:@"回复:%@\n%@",topic.quoter, topic.quote] sizeWithFont:font2 constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        BOOL ShowAttachments = [defaults boolForKey:@"ShowAttachments"];
        if (ShowAttachments && [[self getPicList:topic.attachments] count] != 0) {
            size2.height = size2.height + 400;
        }
        
        if (indexPath.row == [topicsArray count]-1)
            returnHeight =  size1.height+size2.height+90;
        else
            returnHeight =   size1.height+size2.height+50;
    }
    
    if (indexPath.row == 0)
        tableHeight = returnHeight;
    else
        tableHeight += returnHeight;
    
    if (indexPath.row == [topicsArray count] - 1 && tableHeight <= tableView.frame.size.height) {
        return tableView.frame.size.height - tableHeight + returnHeight + 10;
    }
    return returnHeight;
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    @autoreleasepool {
        NSArray * topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Start:0 Token:myBBS.mySelf.token];
        [topicsArray removeAllObjects];
        [topicsArray addObjectsFromArray:topics];
        
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    }
}
-(void)loadMoreTable
{
    @autoreleasepool {
        NSArray * topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Start:[topicsArray count] Token:myBBS.mySelf.token];
        [topicsArray addObjectsFromArray:topics];
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    }
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


#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(IBAction)reply:(id)sender
{
    if ([topicsArray count] > 0) {
        PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] initWithNibName:@"PostTopicViewController" bundle:nil];
        postTopicViewController.postType = 1;
        postTopicViewController.rootTopic = [topicsArray objectAtIndex:0];
        [self presentModalViewController:postTopicViewController animated:YES];
    }
}
@end
