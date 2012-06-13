//
//  MailBoxViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/4/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "MailBoxViewController.h"

@interface MailBoxViewController ()

@end

@implementation MailBoxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        tableTitles = [[NSArray arrayWithObjects:@"收件箱",@"发件箱",@"废件箱",nil] retain];
        imageNameArray = [[NSArray arrayWithObjects:@"inbox.png", @"sentbox.png", @"trashbox.png", nil] retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    mainTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
-(void)dealloc
{
    [super dealloc];
    [tableTitles release];
    tableTitles = nil;
    [imageNameArray release];
    imageNameArray = nil;
    mainTableView = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LeftViewTableCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
    cell.imageView.image = [UIImage imageNamed:[imageNameArray objectAtIndex:indexPath.row]];
    cell.textLabel.text = [tableTitles objectAtIndex:indexPath.row];
    
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
 
    MailsViewController * mailsViewController = [[MailsViewController alloc] initWithNibName:@"MailsViewController" bundle:nil];
    mailsViewController.mailBoxType = indexPath.row;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HomeViewController * home = appDelegate.homeViewController;
    [home restoreViewLocation];
    [home removeOldViewController];
    home.realViewController = mailsViewController;
    [home showViewController:[tableTitles objectAtIndex:indexPath.row]];
    [mailsViewController release];
}
-(IBAction)newMail:(id)sender
{
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelegate showLeftViewTotaly];
    
    PostMailViewController * postMailViewController = [[PostMailViewController alloc] initWithNibName:@"PostMailViewController" bundle:nil];
    postMailViewController.postType = 0;
    postMailViewController.mDelegate = self;
    [self presentModalViewController:postMailViewController animated:YES];
    [postMailViewController release];
}

-(void)dismissPostMailView
{
    [self dismissModalViewControllerAnimated:YES];
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelegate showLeftView];
}
@end
