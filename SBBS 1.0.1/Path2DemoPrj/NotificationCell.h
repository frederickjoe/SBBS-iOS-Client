//
//  TopTenTableView.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notification.h"
@interface NotificationCell : UITableViewCell
{
    IBOutlet UILabel * notificationCount;
    IBOutlet UIImageView * notificationImageView;
    Notification * notification;
}
@property(nonatomic, retain)Notification * notification;
-(void)refreshCell;

@end
