//
//  AboutViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "LeftViewController.h"

@implementation LeftViewController
@synthesize mainTableView;

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    self.mainTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    
    searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [searchViewController.view setFrame:CGRectMake(0, 44, 320, 416)];
    [searchViewController.view setAlpha:0];
    [self.view insertSubview:searchViewController.view atIndex:2];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    tableTitles1 = [[NSArray arrayWithObjects:@"今日十大",@"人气版面",@"分类讨论区",nil] retain];
    if(myBBS.mySelf.ID != nil)
        tableTitles2 = [NSArray arrayWithObjects:myBBS.mySelf.ID,@"收藏",@"好友",@"站内信", @"新消息", @"登出",nil];
    else
        tableTitles2 = [NSArray arrayWithObjects:@"登录",nil];
    [tableTitles2 retain];
    tableTitles3 = [[NSArray arrayWithObjects:nil] retain];
    
    search.delegate = self;
    search.keyboardType = UIKeyboardTypeDefault;
    
    UIImage *img = [[UIImage imageNamed: @"navBar.png"]stretchableImageWithLeftCapWidth:0 topCapHeight:22];      
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, search.frame.size.height)];
    [v setImage:img];  
    v.bounds = CGRectMake(0, 0, 320, search.frame.size.height); 
    NSArray *subs = search.subviews;      
    for (int i = 0; i < [subs count]; i++) {          
        id subv = [search.subviews objectAtIndex:i];
        if ([subv isKindOfClass:NSClassFromString(@"UISearchBarBackground")])  
        {                    
            [search insertSubview:v atIndex:i];          
        }      
    }  
    [v release];
    [super viewDidLoad];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [tableTitles1 release];
    tableTitles1 = nil;
    [tableTitles2 release];
    tableTitles2 = nil;
    [tableTitles3 release];
    tableTitles3 = nil;
    [searchViewController release];
    searchViewController = nil;
    search = nil;
    mainTableView = nil;
    myBBS = nil;
    [super dealloc];
}


#pragma mark - UITableView delegate
// Section Titles
//每个section显示的标题

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return @"全站信息";
    if(section == 1)
        return @"用户信息";
    return @"";
}


//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


