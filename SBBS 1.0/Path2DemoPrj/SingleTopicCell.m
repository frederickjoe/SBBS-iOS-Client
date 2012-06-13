//
//  SingleTopicCell.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SingleTopicCell.h"

@implementation SingleTopicCell
@synthesize ID;
@synthesize time;
@synthesize title;
@synthesize author;
@synthesize content;
@synthesize contentTextView;

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

-(void)setReadyToShow
{
    [articleTitleLabel setText:title];
    [authorLabel setText:author];
    [contentLabel setText:content];
    
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CGSize size2 = [content sizeWithFont:font constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];
    
    [contentLabel setFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, contentLabel.frame.size.width, size2.height)];
}
@end
