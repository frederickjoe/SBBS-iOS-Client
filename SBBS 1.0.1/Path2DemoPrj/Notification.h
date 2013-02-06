//
//  Notification.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/7/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject
{
    NSArray * mails;
    NSArray * ats;
    NSArray * replies;
    int count;
}
@property(nonatomic, retain)NSArray * mails;
@property(nonatomic, retain)NSArray * ats;
@property(nonatomic, retain)NSArray * replies;
@property(nonatomic, assign)int count;
@end
