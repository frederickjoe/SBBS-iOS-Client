//
//  AttachmentsViewController.m
//  虎踞龙蟠
//
//  Created by Huang Feiqiao on 13-1-29.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "AttachmentsViewController.h"


@implementation AttachmentsViewController
@synthesize attList;
@synthesize openString;

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
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    attTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [attList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] init];
    cell.textLabel.text=[[attList objectAtIndex:indexPath.row] attFileName];
    [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * curAttUrlString=[[attList objectAtIndex:indexPath.row] attUrl];

    if ([curAttUrlString hasSuffix:@".png"] || [curAttUrlString hasSuffix:@".jpg"] || [curAttUrlString hasSuffix:@".gif"] || [curAttUrlString hasSuffix:@".PNG"] || [curAttUrlString hasSuffix:@".JPG"] || [curAttUrlString hasSuffix:@".GIF"]) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        ImageData * imageData = [[ImageData alloc] init];
        imageData.url = curAttUrlString;
        imageData.title = [[attList objectAtIndex:indexPath.row] attFileName];
        
        SingleImageWithScrollViewController * singleImageWithScrollViewController = [[SingleImageWithScrollViewController alloc] initWithNibName:@"SingleImageWithScrollViewController" bundle:nil];
        singleImageWithScrollViewController.mDelegate = nil;
        singleImageWithScrollViewController.imageData = imageData;
        
        if ([curAttUrlString hasSuffix:@".gif"] || [curAttUrlString hasSuffix:@".GIF"])
            singleImageWithScrollViewController.isGIF = TRUE;
        [singleImageWithScrollViewController loadBigImageView];
        [appDelegate.homeViewController presentViewController:singleImageWithScrollViewController animated:YES completion:nil];
    }
    else{
        openString = curAttUrlString;
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用Safari打开此附件" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好",nil];
        [alert show];
    }
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{
    return self.view;
}

- (BOOL)documentInteractionController:(UIDocumentInteractionController *)controller canPerformAction:(SEL)action{
    BOOL canPerform = NO;
    if (action == @selector(copy:))
        canPerform = YES;
    return canPerform;
}

- (BOOL)documentInteractionController:(UIDocumentInteractionController *)controller performAction:(SEL)action{
    BOOL handled = NO;
    if (action == @selector(copy:)){
        handled = YES;
    }
    return handled;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller{
    return self.view.frame;
}

- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller{
    //_isShowing = YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft
        || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark -
#pragma mark UIAlertView
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch(buttonIndex){
        case 0:
            break;
        case 1:
        {
            NSURL* url = [[NSURL alloc] initWithString:openString];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
    }
}
@end
