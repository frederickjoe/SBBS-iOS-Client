//
//  SingleTopicCell.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleTopicCell : UITableViewCell
{
    IBOutlet UILabel * articleTitleLabel;
    IBOutlet UILabel * authorLabel;
    IBOutlet UITextView * contentTextView;
    IBOutlet UILabel * contentLabel;
    IBOutlet UIImageView * attNotifier;
    int ID;
    NSDate * time;
    NSString * title;
    NSString * content;
    NSString * author;
    BOOL attExist;
    int read;
}
@property(nonatomic, assign)BOOL attExist;
@property(nonatomic, assign)int ID;
@property(nonatomic, retain)NSDate * time;
@property(nonatomic, retain)NSString * title;
@property(nonatomic, retain)NSString * author;
@property(nonatomic, retain)NSString * content;

@property(nonatomic, assign)IBOutlet UITextView * contentTextView;
@property(nonatomic, assign)int read;
-(void)setReadyToShow;
@end
