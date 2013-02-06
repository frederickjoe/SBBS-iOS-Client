//
//  UserInfoViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "UserInfoViewController.h"

@implementation UserInfoViewController
@synthesize userString;
@synthesize user;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)refreshView
{
    [ID setText:[NSString stringWithFormat:@"%@", user.ID]];
    [name setText:[NSString stringWithFormat:@"%@", user.name]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString * lastloginstring = [dateFormatter stringFromDate:user.lastlogin];
    [dateFormatter release];
    [lastlogin setText:[NSString stringWithFormat:@"%@",lastloginstring]];
    
    [level setText:[NSString stringWithFormat:@"%@", user.level]];
    
    [posts setText:[NSString stringWithFormat:@"%i", user.posts]];
    [perform setText:[NSString stringWithFormat:@"%i", user.perform]];
    [experience setText:[NSString stringWithFormat:@"%i", user.experience]];
    [medals setText:[NSString stringWithFormat:@"%i", user.medals]];
    [logins setText:[NSString stringWithFormat:@"%i", user.logins]];
    [life setText:[NSString stringWithFormat:@"%i", user.life]];
    
    if (user.gender != NULL) {
        if([user.gender isEqualToString:@"M"])
            [gender setText:[NSString stringWithFormat:@"%@", @"帅哥"]];
        else
            [gender setText:[NSString stringWithFormat:@"%@", @"美女"]];
        
        [astro setText:[NSString stringWithFormat:@"%@", user.astro]];
    }
    else {
        [gender setText:@"保密"];
        [astro setText:@"保密"];
    }

}


-(void)firstTimeLoad
{
    if (myBBS.mySelf.ID != nil && [myBBS.mySelf.ID isEqualToString:userString]) {
        [sentMailButton setHidden:YES];
        [addFriendButton setHidden:YES];
    }
    
    if ([BBSAPI isFriend:myBBS.mySelf.token ID:userString])
        [addFriendButton setHidden:YES];
    if (myBBS.mySelf.ID == nil) {
        [addFriendButton setHidden:YES];
        [sentMailButton setHidden:YES];
    }
    
    self.user = [BBSAPI userInfo:userString];
    [HUD removeFromSuperview];
    HUD = nil;
    [self refreshView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    // Do any additional setup after loading the view from its nib.
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view insertSubview:HUD atIndex:26];
	HUD.labelText = @"Loading...";
    [HUD showWhileExecuting:@selector(firstTimeLoad) onTarget:self withObject:nil animated:YES];
    [HUD release];
}
-(void)dealloc
{
    [super dealloc];
    [user release];
    user = nil;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)addFriend:(id)sender
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    [HUD release];
	HUD.labelText = @"加好友中...";
    [HUD show:YES];
    BOOL success = [BBSAPI addFriend:myBBS.mySelf.token ID:user.ID];
    if (success) {
        [HUD removeFromSuperview];
        [addFriendButton setHidden:YES];
    }
    else {
        
    }
    [HUD removeFromSuperview];
    HUD = nil;
}



-(IBAction)sendMail:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PostMailViewController * postMailViewController = [[PostMailViewController alloc] initWithNibName:@"PostMailViewController" bundle:nil];
    postMailViewController.postType = 2;
    postMailViewController.sentToUser = user.ID;
    postMailViewController.mDelegate = self;
    [appDelegate.homeViewController presentModalViewController:postMailViewController animated:YES];
    [postMailViewController release];
}

-(void)dismissPostMailView
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.homeViewController dismissModalViewControllerAnimated:YES];
}

@end
