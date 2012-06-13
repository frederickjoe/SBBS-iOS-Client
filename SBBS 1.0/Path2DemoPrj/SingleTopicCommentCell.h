//
//  SingleTopicCommentCell.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleTopicCommentCell : UITableViewCell
{
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * contentTextView;
    IBOutlet UILabel * commentToTextView;
    IBOutlet UILabel * loushu;
    int ID;
    NSDate * time;
    
    NSString * content;
    NSString * author;
    NSString * quoter;
    NSString * quote;
    
    int read;
    
    int num;
}
@property(nonatomic, assign)int ID;
@property(nonatomic, retain)NSDate * time;
@property(nonatomic, retain)NSString * author;
@property(nonatomic, retain)NSString * content;
@property(nonatomic, retain)NSString * quoter;
@property(nonatomic, retain)NSString * quote;
@property(nonatomic, assign)int read;
@property(nonatomic, assign)int num;
-(void)setReadyToShow;
@end
