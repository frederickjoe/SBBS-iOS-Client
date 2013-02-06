//
//  SingleImageWithScrollViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 1/5/13.
//  Copyright (c) 2012 SEU. All rights reserved.
//

#import "SingleImageWithScrollViewController.h"

@implementation SingleImageWithScrollViewController
@synthesize mDelegate;
@synthesize imageData;
@synthesize imageRealView;
@synthesize isGIF;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isGIF = NO;
        imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 436)];
        imageScrollView.directionalLockEnabled = NO;
        imageScrollView.decelerationRate = 0.0;
        imageScrollView.backgroundColor = [UIColor clearColor]; 
        imageScrollView.showsVerticalScrollIndicator = NO; 
        imageScrollView.showsHorizontalScrollIndicator = NO; 
        imageScrollView.delegate = self;
        
        //最多放大到3倍
        [imageScrollView setMinimumZoomScale:1.0];
        [imageScrollView setMaximumZoomScale:3.0];
        [self.view addSubview:imageScrollView];
        
        imageRealView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
        [imageRealView setContentMode:UIViewContentModeScaleAspectFit];
        [imageScrollView addSubview:imageRealView];
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
        [imageRealView addSubview:spinner];
    }
    return self;
}
-(void)loadBigImageView
{
    [imageLabel setText:imageData.title];
    if (isGIF) {
        UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
        [self.view addSubview:webView];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageData.url]]];
    }
    [spinner startAnimating];
    if (imageData.image == nil) {
        //[imageRealView setImage:imageData.waitImage];
        ImageDownloader * imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.imageData = imageData;
        imageDownloader.imageView = imageRealView;
        [imageDownloader startDownload];
        [imageDownloader release];
    }
    else {
        for(UIView *indicatorview in [imageRealView subviews])
            [indicatorview stopAnimation];
        [imageRealView setImage:imageData.image];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

 #pragma mark -
 #pragma mark UIScrollViewDelegate
 - (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
 {
     return imageRealView;
 }
 - (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
 {
     if (scale < 1) {
         [scrollView setZoomScale:1 animated:YES];
     }
 }

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)save:(id)sender
{
    if (imageData.image != nil) {
        UIImageWriteToSavedPhotosAlbum(imageData.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片还未加载好，再等一等吧～" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark -
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error
 contextInfo:(void*)contextInfo
{// Was there an error?
    if(error !=NULL){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"图片保存失败" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片保存成功" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
 
@end
