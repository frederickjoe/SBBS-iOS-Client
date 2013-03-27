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
#import "PushNotificationWindow.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;
@synthesize leftnavController = _leftnavController;

@synthesize leftViewController;
@synthesize homeViewController;


@synthesize myBBS;
@synthesize isSearching;

@synthesize notificationWindow;
@synthesize selectedUserInfo;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.myBBS = [[MyBBS alloc] init];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    // left view (nav)
    //[self.leftnavController.navigationBar setHidden:YES];
    self.leftViewController.title = @"虎踞龙蟠";
    [self.leftnavController.view setFrame:CGRectMake(0, 20, 320, rect.size.height - 20)];
    /*
    self.leftViewController.view.layer.cornerRadius = 6.0f;
    self.leftViewController.view.clipsToBounds = YES;
     */
    //[self.window addSubview:self.leftnavController.view];
    
    // main view (nav)
    self.navController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navController.view.layer.shadowOpacity = 1.0f;
    self.navController.view.layer.shadowOffset = CGSizeMake(-4.0, 1.0f);
    self.navController.view.layer.shadowRadius = 3.0f;
    
    /*
    self.homeViewController.view.layer.cornerRadius = 6.0f;
    self.homeViewController.view.clipsToBounds = YES;
    */
    self.navController.view.layer.masksToBounds = NO;
    [self.navController.view layer].shadowPath = [UIBezierPath bezierPathWithRect:[self.navController.view layer].bounds].CGPath;
    [self.navController.navigationBar setHidden:YES];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) self.window.rootViewController = self.navController;
    else [self.window addSubview:self.navController.view];
    [self.window insertSubview:self.leftnavController.view atIndex:0];
    
    //[self.window addSubview:self.navController.view];
    [self.window makeKeyAndVisible];
    
    zakerLikeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, rect.size.height)];
    if (rect.size.height == 568)
        [zakerLikeImageView setImage:[UIImage imageNamed:@"Default-568h@2x.png"]];
    else
        [zakerLikeImageView setImage:[UIImage imageNamed:@"Default@2x.png"]];
    
    zakerLikeImageView.layer.shadowColor = [UIColor grayColor].CGColor;
    zakerLikeImageView.layer.shadowOpacity = 0.5f;
    zakerLikeImageView.layer.shadowOffset = CGSizeMake(0.0, 2.0f);
    zakerLikeImageView.layer.shadowRadius = 0.8f;
    zakerLikeImageView.layer.masksToBounds = NO;
    [zakerLikeImageView layer].shadowPath = [UIBezierPath bezierPathWithRect:[zakerLikeImageView layer].bounds].CGPath;
    [zakerLikeImageView setUserInteractionEnabled:NO];
    [self performSelector:@selector(TheAnimation) withObject:nil afterDelay:1];   [self.window addSubview:zakerLikeImageView];
    
    //[self refreshNotification];
    //[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(refreshNotification) userInfo:nil repeats:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tapReceivedNotificationHandler:)
                                                 name:kMPNotificationViewTapReceivedNotification
                                               object:nil];
    
    
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    if (launchOptions) {
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            if ([[[[pushNotificationKey objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"type"] isEqualToString:@"bbsnews"]) {
                NSString * boardID = [[[pushNotificationKey objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"board"];
                NSString * topicID = [[[pushNotificationKey objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"postId"];
                
                if (self.notificationWindow != nil) {
                    [notificationWindow.rootViewController.view removeFromSuperview];
                }
                self.notificationWindow = [[PushNotificationWindow alloc] initWithFrame:rect];
                notificationWindow.isBBSNews = YES;
                notificationWindow.mDelegate = self;
                notificationWindow.boardID = boardID;
                notificationWindow.topicID = topicID;
                [notificationWindow setReadyToShow];
                [self showNotificationWithDelay:1.2];
            }
            if ([[[[pushNotificationKey objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"type"] isEqualToString:@"urlnews"]) {
                NSString * url = [[[pushNotificationKey objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"url"];
                
                if (self.notificationWindow != nil) {
                    [notificationWindow.rootViewController.view removeFromSuperview];
                }
                self.notificationWindow = [[PushNotificationWindow alloc] initWithFrame:rect];
                notificationWindow.isBBSNews = NO;
                notificationWindow.mDelegate = self;
                notificationWindow.newsURL = url;
                [notificationWindow setReadyToShow];
                [self showNotificationWithDelay:1.2];
            }
        }
    }
    
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
    @autoreleasepool {
        /*
        int oldNotificationCount = 0;
        int newNotificationCount = 0;
        
        if (myBBS.notification != nil) {
            oldNotificationCount = myBBS.notification.count;
        }
        */
        
        [self.myBBS refreshNotification];
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
        
        /*
        if (myBBS.notification != nil) {
            newNotificationCount = myBBS.notification.count;
        }
        
        if (newNotificationCount > oldNotificationCount) {
            [MPNotificationView notifyWithText:@"有新消息"
                                        detail:[NSString stringWithFormat:@"共%i条未读消息", newNotificationCount]
                                         image:[UIImage imageNamed:@"icon.png"]
                                   andDuration:3.0];
        }
        */
    }
}
-(void)refreshTableView
{
    [self.leftViewController.mainTableView reloadData];
}

-(void)TheAnimation
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.8];
    [zakerLikeImageView setFrame:CGRectMake(0, -(rect.size.height), 320, rect.size.height-20)];
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

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    [self refreshNotification];
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


#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}
- (BOOL)shouldAutorotate{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - MPNotificationViewDelegate
- (void)didTapOnNotificationView:(MPNotificationView *)notificationView
{
    //[self.homeViewController leftBarBtnTapped:nil];
}

- (void)tapReceivedNotificationHandler:(NSNotification *)notice
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    if (selectedUserInfo) {
        if ([[[[selectedUserInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"type"] isEqualToString:@"bbsnews"]) {
            NSString * boardID = [[[selectedUserInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"board"];
            NSString * topicID = [[[selectedUserInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"postId"];
            
            if (self.notificationWindow != nil) {
                [notificationWindow.rootViewController.view removeFromSuperview];
            }
            self.notificationWindow = [[PushNotificationWindow alloc] initWithFrame:rect];
            notificationWindow.isBBSNews = YES;
            notificationWindow.mDelegate = self;
            notificationWindow.boardID = boardID;
            notificationWindow.topicID = topicID;
            [notificationWindow setReadyToShow];
            [self showNotificationWithDelay:0.2];
        }
        if ([[[[selectedUserInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"type"] isEqualToString:@"urlnews"]) {
            NSString * url = [[[selectedUserInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"url"];
            
            if (self.notificationWindow != nil) {
                [notificationWindow.rootViewController.view removeFromSuperview];
            }
            self.notificationWindow = [[PushNotificationWindow alloc] initWithFrame:rect];
            notificationWindow.isBBSNews = NO;
            notificationWindow.mDelegate = self;
            notificationWindow.newsURL = url;
            [notificationWindow setReadyToShow];
            [self showNotificationWithDelay:0.2];
        }
    }
}

//推送通知处理
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //9955cf26 091830d9 d0212e01 7b78525c 64876ee5 a08f1a73 68ead536 43644ed5
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL isGotDeviceToken = [defaults boolForKey:@"isGotDeviceToken"];
    BOOL isPostDeviceToken = [defaults boolForKey:@"isPostDeviceToken"];
    if (!isGotDeviceToken || !isPostDeviceToken) {
        NSMutableString * rawtoken = [NSMutableString stringWithFormat:@"%@",deviceToken];
        NSString * token = [rawtoken substringWithRange:NSMakeRange(1, 71)];
        NSLog(@"Device token:%@",token);
        NSString *encodedcontent = [token URLEncodedString];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:encodedcontent forKey:@"DeviceToken"];
        [defaults setBool:YES forKey:@"isGotDeviceToken"];
        
        if (myBBS.mySelf != nil) {
            [myBBS addPushNotificationToken];
        }
    }
    else {
        return;
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"失败了");
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState == UIApplicationStateActive) {
        self.selectedUserInfo = userInfo;
        if ([[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"type"] isEqualToString:@"bbsnews"] || [[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"type"] isEqualToString:@"urlnews"]){
            
            CFURLRef		soundFileURLRef;
            SystemSoundID	soundFileObject;
            NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"myNotification"
                                                        withExtension: @"m4a"];
            soundFileURLRef = (__bridge CFURLRef) tapSound;
            AudioServicesCreateSystemSoundID (soundFileURLRef, &soundFileObject);
            AudioServicesPlaySystemSound (soundFileObject);
            AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
            
            [MPNotificationView notifyWithText:@"新推送内容，点击查看"
                                        detail:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"]
                                         image:[UIImage imageNamed:@"icon.png"]
                                   andDuration:3.0];
        }
        else{
            [self refreshNotification];
            
            CFURLRef		soundFileURLRef;
            SystemSoundID	soundFileObject;
            NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"myNotification"
                                                        withExtension: @"m4a"];
            soundFileURLRef = (__bridge CFURLRef) tapSound;
            AudioServicesCreateSystemSoundID (soundFileURLRef, &soundFileObject);
            AudioServicesPlaySystemSound (soundFileObject);
            AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
            
            [MPNotificationView notifyWithText:@"新消息，请到消息中心查看"
                                        detail:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"]
                                         image:[UIImage imageNamed:@"icon.png"]
                                   andDuration:3.0];
        }
        return;
    }
    
    
    //从后台进入
    CGRect rect = [[UIScreen mainScreen] bounds];
    if (userInfo) {
        if ([[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"type"] isEqualToString:@"bbsnews"]) {
            NSString * boardID = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"board"];
            NSString * topicID = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"postId"];
            
            if (self.notificationWindow != nil) {
                [notificationWindow.rootViewController.view removeFromSuperview];
            }
            self.notificationWindow = [[PushNotificationWindow alloc] initWithFrame:rect];
            notificationWindow.isBBSNews = YES;
            notificationWindow.mDelegate = self;
            notificationWindow.boardID = boardID;
            notificationWindow.topicID = topicID;
            [notificationWindow setReadyToShow];
            [self showNotificationWithDelay:0.2];
        }
        if ([[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"type"] isEqualToString:@"urlnews"]) {
            NSString * url = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"url"];
            
            if (self.notificationWindow != nil) {
                [notificationWindow.rootViewController.view removeFromSuperview];
            }
            self.notificationWindow = [[PushNotificationWindow alloc] initWithFrame:rect];
            notificationWindow.isBBSNews = NO;
            notificationWindow.mDelegate = self;
            notificationWindow.newsURL = url;
            [notificationWindow setReadyToShow];
            [self showNotificationWithDelay:0.2];
        }
    }
}

-(void)showNotificationWithDelay:(float)delay
{
    [notificationWindow.rootViewController.view setFrame:CGRectMake(0, 600, 320, notificationWindow.rootViewController.view.frame.size.height)];
    [self.window addSubview:notificationWindow.rootViewController.view];
    [UIView animateWithDuration:0.5f delay:delay options:UIViewAnimationOptionBeginFromCurrentState  animations:^{
        [notificationWindow.rootViewController.view setFrame:CGRectMake(0, 20, 320, notificationWindow.rootViewController.view.frame.size.height)];
    } completion:^(BOOL finished) {
    }];
}
-(void)dismissNotification
{
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState  animations:^{
        [notificationWindow.rootViewController.view setFrame:CGRectMake(0, 600, 320, notificationWindow.rootViewController.view.frame.size.height)];
    } completion:^(BOOL finished) {
        [notificationWindow.rootViewController.view removeFromSuperview];
    }];
}
@end
