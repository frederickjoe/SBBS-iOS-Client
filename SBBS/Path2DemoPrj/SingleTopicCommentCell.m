//
//  SingleTopicCommentCell.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SingleTopicCommentCell.h"
#import "Attachment.h"
#import "MWPhotoBrowserIncell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SingleTopicCommentCell
@synthesize ID;
@synthesize time;
@synthesize content;
@synthesize author;
@synthesize quoter;
@synthesize quote;
@synthesize read;
@synthesize num;
@synthesize attExist;
@synthesize attExistPhoto;
@synthesize attachments;
@synthesize attachmentsViewController;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSArray *)getPicList
{
    NSMutableArray * picArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [attachments count]; i++) {
        NSString * attUrlString=[[attachments objectAtIndex:i] attUrl];
        if ([attUrlString hasSuffix:@".png"] || [attUrlString hasSuffix:@".jpg"] || [attUrlString hasSuffix:@".jpeg"] || [attUrlString hasSuffix:@".PNG"] || [attUrlString hasSuffix:@".JPG"] || [attUrlString hasSuffix:@".JPEG"])
        {
            [picArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:attUrlString]]];
        }
    }
    return picArray;
}

-(void)setReadyToShow
{
    
    UIFont *font = [UIFont systemFontOfSize:15.0];
    
    [authorLabel setText:author];
    [contentTextView setText:content];
    if (attExist) {
        [attNotifier setHidden:NO];
    }
    else
    {
        [attNotifier setHidden:YES];
    }
    CGSize size1 = [content sizeWithFont:font constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];
    [contentTextView setFrame:CGRectMake(contentTextView.frame.origin.x, contentTextView.frame.origin.y, contentTextView.frame.size.width, size1.height)];
    
    UIFont *font2 = [UIFont systemFontOfSize:12.0];
    CGSize size2 = [[NSString stringWithFormat:@"回复:%@\n%@",quoter, quote] sizeWithFont:font2 constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];
    //NSLog(@"the size1.height:%f\n the size2.height:%f",size1.height,size2.height);
    [commentToTextView setText:[NSString stringWithFormat:@"回复:%@\n%@",quoter, quote]];
    [commentToTextView setFrame:CGRectMake(contentTextView.frame.origin.x, contentTextView.frame.origin.y+size1.height+10, commentToTextView.frame.size.width, size2.height)];
    
    [loushu setText:[NSString stringWithFormat:@"%i楼", num]];
    
    if (attachmentsViewController != nil) {
        [self.attachmentsViewController.view removeFromSuperview];
    }
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL ShowAttachments = [defaults boolForKey:@"ShowAttachments"];
    if (ShowAttachments && attExistPhoto) {
        MWPhotoBrowserIncell * browser = [[MWPhotoBrowserIncell alloc] initWithPhotos:[self getPicList]];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        [nc.view setFrame:CGRectMake(15, commentToTextView.frame.origin.y + size2.height + 10, 290, 380)];
        [nc.view setAutoresizesSubviews:NO];
        nc.view.layer.shadowColor = [UIColor whiteColor].CGColor;
        nc.view.layer.shadowOpacity = 1.0f;
        nc.view.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        nc.view.layer.shadowRadius = 0.8f;
        nc.view.layer.masksToBounds = NO;
        [nc.view layer].shadowPath = [UIBezierPath bezierPathWithRect:[nc.view layer].bounds].CGPath;
        
        [self addSubview:nc.view];
        self.attachmentsViewController = nc;
    }
}
@end
