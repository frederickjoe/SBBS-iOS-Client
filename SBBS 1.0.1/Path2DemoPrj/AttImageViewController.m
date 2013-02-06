//
//  AttImageViewController.m
//  虎踞龙蟠
//
//  Created by Huang Feiqiao on 13-2-1.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "AttImageViewController.h"



@implementation AttImageViewController
@synthesize attImg;
@synthesize url;
@synthesize fileName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [attImgView setUserInteractionEnabled:YES];
        //NSLog(@"fuck");
        [attImgView setMultipleTouchEnabled:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    
    dispatch_queue_t loadImgQ=dispatch_queue_create("com.SBBS.loadImg", NULL);
    dispatch_async(loadImgQ, ^{
        attImg=[[BBSAPI getRemoteImage:url] retain];
        //NSLog(@"loading image:%@",url);
        dispatch_async(dispatch_get_main_queue(),^{
            [attImgView setImage:attImg];
            [attFileName setText:fileName];
            [attImg release];
        });
    });
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)hideTop:(id)sender
{
    if ([topBar isHidden]) {
        [topBar setHidden:NO];
        [backButton setHidden:NO];
        [attFileName setHidden:NO];
    }
    else{
        [topBar setHidden:YES];
        [backButton setHidden:YES];
        [attFileName setHidden:YES];
    }
}
@end
