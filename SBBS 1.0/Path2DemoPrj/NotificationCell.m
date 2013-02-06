//
//  TopTenTableView.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell
@synthesize notification;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    notificationCount = nil;
    notificationImageView = nil;
    notification = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)refreshCell
{
    //[self fadeOut];
    if (notification.count == 0) {
        [notificationImageView setHidden:YES];
        [notificationCount setText:@"无新消息"];
    }
    else {
        [notificationImageView setHidden:NO];
        [notificationCount setText:[NSString stringWithFormat:@"%i 条新消息", notification.count]];
    }
}


-(void)fadeOut
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fadeIn)];
    [notificationImageView setAlpha:0];
	[UIView commitAnimations];
}

-(void)fadeIn
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(fadeOut)];
    [notificationImageView setAlpha:1];
    [UIView commitAnimations];
}
@end
