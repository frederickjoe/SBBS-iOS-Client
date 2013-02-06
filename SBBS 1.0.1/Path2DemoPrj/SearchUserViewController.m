//
//  BoardsViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/1/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SearchUserViewController.h"
@implementation SearchUserViewController
@synthesize searchString;
@synthesize searchedUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    customTableView = [[CustomNoFooterTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) Delegate:self];
    [self.view addSubview:customTableView];
    [customTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void) dealloc
{
    [super dealloc];
    [searchedUser release];
    searchedUser = nil;
    [searchString release];
    searchString = nil;
    [customTableView release];
    customTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - UITableView delegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchedUser == nil) {
        return 0;
    }
    return 1;
}


// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserInfoViewController * userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    userInfoViewController.userString = self.searchedUser.ID;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HomeViewController * home = appDelegate.homeViewController;
    [home restoreViewLocation];
    [home removeOldViewController];
    home.realViewController = userInfoViewController;
    [home showViewController:@"用户信息"];
    [userInfoViewController release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCellView * cell = (FriendCellView *)[tableView dequeueReusableCellWithIdentifier:@"FriendCellView"];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"FriendCellView" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.user = searchedUser;
    [cell setReadyToShow];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 44;
}

- (void)scrollViewDidScroll{
    
}

- (void)scrollViewDidEndDecelerating{
    
}

- (void)scrollViewWillBeginDragging{
    
}

- (void)scrollViewDidEndDragging:(BOOL)decelerate{
    
}

-(void)firstTimeLoad
{
    self.searchedUser = [BBSAPI userInfo:searchString];
    if (self.searchedUser != nil) {
        [customTableView reloadData];
    }
    [HUD removeFromSuperview];
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    [customTableView setAlpha:1];
	[UIView commitAnimations];
}

-(void)reloadData
{
    [customTableView setAlpha:0];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"Loading...";
    [HUD showWhileExecuting:@selector(firstTimeLoad) onTarget:self withObject:nil animated:YES];
    [HUD release];
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.searchedUser = [BBSAPI userInfo:searchString];
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
