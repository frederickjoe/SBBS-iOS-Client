//
//  BoardsCellView.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/2/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "BoardsCellView.h"

@implementation BoardsCellView

@synthesize name;
@synthesize description;
@synthesize section;
@synthesize leaf;

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
   // [nameLabel setText:[NSString stringWithFormat:@"%@(%@)",description,name]];
    [nameLabel setText:name];
    [descriptionLabel setText:description];
}

- (void)bounce1AnimationStopped
{
[UIView beginAnimations:nil context:nil];
[UIView setAnimationDuration:0.1];
[UIView setAnimationDelegate:self];
[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
self.transform = CGAffineTransformIdentity;
[UIView commitAnimations];
}

-(void)showAinmationWhenSeleceted
{
[UIView beginAnimations:nil context:nil];
[UIView setAnimationDuration:0.1];
[UIView setAnimationDelegate:self];
[UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.98, 0.98);
[UIView commitAnimations];
}
@end
