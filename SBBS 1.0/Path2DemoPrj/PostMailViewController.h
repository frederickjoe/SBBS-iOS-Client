//
//  PostMailViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/8/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AddPostUserViewController.h"
#import "BBSAPI.h"

@interface PostMailViewController : UIViewController
{
    IBOutlet UILabel * topTitleLabel;
    
    IBOutlet UITextField * postUser;
    IBOutlet UIButton * addUserButton;
    IBOutlet UIButton * sendButton;
    
    IBOutlet UITextField * postTitle;
    IBOutlet UILabel * postTitleCount;
    
    IBOutlet UITextView * postContent;
    
    MBProgressHUD * HUD;
    Mail * rootMail;
    NSString * sentToUser;
    int postType; // 发表类型，0发新邮件，1回复邮件，2已指定发件人
    MyBBS * myBBS;
    id mDelegate;
}
@property(nonatomic, retain)Mail * rootMail;
@property(nonatomic, retain)NSString * sentToUser;
@property(nonatomic, assign)int postType;
@property(nonatomic, assign)id mDelegate;

-(IBAction)cancel:(id)sender;
-(IBAction)sent:(id)sender;
@end
