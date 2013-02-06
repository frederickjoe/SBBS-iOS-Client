//
//  SingleImageWithScrollViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 1/5/13.
//  Copyright (c) 2012 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"

@protocol SingleImageWithScrollViewControllerDelegate;

@interface SingleImageWithScrollViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UILabel * imageLabel;
    UIScrollView * imageScrollView;
    UIImageView * imageRealView;
    UIActivityIndicatorView * spinner;
    id mDelegate;
    
    ImageData * imageData;
    
    BOOL isGIF;
}
@property(nonatomic, assign)UIImageView * imageRealView;
@property(nonatomic, retain)ImageData * imageData;
@property(nonatomic, assign)id mDelegate;
@property(nonatomic, assign)BOOL isGIF;

-(IBAction)back:(id)sender;
-(IBAction)save:(id)sender;
-(void)loadBigImageView;
@end

@protocol SingleImageWithScrollViewControllerDelegate
@optional
-(void)tapImageToShowOrHideBars;
@end