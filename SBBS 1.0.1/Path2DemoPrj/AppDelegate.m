//
//  AppDelegate.m
//  Path2DemoPrj
//
//  Created by Ethan on 11-12-14.
//  Copyright (c) 2011年 Ethan. All rights reserved.
//  
//  个人承接iOS项目, QQ:44633450 / email: gaoyijun@gmail.com
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;
@synthesize leftnavController = _leftnavController;

@synthesize leftViewController;
@synthesize homeViewController;


@synthesize myBBS;
@synthesize isSearching;


- (void)dealloc {
    [_window release];
    [_navController release];
    [_leftnavController release];
    [leftViewController release];
    [homeViewController release];
    [myBBS release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.myBBS = [[[MyBBS alloc] init] autorelease];
    
    // left view (nav)
    [self.leftnavController.navigationBar setHidden:YES];
    [self.leftnavController.view setFrame:CGRectMake(0, 20, 320, 460)];
    [self.window addSubview:self.leftnavController.view];
    
    // main view (nav)
    self.navController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navController.view.layer.shadowOpacity = 0.4f;
    self.navController.view.layer.shadowOffset = CGSizeMake(-12.0, 1.0f);
    self.navController.view.layer.shadowRadius = 5.0f;
    self.navController.view.layer.masksToBounds = NO;
    [self.navController.view layer].shadowPath = [UIBezierPath bezierPathWithRect:[self.navController.view layer].bounds].CGPath;
    [self.navController.navigationBar setHidden:YES];
    [self.window addSubview:self.navController.view];
    [self.window makeKeyAndVisible];
    
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(refreshNotification) userInfo:nil repeats:YES];
    
    zakerLikeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
    [zakerLikeImageView setImage:[UIImage imageNamed:@"launch.png"]];
    zakerLikeImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    zakerLikeImageView.layer.shadowOpacity = 1.0f;
    zakerLikeImageView.layer.shadowOffset = CGSizeMake(0.0, 5.0f);
    zakerLikeImageView.layer.shadowRadius = 5.0f;
    zakerLikeImageView.layer.masksToBounds = NO;
    [zakerLikeImageView layer].shadowPath = [UIBezierPath bezierPathWithRect:[zakerLikeImageView layer].bounds].CGPath;
    [zakerLikeImageView setUserInteractionEnabled:NO];
    [self performSelector:@selector(TheAnimation) withObject:nil afterDelay:1];//3秒后执行TheAnimation
    [self.window addSubview:zakerLikeImageView];
    
    return YES;
}

- (void)showLeftViewTotaly{
    [self.homeViewController moveToRightSideTotaly];
}
- (void)showLeftView{
    [self.homeViewController moveToRightSide];
}
-(void)showHomeView{
    [self.homeViewController restoreViewLocation];
}


-(void)refreshTable
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self.myBBS refreshNotification];
    [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    [pool release];
}
-(void)refreshTableView
{
    [self.leftViewController.mainTableView reloadData];
}

-(void)TheAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5];
    [zakerLikeImageView setFrame:CGRectMake(0, -480, 320, 480)];
    [UIView commitAnimations];
}
- (void)refreshNotification
{
    [NSThread detachNewThreadSelector:@selector(refreshTable) toTarget:self withObject:nil];
}

-(void)applicationWillResignActive:(UIApplication *)application {
/*
 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
 */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.myBBS.notificationCount];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


@end
