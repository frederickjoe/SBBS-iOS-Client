//
//  PostTopicViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BBSAPI.h"

@interface PostTopicViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UILabel * topTitleLabel;
    
    
    IBOutlet UITextField * postTitle;
    IBOutlet UILabel * postTitleCount;
    IBOutlet UIButton * sendButton;
    
    IBOutlet UITextView * postContent;
    MBProgressHUD * HUD;
    Topic * rootTopic;
    NSString * boardName;
    
    int postType; // 发表类型，0发表新文章，1回帖，2修改文章
    MyBBS * myBBS;
    id mDelegate;
}
@property(nonatomic, retain)Topic * rootTopic;
@property(nonatomic, retain)NSString * boardName;
@property(nonatomic, assign)int postType;
@property(nonatomic, assign)id mDelegate;

-(IBAction)cancel:(id)sender;
-(IBAction)sent:(id)sender;

-(IBAction)inputText:(id)sender;
@end
