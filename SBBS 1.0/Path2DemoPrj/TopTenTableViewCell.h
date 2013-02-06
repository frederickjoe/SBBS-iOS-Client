//
//  TopTenTableView.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopTenTableViewCell : UITableViewCell
{
    IBOutlet UILabel * articleTitleLabel;
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * readandreplyLabel;
    IBOutlet UILabel * boardLabel;
    
    int ID;
    NSDate * time;
    NSString * title;
    NSString * author;
    NSString * board;
    int replies;
    int read;
}
@property(nonatomic, assign)int ID;
@property(nonatomic, retain)NSDate * time;
@property(nonatomic, retain)NSString * title;
@property(nonatomic, retain)NSString * author;
@property(nonatomic, retain)NSString * board;
@property(nonatomic, assign)int replies;
@property(nonatomic, assign)int read;

-(void)setReadyToShow;
-(void)showAinmationWhenSeleceted;
@end
