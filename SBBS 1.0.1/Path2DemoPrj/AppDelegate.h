//
//
//  AboutViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//
\

#import <UIKit/UIKit.h>
#import "QuadCurveMenu.h"
#import "MyBBS.h"

@class LeftViewController;
@class HomeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    MyBBS * myBBS;
    BOOL isSearching;
    
    UIImageView * zakerLikeImageView;
}

@property (retain, nonatomic) IBOutlet UIWindow *window;
@property (retain, nonatomic) IBOutlet UINavigationController *navController;
@property (retain, nonatomic) IBOutlet UINavigationController *leftnavController;
@property (retain, nonatomic) IBOutlet HomeViewController *homeViewController;
@property (retain, nonatomic) IBOutlet LeftViewController *leftViewController;
@property (retain, nonatomic) MyBBS * myBBS;
@property (nonatomic, assign)BOOL isSearching;

- (void)showLeftViewTotaly;
- (void)showLeftView;
-(void)refreshNotification;
-(void)refreshTableView;
@end
