//
//  AttImageWebViewController.h
//  虎踞龙蟠
//
//  Created by Huang Feiqiao on 13-2-3.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttImageWebViewController : UIViewController
{
    IBOutlet UIWebView *imgWebView;
    NSURL * imgUrl;
}
@property(strong, nonatomic)NSURL *imgUrl;
-(IBAction)back:(id)sender;
-(IBAction)saveImg:(id)sender;
@end
