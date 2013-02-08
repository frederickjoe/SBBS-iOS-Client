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
    id __unsafe_unretained mDelegate;
    
    ImageData * imageData;
    
    BOOL isGIF;
}
@property(nonatomic, strong)UIImageView * imageRealView;
@property(nonatomic, strong)ImageData * imageData;
@property(nonatomic, unsafe_unretained)id mDelegate;
@property(nonatomic, assign)BOOL isGIF;

-(IBAction)back:(id)sender;
-(IBAction)save:(id)sender;
-(void)loadBigImageView;
@end

@protocol SingleImageWithScrollViewControllerDelegate
@optional
-(void)tapImageToShowOrHideBars;
@end