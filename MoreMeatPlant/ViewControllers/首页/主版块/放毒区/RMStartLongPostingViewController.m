//
//  RMStartLongPostingViewController.m
//  MoreMeatPlant
//
//  Created by mobei on 15/4/23.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMStartLongPostingViewController.h"
#import "RMStartLongPostingCell.h"
#import "RMEditContentViewController.h"
#import "ZFModalTransitionAnimator.h"
#import "RMLongPostFooterView.h"
#import "FileUtil.h"

@interface RMStartLongPostingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,StartLongPostingDelegate,EditContentDelegate,LongPostFooterDelegate> {
    NSInteger cellTextCount;        //section 为2时 总共有几行文字cell
    NSInteger cellImgCount;         //section 为2时 总共有几行图片cell
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSArray * headerTitleArr;                 //header title arr
@property (nonatomic, strong) NSMutableArray * typeIdentifierArr;       //文字 图片cell标识 text img
@property (nonatomic, strong) NSMutableArray * dataArr;

@property (nonatomic, strong) ZFModalTransitionAnimator * animator;
@property (nonatomic, strong) RMLongPostFooterView * footerView;

@property (nonatomic, copy) NSString * titleContent;                //保存帖子标题
@property (nonatomic, assign) NSInteger cellRow;                    //记录内容的行数
@property (nonatomic, assign) NSInteger willOperationCellRow;       //点击cell 将要操作的行数
@property (nonatomic, assign) BOOL isInsertImage;                   //是否插入图片
@property (nonatomic, assign) BOOL isReplaceImage;                  //是否替换图片

@end

@implementation RMStartLongPostingViewController
@synthesize mTableView, headerTitleArr, animator, footerView, typeIdentifierArr, dataArr, titleContent, cellRow, willOperationCellRow, isInsertImage, isReplaceImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    cellTextCount = 0;
    cellImgCount = 0;
    cellRow = 0;
    willOperationCellRow = 0;
    
    typeIdentifierArr = [[NSMutableArray alloc] init];
    dataArr = [[NSMutableArray alloc] init];
    titleContent = @"";
    
    headerTitleArr = [[NSArray alloc] initWithObjects:@"发帖说明", @"帖子标题", @"帖子内容", nil];
    
    [self setCustomNavBackgroundColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1] withStatusViewBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [self setCustomNavTitle:[NSString stringWithFormat:@"发帖(%@)",self.model_1.label]];
    [self setRightBarButtonNumber:1];
    
    [leftBarButton setTitle:@"取消" forState:UIControlStateNormal];
    leftBarButton.frame = CGRectMake(10, 0, 50, 44);
    [leftBarButton setTitleColor:[UIColor colorWithRed:0 green:0.62 blue:0.59 alpha:1] forState:UIControlStateNormal];
    [rightOneBarButton setTitle:@"发布" forState:UIControlStateNormal];
    rightOneBarButton.frame = CGRectMake(kScreenWidth - 60, 0, 50, 44);
    [rightOneBarButton setTitleColor:[UIColor colorWithRed:0 green:0.62 blue:0.59 alpha:1] forState:UIControlStateNormal];

    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
    
    [self laodFooterView];
}

- (void)laodFooterView {
    footerView = [[[NSBundle mainBundle] loadNibNamed:@"RMLongPostFooterView" owner:nil options:nil] objectAtIndex:0];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    [footerView.addTextBtn.layer setCornerRadius:5.0f];
    [footerView.addImgBtn.layer setCornerRadius:5.0];
    footerView.addTextBtn.section = 2;
    footerView.addTextBtn.row = cellRow;
    footerView.addImgBtn.section = 2;
    footerView.addImgBtn.row = cellRow;
    footerView.delegate = self;
    mTableView.tableFooterView = footerView;
}

/**
 *  @method 添加 文字或图片
 *  @param      section     哪一组
 *  @param      row         哪一行
 *  @param      type        类型 发文字 或者 发图片
 */
