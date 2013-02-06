//
//  SingleMailViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/6/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SingleMailViewController.h"

@implementation SingleMailViewController
@synthesize rootMail;
@synthesize mail;
@synthesize isForShowNotification;
@synthesize mDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isForShowNotification = NO;
    }
    return self;
}

-(void)firstTimeLoad
{
    self.mail = [BBSAPI getSingleMail:myBBS.mySelf.token Type:rootMail.type ID:rootMail.ID];
    
    if (mail.type == 0)
        [authorLabel setText:[NSString stringWithFormat:@"发件人：%@", mail.author]];
    if (mail.type == 1)
        [authorLabel setText:[NSString stringWithFormat:@"收件人：%@", mail.author]];
    if (mail.type == 2)
        [authorLabel setText:[NSString stringWithFormat:@"发件人：%@", mail.author]];
    [titleLabel setText:mail.title];
    [content setText:mail.content];
    
    [scrollView addSubview:realView];
    
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CGSize size = [mail.content sizeWithFont:font constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];

    [content setFrame:CGRectMake(content.frame.origin.x, content.frame.origin.y, content.frame.size.width, size.height)];
    

    [realView setFrame:CGRectMake(0, 0, 320, content.frame.origin.y + size.height)];
    [scrollView setContentSize:CGSizeMake(320, content.frame.origin.y + size.height+10)];
    if (content.frame.origin.y + size.height+10 <= 480) {
        [scrollView setContentSize:CGSizeMake(320, 490)];
    }
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [realScrollView setFrame:CGRectMake(0, 44, rect.size.width, rect.size.height - 64)];
    scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    if (rootMail.type == 0)
        [topTitle setText:@"收件箱"];
    if (rootMail.type == 1)
        [topTitle setText:@"发件箱"];
    if (rootMail.type == 2)
        [topTitle setText:@"废件箱"];
    
    realView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view insertSubview:HUD atIndex:1];
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
    [rootMail release];
    rootMail = nil;
    [mail release];
    mail = nil;
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


-(IBAction)reply:(id)sender
{
    PostMailViewController * postMailViewController = [[PostMailViewController alloc] initWithNibName:@"PostMailViewController" bundle:nil];
    postMailViewController.postType = 1;
    postMailViewController.rootMail = rootMail;
    postMailViewController.mDelegate = self;
    [self presentModalViewController:postMailViewController animated:YES];
    [postMailViewController release];
}

-(void)dismissPostMailView
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
