//
//  UploadAttachmentsViewController.m
//  虎踞龙蟠
//
//  Created by Huang Feiqiao on 13-2-3.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "UploadAttachmentsViewController.h"


@implementation UploadAttachmentsViewController
@synthesize mDelegate;
@synthesize postType;
@synthesize attList;
@synthesize board;
@synthesize postId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    if (postType==0 || postType==1) {//新帖或回复
        //attList=[[NSArray alloc] init];
    }
    else
    {//修改
        //do nothing
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancel:(id)sender
{
    [mDelegate passValue:attList];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)pickImageFromAlbum:(id)sender
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = NO;
    
    [self presentModalViewController:imagePicker animated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [attList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] init];
    cell.textLabel.text=[[attList objectAtIndex:indexPath.row] attFileName];
    return [cell autorelease];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    curRow=indexPath.row;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"删除该附件？"
                                  delegate:self //actionSheet的代理，按钮被按下时收到通知，然后回调协议中的相关方法
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"删除"
                                  otherButtonTitles:nil];
    //展示actionSheet
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"clickedButtonAtIndex");
    UIAlertView *alert = nil;
    if(buttonIndex == [actionSheet destructiveButtonIndex]){//确定
        //NSLog(@"确定");
        //执行删除操作
        [self doDelete];
    }else if(buttonIndex == [actionSheet cancelButtonIndex]){//取消
        
    }
}

-(void)doDelete
{
    int attid=[[attList objectAtIndex:curRow] attId];
    NSString * delUrlString;
    if (postType==0 || postType==1) {//新帖或者回复
        delUrlString=[NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/attachment/delete.js?token=%@&attid=%d",myBBS.mySelf.token,attid];
    }
    else{
        
        delUrlString=[NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/attachment/delete.js?token=%@&board=%@&id=%d&attid=%d",myBBS.mySelf.token,board,postId,attid];
    }
    NSURL *delUrl=[NSURL URLWithString:delUrlString];
    [attList release];
    attList=[[BBSAPI delImg:delUrl] retain];
    [attTable reloadData];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];

    image= [[info objectForKey:@"UIImagePickerControllerOriginalImage"] retain];
    
    NSURL *imagePath= [info objectForKey:@"UIImagePickerControllerReferenceURL"] ;
    //NSLog(@"%@",[image debugDescription]);
    NSString *theimageName = [imagePath lastPathComponent];
    NSString *imageSuffix =[theimageName substringFromIndex:6];
    //NSLog(@"the image name:%@",imageSuffix);
    NSString *imagePathString=[imagePath absoluteString];
    NSRange r=NSMakeRange(36, 36);
    NSString *imageName= [imagePathString substringWithRange:r];
    imageFileName=[[NSString stringWithFormat:@"%@.%@",imageName,imageSuffix] retain];
    //NSLog(@"RangeString:%@",imageName);
    NSString *urlString;
    
    if (postType==0 || postType==1) {//新帖或者回复
        urlString=[NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/attachment/add.js?token=%@",myBBS.mySelf.token];
    }
    else{
        
        urlString=[NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/attachment/add.js?token=%@&board=%@&id=%d",myBBS.mySelf.token,board,postId];
    }
    theUrl=[[NSURL URLWithString:urlString] retain];
    
    //NSArray *a=[[BBSAPI postImageto:theUrl withImage:image andToken:myBBS.mySelf.token] retain];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view insertSubview:HUD atIndex:5];
	HUD.labelText = @"上传中...";
    [HUD showWhileExecuting:@selector(uploadImage) onTarget:self withObject:nil animated:YES];//草这玩意儿是新的线程啊草草草
    
    //NSLog(@"%d",[a count]);
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    [picker release];
    
}

-(void)uploadImage
{
    [attList release];
    attList=[[BBSAPI postImg:imageFileName Image:image toUrl:theUrl] retain];
    
    [HUD removeFromSuperview];
    [HUD release];
    [image release];
    [theUrl release];
    [imageFileName release];
    [attTable reloadData];
}
@end
