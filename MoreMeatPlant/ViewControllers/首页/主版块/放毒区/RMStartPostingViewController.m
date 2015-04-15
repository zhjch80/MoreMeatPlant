//
//  RMStartPostingViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMStartPostingViewController.h"
#import "UITextField+LimitLength.h"
#import "AssetHelper.h"
#import "DoImagePickerController.h"
#import "RMImageView.h"
#import "AFHTTPRequestOperationManager.h"
#import "RMVPImageCropper.h"

#define kMaxLength 18

@interface RMStartPostingViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,DoImagePickerControllerDelegate>{
    NSInteger uploadImageCount;         //纪录已选照片数量
    NSInteger uploadImageValue;         //标记要重置的位置
    NSInteger cameraType;               //取照类型  1 点击直接拍照    2 点击某一张图片
    
}
@property (strong, nonatomic) NSMutableArray * uploadImageArr;

@end

@implementation RMStartPostingViewController
@synthesize uploadImageArr;

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.mTextField resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    [self.mTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    uploadImageArr = [[NSMutableArray alloc] init];
    uploadImageCount = 0;
    
    [self setCustomNavBackgroundColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1] withStatusViewBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [self setCustomNavTitle:[NSString stringWithFormat:@"发帖(%@)",self.model_1.label]];
    [self setRightBarButtonNumber:1];
    
    [leftBarButton setTitle:@"取消" forState:UIControlStateNormal];
    leftBarButton.frame = CGRectMake(10, 0, 50, 44);
    [leftBarButton setTitleColor:[UIColor colorWithRed:0 green:0.62 blue:0.59 alpha:1] forState:UIControlStateNormal];
    [rightOneBarButton setTitle:@"发布" forState:UIControlStateNormal];
    rightOneBarButton.frame = CGRectMake(kScreenWidth - 60, 0, 50, 44);
    [rightOneBarButton setTitleColor:[UIColor colorWithRed:0 green:0.62 blue:0.59 alpha:1] forState:UIControlStateNormal];

    self.line.frame = CGRectMake(0, 99, kScreenWidth, 1);
    self.mTextField.frame = CGRectMake(0, 64, kScreenWidth, 35);
    [self.mTextField limitTextLength:kMaxLength];
    [self.mTextField setValue:[UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [[UITextField appearance] setTintColor:[UIColor colorWithRed:0 green:0.67 blue:0.65 alpha:1]];
    [[UITextView appearance] setTintColor:[UIColor colorWithRed:0 green:0.67 blue:0.65 alpha:1]];
    
    for (NSInteger i=0; i<8; i++) {
        RMImageView * imageView = [[RMImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, 100, 150);
        imageView.center = CGPointMake(20 + 50 + i * imageView.frame.size.width + i * 20, self.mScrollView.frame.size.height/2);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = LOADIMAGE(@"btn_add_photo_s", kImageTypePNG);
        [imageView addTarget:self withSelector:@selector(addUpLoadImg:)];
        imageView.tag = 101 + i;
        imageView.identifierString = @"empty";
        [self.mScrollView addSubview:imageView];
        
        RMImageView * deleteImg = [[RMImageView alloc] init];
        deleteImg.tag = 201 + i;
        deleteImg.identifierString = @"empty";
        deleteImg.hidden = YES;
        deleteImg.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width - 12, imageView.frame.origin.y - 5, 20, 20);
        [deleteImg addTarget:self withSelector:@selector(deleteUpLoadImg:)];
        deleteImg.image = LOADIMAGE(@"deletecircular", kImageTypePNG);
        [self.mScrollView addSubview:deleteImg];
        
        [uploadImageArr addObject:imageView];
    }

}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case 2:{
            [self.mTextField resignFirstResponder];
            [self.mTextView resignFirstResponder];
            
            if (![RMUserLoginInfoManager loginmanager].state){
                [self showHint:@"您没有登录，请登录"];
                return;
            }
            
            if ([self isBlankString:self.mTextField.text]){
                [self showHint:@"标题不能为空"];
                return;
            }
            NSMutableDictionary * imageDic = [[NSMutableDictionary alloc] init];
            
            for (NSInteger i=0; i<8; i++) {
                RMImageView * image = (RMImageView *)[self.view viewWithTag:101+i];
                if ([image.identifierString isEqualToString:@"full"]){
                    
                    NSData *data;
//                    if (UIImagePNGRepresentation(image.image) == nil) {
                        data = UIImageJPEGRepresentation(image.image, 0.5);
//                    } else {
//                        data = UIImagePNGRepresentation(image.image);
//                    }
                    
                    [self saveImage:[UIImage imageWithData:data] withName:[NSString stringWithFormat:@"uploadImage_%ld.jpg",(long)i]];
                    
                    NSString *fullPath = [[FileUtil getCachePathFor:@"uploadImageCache"] stringByAppendingPathComponent:[NSString stringWithFormat:@"uploadImage_%ld.jpg",(long)i]];
                    
                    [imageDic setObject:fullPath forKey:[NSString stringWithFormat:@"frm[body][%ld][content_img]",(long)i]];
                }
            }
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [RMAFNRequestManager postSendPostsWithAuto_id:@"" withContentName:[self.mTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withContentType:@"1" withContentClass:self.model_1.value withContentCourse:self.model_2.auto_code withContentBody:[self.mTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withContentImg:imageDic withBodyAuto_id:@"" withID:OBJC([RMUserLoginInfoManager loginmanager].user) withPWD:OBJC([RMUserLoginInfoManager loginmanager].pwd) callBack:^(NSError *error, BOOL success, id object) {
                if (error){
                    NSLog(@"error:%@",error);
                    [self showHint:@"发帖失败！请重新发送"];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    return ;
                }
                
                if (success){
                    [self showHint:[object objectForKey:@"msg"]];
                    
                    self.mTextField.text = @"";
                    self.mTextView.text = @"";
                    
                    for (NSInteger i=0; i<8; i++) {
                        RMImageView * image = (RMImageView *)[self.view viewWithTag:101+i];
                        RMImageView * deleteImg = (RMImageView *)[self.view viewWithTag:201+i];
                        image.identifierString = @"empty";
                        image.image = nil;
                        deleteImg.identifierString = @"empty";
                        deleteImg.image = nil;
                    }
                    
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *path = [[FileUtil getCachePathFor:@"uploadImageCache"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:path atomically:NO];
}

- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.mTextField resignFirstResponder];
    return  YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

- (void)keyboardWillShow:(NSNotification *)noti {
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.line_1.frame = CGRectMake(0, 0, kScreenWidth, 1);
    self.line_2.frame = CGRectMake(0, 34, kScreenWidth, 1);
    self.mTextView.frame = CGRectMake(0, 100, kScreenWidth, kScreenHeight - 100 - 35 - size.height);
    self.mView.frame = CGRectMake(0, 100 + self.mTextView.frame.size.height, kScreenWidth, 35);
    self.mScrollView.frame = CGRectMake(0, self.mView.frame.size.height + self.mView.frame.origin.y, kScreenWidth, kScreenHeight - self.mView.frame.size.height - self.mView.frame.origin.y);
}

- (void)keyboardDidShow:(NSNotification *)noti {
    CGFloat contentY = 0;
    
    if (self.mScrollView.frame.size.height < 150){
        contentY = 150;
    }else{
        contentY = self.mScrollView.frame.size.height;
    }
    
    self.mScrollView.contentSize = CGSizeMake(120*8+20, contentY);
}

- (void)keyboardWillHide:(NSNotification *)noti {
}

- (void)keyboardDidHide:(NSNotification *)noti {
}

- (void)addUpLoadImg:(RMImageView *)image {
    cameraType = 2;
    uploadImageValue = image.tag;
    UIActionSheet *sheet = nil;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }else{
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSUInteger sourceType = 0;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:{
                // 相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            }
            case 1:{
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            }
            case 2:{
                // 取消
                return;
            }
        }
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

- (void)deleteUpLoadImg:(RMImageView *)image {
    image.identifierString = @"empty";
    image.hidden = YES;
    RMImageView * iv = (RMImageView *)[self.mScrollView viewWithTag:image.tag - 100];
    iv.identifierString = @"empty";
    iv.image = LOADIMAGE(@"btn_add_photo_s", kImageTypePNG);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.mTextField resignFirstResponder];
    [self.mTextView resignFirstResponder];
}

- (IBAction)buttonClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1:{
            uploadImageCount = 0;
            for (NSInteger i=0; i<8; i++){
                RMImageView * image = (RMImageView *)[self.mScrollView viewWithTag:101+i];
                if ([image.identifierString isEqualToString:@"empty"]){
                    uploadImageCount ++;
                }else{
                }
            }
            
            if (uploadImageCount <= 0){
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"待上传的照片已满" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            //照片
            DoImagePickerController *imagePicker = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
            imagePicker.delegate = self;
            imagePicker.nResultType = DO_PICKER_RESULT_UIIMAGE;
            imagePicker.nMaxCount = 1;
            imagePicker.nMaxCount = uploadImageCount;
            imagePicker.nColumnCount =+ 2;
            
//            imagePicker.nMaxCount = DO_NO_LIMIT_SELECT;
//            imagePicker.nResultType = DO_PICKER_RESULT_ASSET;  // if you want to get lots photos, you'd better use this mode for memory!!!
            
            [self presentViewController:imagePicker animated:YES completion:nil];
            
            break;
        }
        case 2:{
            //拍照
            cameraType = 1;
            uploadImageCount = 0;
            for (NSInteger i=0; i<8; i++){
                RMImageView * image = (RMImageView *)[self.mScrollView viewWithTag:101+i];
                if ([image.identifierString isEqualToString:@"empty"]){
                    uploadImageCount ++;
                }else{
                }
            }
            
            if (uploadImageCount <= 0){
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"待上传的照片已满" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:^{
            }];
            break;
        }
        case 3:{
            //键盘
            if ([self.mTextField isFirstResponder] | [self.mTextView isFirstResponder]){
                [self.mTextField resignFirstResponder];
                [self.mTextView resignFirstResponder];
            }else{
                if (self.mTextField.text.length != 0){
                    [self.mTextView becomeFirstResponder];
                }else{
                    [self.mTextField becomeFirstResponder];
                }
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
//    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];

    switch (cameraType) {
        case 1:{
            for (NSInteger i=0; i<8; i++) {
                RMImageView * imageView = (RMImageView *)[self.mScrollView viewWithTag:101+i];
                RMImageView * deletetImg = (RMImageView *)[self.mScrollView viewWithTag:201+i];
                
                if ([imageView.identifierString isEqualToString:@"full"]){
                    continue ;
                }else{
                    imageView.image = image;
                    imageView.identifierString = @"full";
                    
                    deletetImg.identifierString = @"full";
                    deletetImg.hidden = NO;
//                    deletetImg.image = LOADIMAGE(@"deletecircular", kImageTypePNG);
                    break;
                }
            }
            break;
        }
        case 2:{
            RMImageView * imageView = (RMImageView *)[self.mScrollView viewWithTag:uploadImageValue];
            imageView.identifierString = @"full";
            imageView.image = image;
            
            RMImageView * deleteImg = (RMImageView *)[self.mScrollView viewWithTag:uploadImageValue + 100];
            
            deleteImg.identifierString = @"full";
            deleteImg.hidden = NO;

            break;
        }
            
        default:
            break;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (UIImage*)scaleFromImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if (width <= newSize.width && height <= newSize.height){
        return image;
    }
    
    if (width == 0 || height == 0){
        return image;
    }
    
    CGFloat widthFactor = newSize.width / width;
    CGFloat heightFactor = newSize.height / height;
    CGFloat scaleFactor = (widthFactor<heightFactor?widthFactor:heightFactor);
    
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);
    
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - DoImagePickerControllerDelegate

- (void)didCancelDoImagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE) {
        
        NSInteger value = 0;
        
        for (NSInteger i=0; i<8; i++) {
            RMImageView * imageView = (RMImageView *)[self.mScrollView viewWithTag:101+i];
            RMImageView * deleteImage = (RMImageView *)[self.mScrollView viewWithTag:201+i];
            
            if ([imageView.identifierString isEqualToString:@"full"]){
                continue ;
            }else{
                if ([aSelected count] > value){
                    imageView.image = aSelected[value];
                    imageView.identifierString = @"full";
                    
                    deleteImage.identifierString = @"full";
                    deleteImage.hidden = NO;
                    value ++;
                }else{
                }
            }
        }
    }else if(picker.nResultType == DO_PICKER_RESULT_ASSET) {
        for (int i = 0; i < MIN(8, aSelected.count); i++) {
            RMImageView *iv = uploadImageArr[i];
            iv.image = [ASSETHELPER getImageFromAsset:aSelected[i] type:ASSET_PHOTO_SCREEN_SIZE];

        }
        [ASSETHELPER clearData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
