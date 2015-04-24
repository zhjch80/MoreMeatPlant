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

@interface RMStartLongPostingViewController ()<UITableViewDataSource,UITableViewDelegate,StartLongPostingDelegate,EditContentDelegate,LongPostFooterDelegate> {
    NSInteger cellTextCount;        //section 为2时 总共有几行文字cell
    NSInteger cellImgCount;         //section 为2时 总共有几行图片cell
    NSInteger cellRow;              //记录内容的行数
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSArray * headerTitleArr;                 //header title arr
@property (nonatomic, strong) NSMutableArray * typeIdentifierArr;       //文字 图片cell标识 text img
@property (nonatomic, strong) NSMutableArray * dataArr;

@property (nonatomic, strong) ZFModalTransitionAnimator * animator;
@property (nonatomic, strong) RMLongPostFooterView * footerView;

@end

@implementation RMStartLongPostingViewController
@synthesize mTableView, headerTitleArr, animator, footerView, typeIdentifierArr, dataArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    cellTextCount = 0;
    cellImgCount = 0;
    cellRow = 0;
    
    typeIdentifierArr = [[NSMutableArray alloc] init];
    dataArr = [[NSMutableArray alloc] init];
    
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
    NSLog(@"section:%ld,row:%ld",(long)section,(long)row);
    if (type == 201){
        //文字
        RMEditContentViewController * editContentCtl = [[RMEditContentViewController alloc] init];
        editContentCtl.delegate = self;
        editContentCtl.modalPresentationStyle = UIModalPresentationCustom;
        animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:editContentCtl];
        
//        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:cellRow inSection:2];
//        RMStartLongPostingCell * cell = (RMStartLongPostingCell *)[mTableView cellForRowAtIndexPath:indexPath];

//        editContentCtl.text = cell.textContent.text;
        
        editContentCtl.sectionTag = 2;
        editContentCtl.rowTag = cellRow;        //将要在此行增加文字,也是新增加的行
        editContentCtl.mTitle = @"内容";
        animator.dragable = NO;
        animator.bounces = NO;
        animator.behindViewAlpha = 0.5f;
        animator.behindViewScale = 0.5f;
        animator.transitionDuration = 0.7f;
        animator.direction = ZFModalTransitonDirectionLeft;
        editContentCtl.transitioningDelegate = animator;
        [self presentViewController:editContentCtl animated:YES completion:nil];
    }else{
        //图片
        NSLog(@"图片 section::%ld, row:%ld type:%ld",(long)section,(long)row,(long)type);
        
        cellImgCount ++;
        [typeIdentifierArr addObject:@"img"];
    }
}

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
    RMStartLongPostingCell * cell = (RMStartLongPostingCell *)[mTableView cellForRowAtIndexPath:indexPath];
    NSLog(@"at row:%ld,cell.contentIdentifier:%@",(long)indexPath.row,cell.contentIdentifier);
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
 */
- (void)getEditContent:(NSString *)content
        withSectionTag:(NSInteger)section
            withRowTag:(NSInteger)row {
    
    if (section == 1){
        //标题
        if (content.length == 0 && section == 1){
        }else{
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            RMStartLongPostingCell * cell = (RMStartLongPostingCell *)[mTableView cellForRowAtIndexPath:indexPath];
            cell.editTitleDisplay.text = content;
            cell.editTitleBtn.backgroundColor = [UIColor clearColor];
            [cell.editTitleBtn setTitle:@"" forState:UIControlStateNormal];
        }
    }else{
        //内容
        if (content.length == 0){
            NSLog(@"字符串为空");
        }else{
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            RMStartLongPostingCell * cell = (RMStartLongPostingCell *)[mTableView cellForRowAtIndexPath:indexPath];
            [cell adjustsTextContentFrameWithText:content];
            
            [dataArr addObject:content];
            
            cellTextCount ++;
            cellRow ++;
            [typeIdentifierArr addObject:@"text"];
            [mTableView reloadData];
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
            NSLog(@"发布");
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
