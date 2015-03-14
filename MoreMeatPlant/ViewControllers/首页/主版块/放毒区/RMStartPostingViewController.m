//
//  RMStartPostingViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMStartPostingViewController.h"
#import "RMStartPostingHeaderView.h"
#import "UITextField+LimitLength.h"
#import "AssetHelper.h"
#import "DoImagePickerController.h"
#import "RMImageView.h"

#define kMaxLength 18

@interface RMStartPostingViewController ()<UITextFieldDelegate,StartPostingHeaderDelegate,DoImagePickerControllerDelegate>{
    BOOL isLoadUpLoadImg;
    NSInteger uploadImageCount;
}
@property (nonatomic, strong) RMStartPostingHeaderView * headerView;
@property (strong, nonatomic) NSMutableArray * uploadImageArr;

@end

@implementation RMStartPostingViewController
@synthesize headerView, uploadImageArr;

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
    uploadImageArr = [[NSMutableArray alloc] init];
    uploadImageCount = 0;
    
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    [self loadHeaderView];
    
    [self.mTextField limitTextLength:kMaxLength];
    [self.mTextField setValue:[UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [[UITextField appearance] setTintColor:[UIColor colorWithRed:0 green:0.67 blue:0.65 alpha:1]];
    [[UITextView appearance] setTintColor:[UIColor colorWithRed:0 green:0.67 blue:0.65 alpha:1]];
}

- (void)loadHeaderView {
    headerView = [[[NSBundle mainBundle] loadNibNamed:@"RMStartPostingHeaderView" owner:nil options:nil] objectAtIndex:0];
    headerView.delegate = self;
    [self.view addSubview:headerView];
}

- (void)headerNavMethodWithTag:(NSInteger)tag {
    switch (tag) {
        case 1:{
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case 2:{
            NSLog(@"发布");
            break;
        }
            
        default:
            break;
    }
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
    self.mTextView.frame = CGRectMake(0, 99, kScreenWidth, kScreenHeight - 99 - 35 - size.height);
    self.mView.frame = CGRectMake(0, 99 + self.mTextView.frame.size.height, kScreenWidth, 35);
    self.mScrollView.frame = CGRectMake(0, self.mView.frame.size.height + self.mView.frame.origin.y, kScreenWidth, kScreenHeight - self.mView.frame.size.height - self.mView.frame.origin.y);
}

- (void)keyboardDidShow:(NSNotification *)noti {
    if (!isLoadUpLoadImg){
        CGFloat contentY = 0;
        
        for (NSInteger i=0; i<8; i++) {
            RMImageView * imageView = [[RMImageView alloc] init];
            imageView.frame = CGRectMake(0, 0, 100, 150);
            imageView.center = CGPointMake(20 + 50 + i * imageView.frame.size.width + i * 20, self.mScrollView.frame.size.height/2);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = LOADIMAGE(@"btn_add_photo_s", kImageTypePNG);
            [imageView addTarget:self WithSelector:@selector(addUpLoadImg:)];
            imageView.tag = 101 + i;
            imageView.identifierString = @"empty";
            [self.mScrollView addSubview:imageView];
            
            RMImageView * deleteImg = [[RMImageView alloc] init];
            deleteImg.tag = 201 + i;
            deleteImg.identifierString = @"empty";
            deleteImg.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width - 12, imageView.frame.origin.y - 5, 20, 20);
            [deleteImg addTarget:self WithSelector:@selector(deleteUpLoadImg:)];
            deleteImg.image = LOADIMAGE(@"deletecircular", kImageTypePNG);
            [self.mScrollView addSubview:deleteImg];
            
            [uploadImageArr addObject:imageView];
        }
        
        if (self.mScrollView.frame.size.height < 150){
            contentY = 150;
        }else{
            contentY = self.mScrollView.frame.size.height;
        }
        
        self.mScrollView.contentSize = CGSizeMake(120*8+20, contentY);
        
        isLoadUpLoadImg = YES;
    }
}

- (void)keyboardWillHide:(NSNotification *)noti {
}

- (void)keyboardDidHide:(NSNotification *)noti {
}

- (void)addUpLoadImg:(RMImageView *)image {
    NSLog(@"image.tag:%ld   state:%@",(long)image.tag,image.identifierString);
}

- (void)deleteUpLoadImg:(RMImageView *)image {
    image.identifierString = @"empty";
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

#pragma mark - DoImagePickerControllerDelegate

- (void)didCancelDoImagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE) {
        
        NSInteger value = 0;
        
//        for (NSInteger i=0; i<[aSelected count]; i++) {
//            RMImageView * image = uploadImageArr[i];
//            if ([image.identifierString isEqualToString:@"empry"]){
//                image.image = aSelected[value];
//            }else{
//                continue;
//            }
//        }
        
        
        
        
        for (int i = 0; i < MIN(8, aSelected.count); i++) {
            RMImageView *iv = uploadImageArr[i];
            iv.image = aSelected[i];
            iv.identifierString = @"full";
            NSLog(@"---AAAAA--%ld state:%@",(long)iv.tag,iv.identifierString);
            
            RMImageView * deleteImage = (RMImageView *)[self.mScrollView viewWithTag:100 + iv.tag];
            deleteImage.identifierString = @"full";
        }
        
        
        
        
    }else if(picker.nResultType == DO_PICKER_RESULT_ASSET) {
        for (int i = 0; i < MIN(8, aSelected.count); i++) {
            RMImageView *iv = uploadImageArr[i];
            iv.image = [ASSETHELPER getImageFromAsset:aSelected[i] type:ASSET_PHOTO_SCREEN_SIZE];
            NSLog(@"---BBBBB--%ld",(long)iv.tag);

        }
        [ASSETHELPER clearData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
