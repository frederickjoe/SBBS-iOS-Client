//
//  AboutViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
{
    id mDelegate;
}
@property(nonatomic, assign)id mDelegate;
-(IBAction)done:(id)sender;
@end
