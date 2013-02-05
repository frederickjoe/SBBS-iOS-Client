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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    // Do any additional setup after loading the view from its nib.
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
    return [cell autorelease];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * curAttUrlString=[[attList objectAtIndex:indexPath.row] attUrl];
    NSURL * url=[NSURL URLWithString:curAttUrlString];
    
    if ([curAttUrlString hasSuffix:@".png"] || [curAttUrlString hasSuffix:@".jpg"] || [curAttUrlString hasSuffix:@".gif"] || [curAttUrlString hasSuffix:@".PNG"] || [curAttUrlString hasSuffix:@".JPG"] || [curAttUrlString hasSuffix:@".GIF"]) {
        
//        AttImageViewController * attImageViewController = [[AttImageViewController alloc] initWithNibName:@"AttImageViewController" bundle:nil];
//        attImageViewController.url=url;
//        attImageViewController.fileName=[[attList objectAtIndex:indexPath.row] attFileName];
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        HomeViewController * home = appDelegate.homeViewController;
//        [home.navigationController pushViewController:attImageViewController animated:YES];
//        [attImageViewController release];
        
        
        
//        AttImageWebViewController *aiwvc=[[AttImageWebViewController alloc] initWithNibName:@"AttImageWebViewController" bundle:nil];
//        aiwvc.imgUrl=url;
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        HomeViewController * home = appDelegate.homeViewController;
//        [home.navigationController pushViewController:aiwvc animated:YES];
//        [aiwvc release];
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
