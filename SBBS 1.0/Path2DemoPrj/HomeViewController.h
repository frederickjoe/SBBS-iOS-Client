//
//  AboutViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TimeScroller.h"
#import "TopTenViewController.h"
#import "SingleTopicViewController.h"

@interface HomeViewController : UIViewController{
    IBOutlet UILabel * topTitle;
    CGPoint touchBeganPoint;
    UIViewController * realViewController;
    
    BOOL homeViewIsOutOfStage;
}
@property(nonatomic, retain)UIViewController * realViewController;
- (IBAction)leftBarBtnTapped:(id)sender;
- (void)removeOldViewController;
- (void)showViewController:(NSString *)topTitle;
- (void)firstrestoreViewLocation;
- (void)restoreViewLocation;
- (void)moveToRightSide;
- (void)moveToRightSideTotaly;
@end
