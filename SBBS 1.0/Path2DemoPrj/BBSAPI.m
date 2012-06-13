//
//  BBSAPI.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "BBSAPI.h"

@implementation BBSAPI

+(NSArray *)searchTopics:(NSString *)key start:(NSString *)start Token:(NSString*)token
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/search/topics.json?" mutableCopy];
    [baseurl appendFormat:@"keys=%@",[key URLEncodedString]];
    [baseurl appendFormat:@"&limit=10&start=%@", start];
    if (token != nil) {
        [baseurl appendFormat:@"&token=%@", token];
    }
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    
    [baseurl release];
    
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    NSArray * Status = [[JsonParseEngine parseSearchTopics:topTenTopics] retain];
    if (Status == nil) {
        return nil;
    }
    else {
        return [Status autorelease];
    }
}

+(NSArray *)searchBoards:(NSString *)key Token:(NSString*)token
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/search/boards.json?" mutableCopy];
    [baseurl appendFormat:@"name=%@", [key URLEncodedString]];
    if (token != nil) {
        [baseurl appendFormat:@"&token=%@", token];
    }
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    [baseurl release];
    
    NSArray * Status = [[JsonParseEngine parseBoards:topTenTopics] retain];
    if (Status == nil) {
        return nil;
    }
    else {
        return [Status autorelease];
    }
}


+(User *)login:(NSString *)user Pass:(NSString *)pass
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/token.json?" mutableCopy];
    [baseurl appendFormat:@"user=%@", user];
    [baseurl appendFormat:@"&pass=%@",pass];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    [baseurl release];
    
    User * Status = [[JsonParseEngine parseLogin:topTenTopics] retain];
    if (Status == nil) {
        return nil;
    }
    else {
        return [Status autorelease];
    }
}


+(NSArray *)topTen
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return nil;
    }
    
    NSString *baseurl= @"http://bbs.seu.edu.cn/api/hot/topten.json";
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    NSArray * Status = [[JsonParseEngine parseTopics:topTenTopics] retain];
    if (Status == nil) {
        return nil;
    }
    else {
        return [Status autorelease];
    }
}

+(NSArray *)hotBoards
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return nil;
    }
    
    NSString *baseurl= @"http://bbs.seu.edu.cn/api/hot/boards.json";
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    NSArray * Status = [[JsonParseEngine parseBoards:topTenTopics] retain];
    if (Status == nil) {
        return nil;
    }
    else {
        return [Status autorelease];
    }
}

+(NSArray *)offlineDataToAllSections:(NSData *)data
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return nil;
    }
    
    NSDictionary *topTenTopics = [data objectFromJSONData];
    NSArray * Status = [[JsonParseEngine parseSections:topTenTopics] retain];
    if (Status == nil) {
        return nil;
    }
    else {
        return [Status autorelease];
    }
}

+(NSData *)allSectionsData:(NSString*)token;
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/sections.json?" mutableCopy];
    if (token != nil) {
        [baseurl appendFormat:@"token=%@", token];
    }
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    [baseurl release];
    return feedback;
}

+(NSArray *)allFavSections:(NSString *)token
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/fav/get.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@", token];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    [baseurl release];
    
    NSArray * Status = [[JsonParseEngine parseSections:topTenTopics] retain];
    if (Status == nil) {
        return nil;
    }
    else {
        return [Status autorelease];
    }
}

+(NSArray *)onlineFriends:(NSString *)token
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/friends.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@", token];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    [baseurl release];
    
    NSArray * Status = [[JsonParseEngine parseFriends:topTenTopics] retain];
    if (Status == nil) {
        return nil;
    }
    else {
        return [Status autorelease];
    }
}

+(NSArray *)allFriends:(NSString *)token
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/friends/all.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@", token];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    [baseurl release];
    
    NSArray * Status = [[JsonParseEngine parseFriends:topTenTopics] retain];
    if (Status == nil) {
        return nil;
    }
    else {
        return [Status autorelease];
    }
}

+(BOOL)deletFriend:(NSString *)token ID:(NSString *)ID
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/friends/delete.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&id=%@",ID];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    [baseurl release];
    
    BOOL success = [[topTenTopics objectForKey:@"success"] boolValue];
    return success;
}
+(BOOL)addFriend:(NSString *)token ID:(NSString *)ID
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/friends/add.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@", token];
    [baseurl appendFormat:@"&id=%@",ID];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    [baseurl release];
    
    int result = [[topTenTopics objectForKey:@"result"] intValue];
    BOOL success = NO;
    if (result == 0) {
        success = YES;
    }
    return success;
}
+(BOOL)isFriend:(NSString *)token ID:(NSString *)ID
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/friends/add.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&id=%@",ID];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    [baseurl release];
    
    int result = [[topTenTopics objectForKey:@"result"] intValue];
    if (result == -2) {
        return TRUE;
    }
    else {
        [BBSAPI deletFriend:token ID:ID];
        return FALSE;
    }
    return FALSE;
}
+(NSArray *)getMails:(NSString *)token Type:(int)type Start:(int)start
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/mailbox/get.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&type=%i",type];
    [baseurl appendFormat:@"&limit=10&start=%i",start];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    [baseurl release];
    
    NSArray * Status = [[JsonParseEngine parseMails:topTenTopics Type:type] retain];
    if (Status == nil) {
        return nil;
    }
    else {
        return [Status autorelease];
    }
}

