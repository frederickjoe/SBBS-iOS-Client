//
//  SingleTopicCommentCell.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SingleTopicCommentCell.h"

@implementation SingleTopicCommentCell
@synthesize ID;
@synthesize time;
@synthesize content;
@synthesize author;
@synthesize quoter;
@synthesize quote;
@synthesize read;
@synthesize num;


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
    
    UIFont *font = [UIFont systemFontOfSize:15.0];
    
    [authorLabel setText:author];
    [contentTextView setText:content];
    
    CGSize size1 = [content sizeWithFont:font constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];
    [contentTextView setFrame:CGRectMake(contentTextView.frame.origin.x, contentTextView.frame.origin.y, contentTextView.frame.size.width, size1.height)];
    
    UIFont *font2 = [UIFont systemFontOfSize:12.0];
    CGSize size2 = [[NSString stringWithFormat:@"回复:%@\n%@",quoter, quote] sizeWithFont:font2 constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];
    NSLog(@"the size1.height:%f\n the size2.height:%f",size1.height,size2.height);
    [commentToTextView setText:[NSString stringWithFormat:@"回复:%@\n%@",quoter, quote]];
    [commentToTextView setFrame:CGRectMake(contentTextView.frame.origin.x, contentTextView.frame.origin.y+size1.height+10, commentToTextView.frame.size.width, size2.height)];
    
    [loushu setText:[NSString stringWithFormat:@"%i楼", num]];
}
@end
