//
//  AttImageViewController.h
//  虎踞龙蟠
//
//  Created by Huang Feiqiao on 13-2-1.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSAPI.h"
@interface AttImageViewController : UIViewController
{
    NSString * fileName;
    NSURL * url;
    UIImage * attImg;
    IBOutlet UIImageView *attImgView;
    IBOutlet UILabel *attFileName;
    IBOutlet UIImageView *topBar;
    IBOutlet UIButton *backButton;
    //MBProgressHUD *HUD;
}

@property(nonatomic,strong)UIImage *attImg;
@property(nonatomic,strong)NSURL *url;
@property(nonatomic,strong)NSString *fileName;
-(IBAction)back:(id)sender;
-(IBAction)hideTop:(id)sender;
@end
