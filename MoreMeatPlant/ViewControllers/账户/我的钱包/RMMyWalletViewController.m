//
//  RMMyWalletViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/13.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMMyWalletViewController.h"
#import "RMMyWalletTransferTableViewCell.h"
#import "RMMyWalletYueTableViewCell.h"
@interface RMMyWalletViewController (){
    BOOL isShow;
}

@end

@implementation RMMyWalletViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    if (!isShow) {
        CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        CGFloat height = self.mTableView.contentSize.height;
        self.mTableView.contentSize = CGSizeMake(self.mTableView.frame.size.width, height + size.height);
        isShow = !isShow;
    }
}

- (void)keyboardWillHide:(NSNotification *)noti {
    if (isShow) {
        CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        CGFloat height = self.mTableView.contentSize.height;
        self.mTableView.contentSize = CGSizeMake(self.mTableView.frame.size.width, height - size.height);
        isShow = !isShow;
    }
}

- (void)keyboardDidShow:(NSNotification *)noti {
    
}

- (void)keyboardDidHide:(NSNotification *)noti {
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:NO];
}

#pragma mark - UITableVIewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        RMMyWalletYueTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMMyWalletYueTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMMyWalletYueTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else{
        RMMyWalletTransferTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMMyWalletTransferTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMMyWalletTransferTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 133.f;
    }
    else{
        return 334.f;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
