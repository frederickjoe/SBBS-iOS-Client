//
//  PostTopicViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "PostTopicViewController.h"

@implementation PostTopicViewController
@synthesize rootTopic;
@synthesize boardName;
@synthesize postType;
@synthesize mDelegate;
@synthesize attList;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)passValue:(NSArray *)value
{
    attList = value;
    //NSLog(@"the get value is %@", value);
}

-(void)viewWillAppear:(BOOL)animated
{
    UIApplication *myApp = [UIApplication sharedApplication];
    [myApp setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [postBack setFrame:CGRectMake(postBack.frame.origin.x, postBack.frame.origin.y, postBack.frame.size.width, rect.size.height - 347)];
    [postContent setFrame:CGRectMake(postContent.frame.origin.x, postContent.frame.origin.y, postContent.frame.size.width, rect.size.height - 375)];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    if (postType == 0) {
        [topTitleLabel setText:@"发表新帖子"];
        [postTitle setText:@""];
        [postTitle becomeFirstResponder];
        [postContent setText:@""];
        [postTitleCount setText:[NSString stringWithFormat:@"%i", [postTitle.text length]]];
        [sendButton setEnabled:NO];
        ////////设置附件表///////////
        attList=nil;
        ///////////////////////////
    }
    
    
    if (postType == 1) {
        [topTitleLabel setText:@"回帖"];
        if ([rootTopic.title length] >=4 && [[rootTopic.title substringToIndex:4] isEqualToString:@"Re: "]) {
            [postTitle setText:[NSString stringWithFormat:@"%@", rootTopic.title]];
        }
        else
        {
            [postTitle setText:[NSString stringWithFormat:@"Re: %@", rootTopic.title]];
        }
        [postTitleCount setText:[NSString stringWithFormat:@"%i", [postTitle.text length]]];
        [postContent setText:@""];
        [postContent becomeFirstResponder];
        [sendButton setEnabled:YES];
        ////////设置附件表///////////
        attList=nil;
        ///////////////////////////
    }
    if (postType == 2) {
        [topTitleLabel setText:@"修改帖子"];
        [postTitle setText:rootTopic.title];
        [postContent setText:rootTopic.content];
        [postContent becomeFirstResponder];
        [postTitleCount setText:[NSString stringWithFormat:@"%i", [postTitle.text length]]];
        [sendButton setEnabled:YES];
        ////////设置附件表///////////
        attList=[rootTopic.attachments copy];
        ///////////////////////////
    }
    
    keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
    keyboardToolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *spaceBarItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@" 附件 ", @"")
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(operateAtt:)];
    
    UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"  @  ", @"")
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(addUser:)];
    
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    [keyboardToolbar setItems:[NSArray arrayWithObjects:spaceBarItem, previousBarItem, nextBarItem, spaceBarItem1, nil]];
    
    postTitle.inputAccessoryView = keyboardToolbar;
    postContent.inputAccessoryView = keyboardToolbar;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(IBAction)cancel:(id)sender
{
    UIApplication *myApp = [UIApplication sharedApplication];
    [myApp setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)sent:(id)sender
{
    [postTitle resignFirstResponder];
    [postContent resignFirstResponder];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view insertSubview:HUD atIndex:5];
	HUD.labelText = @"发送中...";
	[HUD showWhileExecuting:@selector(firstTimeLoad) onTarget:self withObject:nil animated:YES];
}

-(IBAction)addUser:(id)sender
{
    AddPostUserViewController * addPostUserViewController = [[AddPostUserViewController alloc] initWithNibName:@"AddPostUserViewController" bundle:nil];
    addPostUserViewController.mDelegate = self;
    [self presentModalViewController:addPostUserViewController animated:YES];
}
-(void)didAddUser:(NSString *)userID
{
    NSMutableString * string = [postContent.text mutableCopy];
    [string appendString:@"@"];
    [string appendString:userID];
    [string appendString:@" "];
    [postContent setText:string];
    [postContent becomeFirstResponder];
}
-(void)dismissAddUserView
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)firstTimeLoad
{
    [HUD removeFromSuperview];
    if([self post])
    {
        UIApplication *myApp = [UIApplication sharedApplication];
        [myApp setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [self dismissModalViewControllerAnimated:YES];
        
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

-(BOOL)post
{
    if (postType == 0) {
        return [BBSAPI postTopic:myBBS.mySelf.token Board:boardName Title:postTitle.text Content:postContent.text Reid:0];
    }
    if (postType == 1) {
        return [BBSAPI postTopic:myBBS.mySelf.token Board:rootTopic.board Title:postTitle.text Content:postContent.text Reid:rootTopic.ID];
    }
    if (postType == 2) {
        return [BBSAPI editTopic:myBBS.mySelf.token Board:rootTopic.board Title:postTitle.text Content:postContent.text Reid:rootTopic.ID];
    }
    return 0;
}


#pragma mark -
#pragma mark textViewDelegate
-(IBAction)inputText:(id)sender
{
    int count = [postTitle.text length];
    [postTitleCount setText:[NSString stringWithFormat:@"%i",count]];
    if (count == 0) {
        [sendButton setEnabled:NO];
    }
    else {
        [sendButton setEnabled:YES];
    }
}

-(IBAction)operateAtt:(id)sender
{
    if (postType==0) {
        UploadAttachmentsViewController * uavc = [[UploadAttachmentsViewController alloc] initWithNibName:@"UploadAttachmentsViewController" bundle:nil];
        uavc.postType=0;//新帖
        //uavc.attList=attList;
        uavc.mDelegate = self;
        [self presentViewController:uavc animated:YES completion:nil];
    }
    
    else if(postType==2)
    {
        UploadAttachmentsViewController * uavc = [[UploadAttachmentsViewController alloc] initWithNibName:@"UploadAttachmentsViewController" bundle:nil];
        uavc.postType=2;//修改贴
        //uavc.attList=attList;
        uavc.mDelegate=self;
        uavc.postId=rootTopic.ID;
        uavc.board=rootTopic.board;
        [self presentViewController:uavc animated:YES completion:nil];
    }
    
    else
    {
        UploadAttachmentsViewController * uavc = [[UploadAttachmentsViewController alloc] initWithNibName:@"UploadAttachmentsViewController" bundle:nil];
        uavc.postType=1;//回复
        //uavc.attList=attList;
        uavc.mDelegate = self;
        uavc.postId=rootTopic.ID;
        uavc.board=rootTopic.board;
        [self presentViewController:uavc animated:YES completion:nil];
    }
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
