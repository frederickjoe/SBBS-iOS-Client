//
//  PostTopicViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "PostMailViewController.h"

@implementation PostMailViewController
@synthesize rootMail;
@synthesize sentToUser;
@synthesize postType;
@synthesize mDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    UIApplication *myApp = [UIApplication sharedApplication];
    [myApp setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [postBack setFrame:CGRectMake(postBack.frame.origin.x, postBack.frame.origin.y, postBack.frame.size.width, rect.size.height - 376)];
    [postContent setFrame:CGRectMake(postContent.frame.origin.x, postContent.frame.origin.y, postContent.frame.size.width, rect.size.height - 400)];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    if (postType == 0) {
        [topTitleLabel setText:@"发新邮件"];
        [postUser setText:@""];
        [postUser becomeFirstResponder];
        [sendButton setEnabled:NO];
        [postTitle setText:@""];
        [postContent setText:@""];
        [postTitleCount setText:[NSString stringWithFormat:@"%i", [postTitle.text length]]];
        [sendButton setEnabled:NO];
        
    }
    if (postType == 1) {
        [topTitleLabel setText:@"回复邮件"];
        [postUser setText:rootMail.author];
        [postUser setEnabled:NO];
        [addUserButton setHidden:YES];
        
        if ([rootMail.title length] >=4 && [[rootMail.title substringToIndex:4] isEqualToString:@"Re: "]) {
            [postTitle setText:[NSString stringWithFormat:@"%@", rootMail.title]];
        }
        else
        {
            [postTitle setText:[NSString stringWithFormat:@"Re: %@", rootMail.title]];
        }

        [postContent setText:@""];
        [postContent becomeFirstResponder];
        [postTitleCount setText:[NSString stringWithFormat:@"%i", [postTitle.text length]]];
    }
    if (postType == 2) {
        [topTitleLabel setText:@"发新邮件"];
        [postUser setText:sentToUser];
        [postUser setEnabled:NO];
        [addUserButton setHidden:YES];
        [postUser becomeFirstResponder];
        [postTitle setText:@""];
        [postContent setText:@""];
        [postTitle becomeFirstResponder];
        [postTitleCount setText:[NSString stringWithFormat:@"%i", [postTitle.text length]]];
        [sendButton setEnabled:NO];
    }

    // Do any additional setup after loading the view from its nib.
}
-(IBAction)inputText:(id)sender
{
    [postTitleCount setText:[NSString stringWithFormat:@"%i",[postTitle.text length]]];
    int count = [postUser.text length];
    if (count == 0) {
        [sendButton setEnabled:NO];
    }
    else {
        [sendButton setEnabled:YES];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(IBAction)cancel:(id)sender
{
    UIApplication *myApp = [UIApplication sharedApplication];
    [myApp setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [mDelegate dismissPostMailView];
}


-(IBAction)sent:(id)sender
{
    [postUser resignFirstResponder];
    [postTitle resignFirstResponder];
    [postContent resignFirstResponder];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.labelText = @"发送中...";
	[HUD showWhileExecuting:@selector(firstTimeLoad) onTarget:self withObject:nil animated:YES];
}


-(void)firstTimeLoad
{
    [HUD removeFromSuperview];
    if([self didPost])
    {
        UIApplication *myApp = [UIApplication sharedApplication];
        [myApp setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [mDelegate dismissPostMailView];
        
        //[self performSelectorOnMainThread:@selector(sendSuccess) withObject:nil waitUntilDone:NO];
    }
    else {
        [self performSelectorOnMainThread:@selector(sendFailed) withObject:nil waitUntilDone:NO];
    }
}

-(void)sendSuccess
{
    FDStatusBarNotifierView *notifierView = [[FDStatusBarNotifierView alloc] initWithMessage:@"√  发表成功" delegate:self];
    [notifierView showInWindow:self.view.window];
}
-(void)sendFailed
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"发送失败";
    hud.margin = 30.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.8];
}

-(BOOL)didPost
{
    if (postType == 0) {
        return [BBSAPI postMail:myBBS.mySelf.token User:postUser.text Title:postTitle.text Content:postContent.text Reid:0];
    }
    if (postType == 1) {
        return [BBSAPI postMail:myBBS.mySelf.token User:postUser.text Title:postTitle.text Content:postContent.text Reid:rootMail.ID];
    }
    if (postType == 2) {
        return [BBSAPI postMail:myBBS.mySelf.token User:postUser.text Title:postTitle.text Content:postContent.text Reid:0];
    }
    return 0;
}


-(IBAction)addUser:(id)sender
{
    AddPostUserViewController * addPostUserViewController = [[AddPostUserViewController alloc] initWithNibName:@"AddPostUserViewController" bundle:nil];
    addPostUserViewController.mDelegate = self;
    [self presentModalViewController:addPostUserViewController animated:YES];
}
-(void)didAddUser:(NSString *)userID
{
    [postUser setText:userID];
    [postTitle becomeFirstResponder];
}

-(void)dismissAddUserView
{
    [self dismissModalViewControllerAnimated:YES];
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


// **Optional** StatusBarNotifierViewDelegate methods

- (void)willPresentNotifierView:(FDStatusBarNotifierView *)notifierView {
    NSLog(@"willPresentNotifierView");
}

- (void)didPresentNotifierView:(FDStatusBarNotifierView *)notifierView {
    NSLog(@"didPresentNotifierView");
}

- (void)willHideNotifierView:(FDStatusBarNotifierView *)notifierView {
    NSLog(@"willHideNotifierView");
}

- (void)didHideNotifierView:(FDStatusBarNotifierView *)notifierView {
    NSLog(@"didHideNotifierView");
}

- (void)notifierViewTapped:(FDStatusBarNotifierView *)notifierView {
    NSLog(@"notifierViewTapped");
}

@end
