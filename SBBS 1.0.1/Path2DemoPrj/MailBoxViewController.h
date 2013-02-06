//
//  MailBoxViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/4/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "CustomTableView.h"
#import "TimeScroller.h"
#import "QuadCurveMenu.h"
#import "BoardsCellView.h"
#import "MailsViewController.h"
#import "FriendCellView.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "MyBBS.h"
#import "PostMailViewController.h"

@interface MailBoxViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *tableTitles;
    NSArray * imageNameArray;
    IBOutlet UITableView * mainTableView;
}

-(IBAction)back:(id)sender;
-(IBAction)newMail:(id)sender;

-(void)dismissPostMailView;
@end