- (void)addSomeContentWithSection:(NSInteger)section
                          withRow:(NSInteger)row
                         withType:(NSInteger)type {
    if (type == 201){
        //添加文字
        RMEditContentViewController * editContentCtl = [[RMEditContentViewController alloc] init];
        editContentCtl.delegate = self;
        editContentCtl.modalPresentationStyle = UIModalPresentationCustom;
        animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:editContentCtl];
        
        editContentCtl.sectionTag = 2;
        editContentCtl.rowTag = cellRow;        //将要在此行增加文字,也是新增加的行
        editContentCtl.mTitle = @"内容";
        editContentCtl.operationType = @"添加内容";
        editContentCtl.operationStr = @"添加";
        
        animator.dragable = NO;
        animator.bounces = NO;
        animator.behindViewAlpha = 0.5f;
        animator.behindViewScale = 0.5f;
        animator.transitionDuration = 0.7f;
        animator.direction = ZFModalTransitonDirectionLeft;
        editContentCtl.transitioningDelegate = animator;
        [self presentViewController:editContentCtl animated:YES completion:nil];
    }else{
        //添加图片
        if (cellImgCount >= 8){
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"图片已经8张啦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        UIActionSheet *sheet = nil;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
        }else{
            sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        }
        sheet.tag = 301;
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (actionSheet.tag) {
        case 301:{
            //添加图片
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
            [self presentViewController:imagePickerController animated:YES completion:^{
            }];
            break;
        }
        case 302:{
            //编辑文字
            switch (buttonIndex) {
                case 0:{
                    //修改本段文字
                    RMEditContentViewController * editContentCtl = [[RMEditContentViewController alloc] init];
                    editContentCtl.delegate = self;
                    editContentCtl.modalPresentationStyle = UIModalPresentationCustom;
                    animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:editContentCtl];
                    
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:willOperationCellRow inSection:2];
                    RMStartLongPostingCell * cell = (RMStartLongPostingCell *)[mTableView cellForRowAtIndexPath:indexPath];
                    
                    editContentCtl.mTitle = @"内容";
                    editContentCtl.operationType = @"修改文字";
                    editContentCtl.operationStr = @"修改";
                    editContentCtl.operationCellRow = willOperationCellRow;
                    editContentCtl.text = cell.textContent.text;
                    
                    animator.dragable = NO;
                    animator.bounces = NO;
                    animator.behindViewAlpha = 0.5f;
                    animator.behindViewScale = 0.5f;
                    animator.transitionDuration = 0.7f;
                    animator.direction = ZFModalTransitonDirectionLeft;
                    editContentCtl.transitioningDelegate = animator;
                    [self presentViewController:editContentCtl animated:YES completion:nil];
                    break;
                }
                case 1:{
                    //删除本段文字
                    [dataArr removeObjectAtIndex:willOperationCellRow];
                    [typeIdentifierArr removeObjectAtIndex:willOperationCellRow];
                    cellTextCount -- ;
                    cellRow --;
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:willOperationCellRow inSection:2];
                    [mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
                    break;
                }
                case 2:{
                    //在下面插入图片
                    if (cellImgCount >= 8){
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"图片已经8张啦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                        return ;
                    }
                    UIActionSheet *sheet = nil;
                    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
                    }else{
                        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
                    }
                    sheet.tag = 301;
                    [sheet showInView:self.view];
                    isInsertImage = YES;
                    break;
                }
                case 3:{
                    //在下面插入文字
                    RMEditContentViewController * editContentCtl = [[RMEditContentViewController alloc] init];
                    editContentCtl.delegate = self;
                    editContentCtl.modalPresentationStyle = UIModalPresentationCustom;
                    animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:editContentCtl];
                    
                    editContentCtl.mTitle = @"内容";
                    editContentCtl.operationType = @"插入文字";
                    editContentCtl.operationStr = @"插入";
                    editContentCtl.operationCellRow = willOperationCellRow+1;         //将要在此行的下一行插入文字

                    animator.dragable = NO;
                    animator.bounces = NO;
                    animator.behindViewAlpha = 0.5f;
                    animator.behindViewScale = 0.5f;
                    animator.transitionDuration = 0.7f;
                    animator.direction = ZFModalTransitonDirectionLeft;
                    editContentCtl.transitioningDelegate = animator;
                    [self presentViewController:editContentCtl animated:YES completion:nil];
                    break;
                }
                case 4:{
                    //取消
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 303:{
            //编辑图片
            switch (buttonIndex) {
                case 0:{
                    //替换图片
                    UIActionSheet *sheet = nil;
                    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
                    }else{
                        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
                    }
                    sheet.tag = 301;
                    [sheet showInView:self.view];
                    isReplaceImage = YES;
                    break;
                }
                case 1:{
                    //删除图片
                    [dataArr removeObjectAtIndex:willOperationCellRow];
                    [typeIdentifierArr removeObjectAtIndex:willOperationCellRow];
                    cellRow --;
                    cellImgCount --;
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:willOperationCellRow inSection:2];
                    [mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
                    break;
                }
                case 2:{
                    //在下面插入图片
                    if (cellImgCount >= 8){
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"图片已经8张啦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                        return ;
                    }
                    UIActionSheet *sheet = nil;
                    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
                    }else{
                        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
                    }
                    sheet.tag = 301;
                    [sheet showInView:self.view];
                    isInsertImage = YES;
                    break;
                }
                case 3:{
                    //在下面插入文字
                    RMEditContentViewController * editContentCtl = [[RMEditContentViewController alloc] init];
                    editContentCtl.delegate = self;
                    editContentCtl.modalPresentationStyle = UIModalPresentationCustom;
                    animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:editContentCtl];
                    
                    editContentCtl.mTitle = @"内容";
                    editContentCtl.operationType = @"插入文字";
                    editContentCtl.operationStr = @"插入";
                    editContentCtl.operationCellRow = willOperationCellRow+1;         //将要在此行的下一行插入文字
                    
                    animator.dragable = NO;
                    animator.bounces = NO;
                    animator.behindViewAlpha = 0.5f;
                    animator.behindViewScale = 0.5f;
                    animator.transitionDuration = 0.7f;
                    animator.direction = ZFModalTransitonDirectionLeft;
                    editContentCtl.transitioningDelegate = animator;
                    [self presentViewController:editContentCtl animated:YES completion:nil];
                    break;
                }
                case 4:{
                    //取消
                    
                    break;
                }
                default:
                    break;
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
    UIImage* image = nil;
    image = [info objectForKey: UIImagePickerControllerEditedImage];
    NSData * data = UIImageJPEGRepresentation(image, 0.5);
    image = [UIImage imageWithData:data];
    
    if (isInsertImage){
        //插入
        [dataArr insertObject:image atIndex:willOperationCellRow + 1];
        [typeIdentifierArr insertObject:@"img" atIndex:willOperationCellRow + 1];
        cellRow ++;
        cellImgCount ++;
        [mTableView reloadData];
    }else if (isReplaceImage){
        //替换
        [dataArr removeObjectAtIndex:willOperationCellRow];
        [dataArr insertObject:image atIndex:willOperationCellRow];
        [mTableView reloadData];
    }else{
        //添加
        [dataArr addObject:image];
        [typeIdentifierArr addObject:@"img"];
        cellRow ++;
        cellImgCount ++;
        [mTableView reloadData];
    }
    
    isReplaceImage = NO;
    isInsertImage = NO;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [headerTitleArr objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [headerTitleArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 | section == 1) {
        return 1;
    }else{
        return cellTextCount + cellImgCount;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        static NSString * cellIdentifier = @"StartLongPostingIdentifier_1";
        RMStartLongPostingCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            if (IS_IPHONE_6p_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMStartLongPostingCell_1" owner:self options:nil] lastObject];
            }else if (IS_IPHONE_6_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMStartLongPostingCell_1" owner:self options:nil] lastObject];
            }else{
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMStartLongPostingCell_1" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }else if (indexPath.section == 1){
        static NSString * cellIdentifier = @"StartLongPostingIdentifier_2";
        RMStartLongPostingCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            if (IS_IPHONE_6p_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMStartLongPostingCell_2" owner:self options:nil] lastObject];
            }else if (IS_IPHONE_6_SCREEN){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMStartLongPostingCell_2" owner:self options:nil] lastObject];
            }else{
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RMStartLongPostingCell_2" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
        }
        if ([titleContent isEqualToString:@""]){
            //标题无内容
            cell.editTitleBtn.backgroundColor = [UIColor colorWithRed:0.27 green:0.6 blue:0.3 alpha:1];
            [cell.editTitleBtn setTitle:@"请写帖子标题" forState:UIControlStateNormal];
            cell.editTitleDisplay.backgroundColor = [UIColor clearColor];
        }else{
            //标题有内容
            cell.editTitleBtn.backgroundColor = [UIColor clearColor];
            [cell.editTitleBtn setTitle:@"" forState:UIControlStateNormal];
            cell.editTitleDisplay.text = titleContent;
        }
        return cell;
    }else{
        static NSString * cellIdentifier = @"StartLongPostingIdentifier_3";
        RMStartLongPostingCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            if ([[typeIdentifierArr objectAtIndex:indexPath.row] isEqualToString:@"text"]){
                //文字 cell
                if (IS_IPHONE_6p_SCREEN){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"RMStartLongPostingCell_3" owner:self options:nil] lastObject];
                }else if (IS_IPHONE_6_SCREEN){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"RMStartLongPostingCell_3" owner:self options:nil] lastObject];
                }else{
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"RMStartLongPostingCell_3" owner:self options:nil] lastObject];
                }
            }else{
                //图片 cell
                if (IS_IPHONE_6p_SCREEN){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"RMStartLongPostingCell_4" owner:self options:nil] lastObject];
                }else if (IS_IPHONE_6_SCREEN){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"RMStartLongPostingCell_4" owner:self options:nil] lastObject];
                }else{
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"RMStartLongPostingCell_4" owner:self options:nil] lastObject];
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        
        if ([[typeIdentifierArr objectAtIndex:indexPath.row] isEqualToString:@"text"]){
            [cell adjustsTextContentFrameWithText:[dataArr objectAtIndex:indexPath.row]];
            cell.contentIdentifier = @"text";
        }else{            
            [cell adjustsImageContentFrameWithImage:[dataArr objectAtIndex:indexPath.row]];
            cell.contentIdentifier = @"image";
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 | indexPath.section == 1){
        return ;
    }
    
    RMStartLongPostingCell * cell = (RMStartLongPostingCell *)[mTableView cellForRowAtIndexPath:indexPath];
    UIActionSheet * sheet = nil;
    if ([cell.contentIdentifier isEqualToString:@"text"]){
        //编辑文字
        sheet  = [[UIActionSheet alloc] initWithTitle:@"编辑文字" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改本段文字", @"删除本段文字", @"在下面插入图片", @"在下面插入文字", nil];
        sheet.tag = 302;
    }else{
        //编辑图片
        sheet  = [[UIActionSheet alloc] initWithTitle:@"编辑图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"替换图片", @"删除图片", @"在下面插入图片", @"在下面插入文字", nil];
        sheet.tag = 303;
    }
    willOperationCellRow = indexPath.row;       // 将要操作cell 的行数
    [sheet showInView:self.view];
}

/**
 *  @method     编辑标题
 */
- (void)editingContentWithTag:(NSInteger)tag {
    RMEditContentViewController * editContentCtl = [[RMEditContentViewController alloc] init];
    editContentCtl.delegate = self;
    editContentCtl.modalPresentationStyle = UIModalPresentationCustom;
    animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:editContentCtl];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    RMStartLongPostingCell * cell = (RMStartLongPostingCell *)[mTableView cellForRowAtIndexPath:indexPath];
    
    editContentCtl.mTitle = @"标题";
    editContentCtl.operationType = @"添加标题";
    editContentCtl.operationStr = @"添加";
    editContentCtl.sectionTag = 1;
    editContentCtl.rowTag = 0;
    editContentCtl.text = cell.editTitleDisplay.text;
    
    animator.dragable = NO;
    animator.bounces = NO;
    animator.behindViewAlpha = 0.5f;
    animator.behindViewScale = 0.5f;
    animator.transitionDuration = 0.7f;
    animator.direction = ZFModalTransitonDirectionLeft;
    editContentCtl.transitioningDelegate = animator;
    [self presentViewController:editContentCtl animated:YES completion:nil];
}

