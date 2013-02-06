//
//  MyBBS.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "MyBBS.h"

@implementation MyBBS
@synthesize allSections;
@synthesize mySelf;
@synthesize notification;
@synthesize notificationCount;

- (id)init
{
    self = [super init];
    if (self) {
        notificationCount = 0;
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * username = [defaults stringForKey:@"UserName"];
        NSString * userid = [defaults stringForKey:@"UserID"];
        NSString * usertoken = [defaults stringForKey:@"UserToken"];
        
        if (username != NULL) {
            self.mySelf = [[[User alloc] init] autorelease];
            mySelf.name = username;
            mySelf.ID = userid;
            mySelf.token = usertoken;
        }
        
        NSData * allsectionsdata = [defaults dataForKey:@"AllSections"];
        if (allsectionsdata != NULL)
            self.allSections = [BBSAPI offlineDataToAllSections:allsectionsdata];
    }
    return self;
}
-(void)dealloc
{
    [super dealloc];
    [allSections release];
    [mySelf release];
    [notification release];
}

-(void)refreshAllSections
{
    NSData * allsectionsdata = [BBSAPI allSectionsData:mySelf.token];
    self.allSections = [BBSAPI offlineDataToAllSections:allsectionsdata];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:allsectionsdata forKey:@"AllSections"];
}
-(User *)userLogin:(NSString *)user Pass:(NSString *)pass
{
    self.mySelf = [BBSAPI login:user Pass:pass];
    if (mySelf == nil) {
        return nil;
    }
    else {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:mySelf.name forKey:@"UserName"];
        [defaults setValue:mySelf.ID forKey:@"UserID"];
        [defaults setValue:mySelf.token forKey:@"UserToken"];
        return mySelf;
    }   
}
-(void)userLogout
{
    mySelf.name = nil;
    mySelf.ID = nil;
    mySelf.token = nil;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:NULL forKey:@"UserName"];
    [defaults setValue:NULL forKey:@"UserID"];
    [defaults setValue:NULL forKey:@"UserToken"];
}

-(void)refreshNotification
{
    self.notification = [BBSAPI getNotification:mySelf.token];
    if (notification != nil) {
        notificationCount = [notification.mails count] + [notification.ats count] + [notification.replies count];
        notification.count = notificationCount;
    }
}
-(void)clearNotification
{
    [BBSAPI clearNotification:mySelf.token];
}

@end