+(Mail *)getSingleMail:(NSString *)token Type:(int)type ID:(int)ID
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/mail/get.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&type=%i",type];
    [baseurl appendFormat:@"&id=%i",ID];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    [baseurl release];
    
    Mail * Status = [[JsonParseEngine parseSingleMail:topTenTopics Type:type] retain];
    if (Status == nil) {
        return nil;
    }
    else {
        return [Status autorelease];
    }
}
+(BOOL)deleteSingleMail:(NSString *)token Type:(int)type ID:(int)ID
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/mail/delete.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&type=%i",type];
    [baseurl appendFormat:@"&id=%i",ID];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    
    [baseurl release];
    
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    BOOL success = [[topTenTopics objectForKey:@"success"] boolValue];
    return success;
}
+(BOOL)postMail:(NSString *)token User:(NSString *)user Title:(NSString *)title Content:(NSString *)content Reid:(int)reid
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/mail/send.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&user=%@",user];
    [baseurl appendFormat:@"&title=%@",[title URLEncodedString]];
    [baseurl appendFormat:@"&content=%@",[content URLEncodedString]];
    [baseurl appendFormat:@"&reid=%i",reid];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    
    [baseurl release];
    
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    BOOL success = [[topTenTopics objectForKey:@"success"] boolValue];
    if (success) {
        int result = [[topTenTopics objectForKey:@"result"] intValue];
        if (result == 0) {
            return YES;
        }
        else {
            return NO;
        }
    }
    return NO;
}


+(Notification *)getNotification:(NSString *)token
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/notifications.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    [baseurl release];
    
    Notification * Status = [[JsonParseEngine parseNotification:topTenTopics] retain];
    if (Status == nil) {
        return nil;
    }
    else {
        return [Status autorelease];
    }
}
+(BOOL)clearNotification:(NSString *)token
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/clear_notifications.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    
    [baseurl release];
    
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    BOOL success = [[topTenTopics objectForKey:@"success"] boolValue];
    return success;
}

+(NSArray *)boardTopics:(NSString *)board Start:(int)start Token:(NSString*)token
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/" mutableCopy];
    [baseurl appendFormat:@"board/%@.json?", board];
    [baseurl appendFormat:@"mode=2&limit=10&start=%i", start];
    if (token != nil) {
        [baseurl appendFormat:@"&token=%@", token];
    }
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    [baseurl release];
    
    NSArray * Status = [[JsonParseEngine parseTopics:topTenTopics] retain];
    if (Status == nil) {
        return nil;
    }
    else {
        return [Status autorelease];
    }
}

+(NSArray *)singleTopic:(NSString *)board ID:(int)ID Start:(int)start Token:(NSString*)token
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/topic/" mutableCopy];
    [baseurl appendFormat:@"/%@",board];
    [baseurl appendFormat:@"/%i.json?start=%ilimit=10",ID,start];
    if (token != nil) {
        [baseurl appendFormat:@"&token=%@", token];
    }
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    
    [baseurl release];

    NSDictionary *singleTopic = [feedback objectFromJSONData];
    NSArray * Status = [[JsonParseEngine parseSingleTopic:singleTopic] retain];
    if (Status == nil) {
        return nil;
    }
    else {
        return [Status autorelease];
    }
}
+(User *)userInfo:(NSString *)userID
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/user/" mutableCopy];
    [baseurl appendFormat:@"%@.json",userID];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    
    [baseurl release];
    
    NSDictionary *singleTopic = [feedback objectFromJSONData];
    User * Status = [[JsonParseEngine parseUserInfo:singleTopic] retain];
    if (Status == nil) {
        return nil;
    }
    else {
        return [Status autorelease];
    }
}




+(BOOL)editTopic:(NSString *)token Board:(NSString *)board Title:(NSString *)title Content:(NSString *)content Reid:(int)reid
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/topic/edit.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&board=%@",board];
    [baseurl appendFormat:@"&title=%@",[title URLEncodedString]];
    [baseurl appendFormat:@"&content=%@",[content URLEncodedString]];
    [baseurl appendFormat:@"&id=%i",reid];
    [baseurl appendFormat:@"&type=%i",3];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    [baseurl release];
    
    BOOL success = [[topTenTopics objectForKey:@"success"] boolValue];
    return success;
}

+(BOOL)postTopic:(NSString *)token Board:(NSString *)board Title:(NSString *)title Content:(NSString *)content Reid:(int)reid
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/topic/post.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&board=%@",board];
    [baseurl appendFormat:@"&title=%@",[title URLEncodedString]];
    [baseurl appendFormat:@"&content=%@",[content URLEncodedString]];
    [baseurl appendFormat:@"&reid=%i",reid];
    [baseurl appendFormat:@"&type=%i",3];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    [baseurl release];
    
    BOOL success = [[topTenTopics objectForKey:@"success"] boolValue];
    return success;
}


+(BOOL)isNetworkReachable{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}
@end
