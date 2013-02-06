//
//  TopTenViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNoFooterTableView.h"
#import "TimeScroller.h"
#import "QuadCurveMenu.h"
#import "TopTenTableViewCell.h"
#import "SingleTopicViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
@interface TopTenViewController : UIViewController<TimeScrollerDelegate, MBProgressHUDDelegate>
{
    NSArray * topTenArray;
    CustomNoFooterTableView * customTableView;
    TimeScroller *_timeScroller;
    MBProgressHUD * HUD;
}
@property(nonatomic, retain)NSArray * topTenArray;
@property(nonatomic, assign)CustomNoFooterTableView * customTableView;

@end
