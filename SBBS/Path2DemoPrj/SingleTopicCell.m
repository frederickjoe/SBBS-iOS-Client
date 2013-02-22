//
//  SingleTopicCell.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SingleTopicCell.h"
#import "Attachment.h"
#import "MWPhotoBrowserIncell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SingleTopicCell
@synthesize attExist;
@synthesize attExistPhoto;
@synthesize ID;
@synthesize time;
@synthesize title;
@synthesize author;
@synthesize content;
@synthesize contentTextView;
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
    [articleTitleLabel setText:title];
    [authorLabel setText:author];
    [contentLabel setText:content];
    if (attExist) {
        [attNotifier setHidden:NO];
    }
    else
    {
        [attNotifier setHidden:YES];
    }
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CGSize size2 = [content sizeWithFont:font constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];
    
    [contentLabel setFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, contentLabel.frame.size.width, size2.height)];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL ShowAttachments = [defaults boolForKey:@"ShowAttachments"];
    if (ShowAttachments && attExistPhoto && attachmentsViewController == nil) {
        MWPhotoBrowserIncell * browser = [[MWPhotoBrowserIncell alloc] initWithPhotos:[self getPicList]];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        [nc.view setFrame:CGRectMake(15, contentLabel.frame.origin.y + size2.height + 10, 290, 380)];
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