/**
 *  @method     获取标题 及 内容的文字
 *  @param      content                     编辑的内容
 *  @param      section                     组
 *  @param      row                         行
 *  @param      operationType               将要操作的类型（修改、删除、插入文字、插入图片、取消、添加标题、添加内容）
 *  @param      operationRow                操作的行数
 */
- (void)getEditContent:(NSString *)content
        withSectionTag:(NSInteger)section
            withRowTag:(NSInteger)row
     withOperationType:(NSString *)operationType
  withOperationCellRow:(NSInteger)operationRow {
    if (section == 1){
        //标题
        if (content.length == 0 && section == 1){
        }else{
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            RMStartLongPostingCell * cell = (RMStartLongPostingCell *)[mTableView cellForRowAtIndexPath:indexPath];
            cell.editTitleDisplay.text = content;
            cell.editTitleBtn.backgroundColor = [UIColor clearColor];
            [cell.editTitleBtn setTitle:@"" forState:UIControlStateNormal];
            titleContent = content;
        }
    }else{
        //内容
        if ([operationType isEqualToString:@"取消"]){
            
            return ;
        }
 
        if (content.length == 0){
            NSLog(@"字符串为空");
        }else{
            if ([operationType isEqualToString:@"添加内容"]){
                [dataArr addObject:content];
                cellTextCount ++;
                cellRow ++;
                [typeIdentifierArr addObject:@"text"];
                [mTableView reloadData];
            }else if ([operationType isEqualToString:@"修改文字"]){
                [dataArr removeObjectAtIndex:operationRow];
                [dataArr insertObject:content atIndex:operationRow];
                [mTableView reloadData];
            }else if ([operationType isEqualToString:@"插入文字"]){
                [dataArr insertObject:content atIndex:operationRow];
                cellTextCount ++;
                cellRow ++;
                [typeIdentifierArr addObject:@"text"];
                [mTableView reloadData];
            }else {
                NSLog(@"获取标题 及 内容的文字 other error");
            }
        }
    }
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case 2:{
            //发布
            
            if ([[self trim:titleContent] isEqualToString:@""]){
                [self showHint:@"请填写一个标题吧"];
                return ;
            }
            
            if (cellRow==0){
                [self showHint:@"请填写一点内容吧"];
                return ;
            }
            
            [self requestCommentData];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 数据提交

- (void)requestCommentData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary * content_bodys = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * content_imgs = [[NSMutableDictionary alloc] init];
    
    BOOL isSeparated = NO;
    
    for (NSInteger i=0; i<cellRow; i++) {
        if ([[typeIdentifierArr objectAtIndex:i] isEqualToString:@"text"]){
            
//            if (i==0){
//                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//
//                NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
//                
//                NSString * img_str = [basePath  stringByAppendingPathComponent:@"transparent_img.jpg"];
//                
//                [content_imgs addObject:img_str];
//            }
            
//            NSString * str = [dataArr objectAtIndex:i];
//            
//            if (isSeparated){ //替换
//                NSString * str_1 = [content_bodys lastObject];
//                [content_bodys removeLastObject];
//                [content_bodys addObject:[NSString stringWithFormat:@"%@\n%@",str_1,str]];
//            }else{  //追加
//                [content_bodys addObject:str];
//            }
//            
//            isSeparated = YES;
             NSString * str = [dataArr objectAtIndex:i];
            [content_bodys setValue:str forKey:[NSString stringWithFormat:@"frm[body][%ld][content_body]",i]];
        }else{
            
            UIImage * uploadImage = [dataArr objectAtIndex:i];
            
            NSData * data = UIImageJPEGRepresentation(uploadImage, 0.5);
            
            [self saveImage:[UIImage imageWithData:data] withName:[NSString stringWithFormat:@"uploadLongImage_%ld.jpg",(long)i]];
            
            NSString *fullPath = [[FileUtil getCachePathFor:@"uploadLongImageCache"] stringByAppendingPathComponent:[NSString stringWithFormat:@"uploadLongImage_%ld.jpg",(long)i]];
            NSURL * filePath = [NSURL fileURLWithPath:fullPath];
            [content_imgs setValue:filePath forKey:[NSString stringWithFormat:@"frm[body][%ld][content_img]",i]];
            
//            if (i+1 == cellRow){    //追加空文字
//                [content_bodys addObject:@""];
//            }
//            
//            isSeparated = NO;
        }
    }
    
    [RMAFNRequestManager postSendLongPostsWithAuto_id:@"" withContentName:titleContent withContentType:@"1" withContentClass:self.model_1.value withContentCourse:self.model_2.auto_code withContentBody:content_bodys withContentImg:content_imgs withBodyAuto_id:@"" withID:[RMUserLoginInfoManager loginmanager].user withPWD:[RMUserLoginInfoManager loginmanager].pwd callBack:^(NSError *error, BOOL success, id object) {

        if (error){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"%@",error);
            return ;
        }
        
        if (success){
            [self showHint:[object objectForKey:@"msg"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
            [self showHint:[object objectForKey:@"msg"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *path = [[FileUtil getCachePathFor:@"uploadLongImageCache"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:path atomically:NO];
}

//校对字符串是否为空
- (NSString *)trim:(NSString *)str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