#pragma mark - UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [tableTitles1 count];
    }
    if (section == 1) {
        return [tableTitles2 count];
    }
    if (section == 2) {
        return [tableTitles3 count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 4)
    {
        NotificationCell * cell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.notification = myBBS.notification;
        [cell refreshCell];
        return cell;
    }
    
    static NSString *CellIdentifier = @"LeftViewTableCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}

    if (indexPath.section == 0) {
        cell.textLabel.text = [tableTitles1 objectAtIndex:indexPath.row];
        if (indexPath.row==1 || indexPath.row == 2) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = [tableTitles2 objectAtIndex:indexPath.row];
        if (myBBS.mySelf.ID == nil) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else {
            if (indexPath.row != 0 && indexPath.row != 5 && indexPath.row != 4) {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            else {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = [tableTitles3 objectAtIndex:indexPath.row];
    }
	return cell;
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
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        TopTenViewController * topicsViewController = [[TopTenViewController alloc] initWithNibName:@"TopTenViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home restoreViewLocation];
        [home removeOldViewController];
        home.realViewController = topicsViewController;
        [home showViewController:@"今日十大"];
        [topicsViewController release];
    }
    if (indexPath.row == 1 && indexPath.section == 0) {
        BoardsViewController * boardsViewController = [[BoardsViewController alloc] initWithNibName:@"BoardsViewController" bundle:nil];
        [self.navigationController pushViewController:boardsViewController animated:YES];
        [boardsViewController release];
    }
    if (indexPath.row == 2 && indexPath.section == 0) {
        AllSectionsViewController * allSectionsViewController = [[AllSectionsViewController alloc] initWithNibName:@"AllSectionsViewController" bundle:nil];
        allSectionsViewController.topTitleString = @"分类讨论区";
        [self.navigationController pushViewController:allSectionsViewController animated:YES];
        [allSectionsViewController release];
    }
    
    if (myBBS.mySelf.ID == nil) {
        if (indexPath.row == 0 && indexPath.section == 1) {
            LoginViewController * loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            loginViewController.mDelegate = self;
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate showLeftViewTotaly];
            [self presentModalViewController:loginViewController animated:YES];
            [loginViewController release];
        }
    }
    if (myBBS.mySelf.ID != nil) {
        if (indexPath.row == 0 && indexPath.section == 1) {
            UserInfoViewController * userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
            userInfoViewController.userString = myBBS.mySelf.ID;
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            HomeViewController * home = appDelegate.homeViewController;
            [home restoreViewLocation];
            [home removeOldViewController];
            home.realViewController = userInfoViewController;
            [home showViewController:@"我的信息"];
            [userInfoViewController release];
        }
        if (indexPath.row == 1 && indexPath.section == 1) {
            AllFavViewController * allFavViewController = [[AllFavViewController alloc] initWithNibName:@"AllFavViewController" bundle:nil];
            allFavViewController.topTitleString = @"收藏";
            [self.navigationController pushViewController:allFavViewController animated:YES];
            [allFavViewController release];
        }
        if (indexPath.row == 2 && indexPath.section == 1) {
            FriendsViewController * friendsViewController = [[FriendsViewController alloc] initWithNibName:@"FriendsViewController" bundle:nil];
            [self.navigationController pushViewController:friendsViewController animated:YES];
            [friendsViewController release];
        }
        if (indexPath.row == 3 && indexPath.section == 1) {
            MailBoxViewController * mailBoxViewController = [[MailBoxViewController alloc] initWithNibName:@"MailBoxViewController" bundle:nil];
            [self.navigationController pushViewController:mailBoxViewController animated:YES];
            [mailBoxViewController release];
        }
        if (indexPath.row == 4 && indexPath.section == 1) {
            NotificationViewController * notificationViewController = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            HomeViewController * home = appDelegate.homeViewController;
            [home restoreViewLocation];
            [home removeOldViewController];
            home.realViewController = notificationViewController;
            [home showViewController:@"新消息"];
            [notificationViewController release];
        }
        if (indexPath.row == 5 && indexPath.section == 1) {
            [self showActionSheet];
        }
    }
    
    if (indexPath.row == 1 && indexPath.section == 2) {
        AboutViewController * aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home restoreViewLocation];
        [home removeOldViewController];
        home.realViewController = aboutViewController;
        [home showViewController:@"关于"];
        [aboutViewController release];
    }
    
}

#pragma mark - UIsearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{    
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegate.isSearching = YES;
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    [searchBar setFrame:CGRectMake(0, 0, 320, searchBar.frame.size.height)];
    [mainTableView setAlpha:0];
    [searchViewController.view setAlpha:0];
    searchBar.showsCancelButton = YES;
	[UIView commitAnimations];
    
    [appdelegate showLeftViewTotaly];

    for(id cc in [searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *sbtn = (UIButton *)cc;
            [sbtn setTitle:@"取消"  forState:UIControlStateNormal];
            [sbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sbtn setTintColor:[UIColor clearColor]];
        }
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)sBar
{ 
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    [searchViewController.view setAlpha:1];
	[UIView commitAnimations];
    
    //点击搜索时的响应事件
    searchViewController.searchString = sBar.text;
    [searchViewController refreshSearching];
    [search resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setText:@""];
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegate.isSearching = NO;
    //点击取消响应事件
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    [searchBar setFrame:CGRectMake(0, 0, 290, searchBar.frame.size.height)];
    searchBar.showsCancelButton = NO;
    [mainTableView setAlpha:1];
	[UIView commitAnimations];
    
    [searchBar resignFirstResponder];
    [appdelegate showLeftView];
}


#pragma mark - LoginViewDelegate
-(void)LoginSuccess
{
    NSArray * new = [NSArray arrayWithObjects:myBBS.mySelf.ID,@"收藏",@"好友",@"站内信", @"新消息",@"登出",nil];
    if (tableTitles2 != new) {
        [tableTitles2 release];
        tableTitles2 = new;
        [tableTitles2 retain];
    }
    [mainTableView reloadData];
}

-(void)dismissAboutView
{
    /*
    MPFoldStyle dismissStyle = MPFoldStyleFlipFoldBit(MPFoldStyleCubic);
    [self dismissViewControllerWithFoldStyle:dismissStyle completion:nil];
     */
}




-(void)showActionSheet
{
    UIActionSheet*actionSheet = [[UIActionSheet alloc] 
                                 initWithTitle:@"确定登出虎踞龙蟠BBS？"
                                 delegate:self
                                 cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:@"登出"
                                 otherButtonTitles:nil, nil];

    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [actionSheet showInView:self.view]; //show from our table view (pops up in the middle of the table)
    [actionSheet release];
}
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [myBBS userLogout];
        NSArray * new = [[NSArray arrayWithObjects:@"登录",nil] retain];
        if (tableTitles2 != new) {
            [tableTitles2 release];
            tableTitles2 = new;
            [tableTitles2 retain];
        }
        ////modified by joe//////
        [new release];
        [mainTableView reloadData];
    }
}

@end
