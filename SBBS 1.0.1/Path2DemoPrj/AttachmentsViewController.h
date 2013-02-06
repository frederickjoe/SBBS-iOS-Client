//
//  AttachmentsViewController.h
//  虎踞龙蟠
//
//  Created by Huang Feiqiao on 13-1-29.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Attachment.h"
#import "AttImageViewController.h"
#import "HomeViewController.h"
#import "AttImageWebViewController.h"
#import "SingleImageWithScrollViewController.h"

@interface AttachmentsViewController : UIViewController<UIDocumentInteractionControllerDelegate, UIAlertViewDelegate>
{
    NSArray * attList;
    IBOutlet UITableView * attTable;
    NSString * openString;
}
@property(nonatomic, strong)NSArray *attList;
@property(nonatomic, retain)NSString * openString;
-(IBAction)back:(id)sender;
@end
