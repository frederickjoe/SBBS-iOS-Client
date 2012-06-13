//
//  TopTenViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableView.h"
#import "TimeScroller.h"
#import "QuadCurveMenu.h"
#import "TopTenTableViewCell.h"
#import "SingleTopicViewController.h"

#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
@interface TopicsViewController : UIViewController<TimeScrollerDelegate, MBProgressHUDDelegate, QuadCurveMenuDelegate>
{
    NSString * boardName;
    
    NSMutableArray * topTenArray;
    CustomTableView * customTableView;
    TimeScroller *_timeScroller;
    MBProgressHUD * HUD;
    QuadCurveMenu *menu;
    IBOutlet UILabel * topTitle;
    
    MyBBS * myBBS;
}
@property(nonatomic, retain)NSString * boardName;
@property(nonatomic, retain)NSArray * topTenArray;
@property(nonatomic, assign)CustomTableView * customTableView;

-(IBAction)back:(id)sender;
@end
