//
//  RMSearchViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/18.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMSearchViewController.h"
#import "RMDaqoCell.h"
#import "UITextField+LimitLength.h"

@interface RMSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,DaqpSelectedPlantTypeDelegate>{
    BOOL isHideKeyboard;
    
}
@property (nonatomic, strong) NSMutableArray * dataArr;

@end

@implementation RMSearchViewController
@synthesize mTextField, mTableView, dataArr;

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.mTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[RMSearchViewController class]];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[RMSearchViewController class]];

    dataArr = [[NSMutableArray alloc] init];
    mTextField.delegate = self;
    [mTextField.layer setCornerRadius:8.0f];
    mTextField.returnKeyType = UIReturnKeySearch;
    [mTextField limitTextLength:20];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifierStr = @"ReSearchIdentifier";
    RMDaqoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (!cell){
        if (IS_IPHONE_6p_SCREEN) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoCell_6p" owner:self options:nil] lastObject];
        }else if (IS_IPHONE_6_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoCell_6" owner:self options:nil] lastObject];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMDaqoCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)daqoSelectedPlantTypeMethod:(RMImageView *)image {
    NSLog(@"点击 搜索 图片");
}

#pragma mark -

- (void)keyboardWillShow:(NSNotification *)noti {
}

- (void)keyboardDidShow:(NSNotification *)noti {
}

- (void)keyboardWillHide:(NSNotification *)noti {
}

- (void)keyboardDidHide:(NSNotification *)noti {

}

- (IBAction)searchClick:(UIButton *)sender {
    NSLog(@"搜索 %@",mTextField.text);
}

#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [mTextField resignFirstResponder];
}

- (IBAction)buttonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求数据

- (void)request {
    
}

@end
