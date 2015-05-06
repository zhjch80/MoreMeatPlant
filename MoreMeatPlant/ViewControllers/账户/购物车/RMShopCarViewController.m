//
//  RMShopCarViewController.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/9.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMShopCarViewController.h"
#import "RMShopCarGoodsTableViewCell.h"
#import "RMSopCarHeadTableViewCell.h"
#import "RMShopLeaveMsTableViewCell.h"

#import "RMSettlementViewController.h"
#import "UIViewController+ENPopUp.h"

#import "RMAddressEditViewController.h"
#import "RMMyCorpViewController.h"
#import "UIView+Expland.h"
#import "UIAlertView+Expland.h"
#import "RMAliPayViewController.h"
#import "AppDelegate.h"
#import "RMMyOrderViewController.h"
@interface RMShopCarViewController ()<RMAddressEditViewCompletedDelegate>{
    BOOL isShow;
    __block RMSettlementViewController * settle;
    NSMutableArray * dataArray;
    NSString * defaultNumber;//用户点击textfield输入前的值
    RMPublicModel * parameterModel;//提交订单
}

@end


@implementation RMShopCarViewController

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self caculateProductTotal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initPlat];
}

- (void)initPlat{
    [self setCustomNavTitle:@"购物篮"];
    
    parameterModel = [[RMPublicModel alloc]init];
    parameterModel.payment_id = @"1";
    
    
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    _mTableView.backgroundColor = [UIColor clearColor];
    _mTableView.opaque = NO;
    [_settleBtn addTarget:self action:@selector(settlementAction:) forControlEvents:UIControlEventTouchDown];
}


- (void)caculateProductTotal
{
    float n = 0;
    if(!dataArray){
        dataArray = [[NSMutableArray alloc] init];
    }
    [dataArray removeAllObjects];
    NSArray * merchants = [RMCorpModel allDbObjects];
    if([merchants count]==0)
    {
        _all_total_moneyL.text = [NSString stringWithFormat:@"¥%d",0];
    }
    for(RMCorpModel * shop in merchants)
    {
        float express_price = 0;
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        [dic setValue:shop.corp_id forKey:@"corp_id"];
        [dic setValue:shop.corp_name forKey:@"corp_name"];
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        for(RMProductModel * p in [RMProductModel dbObjectsWhere:[NSString stringWithFormat:@"corp_id=%@",shop.corp_id] orderby:@"corp_id"])
        {
            [arr addObject:p];
            n+= [p.content_price floatValue]*p.content_num;
            express_price = [p.express_price floatValue];
        }
        
        n += express_price;
        
        _all_total_moneyL.text = [NSString stringWithFormat:@"¥%.2f",n];
        if([arr count]!=0)
        {
            [dic setObject:arr forKey:@"products"];
            [dataArray addObject:dic];
        }
        
    }
    
    [_mTableView reloadData];
}

- (float)caculateSection:(NSIndexPath *)indexpath{
    float n = 0;
    float express_price = 0;
    for(RMProductModel * product in [[dataArray objectAtIndex:indexpath.section] objectForKey:@"products"]){
        n += product.content_num * [product.content_price floatValue];
        express_price = [product.express_price floatValue];
    }
    n += express_price;
    return n;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[dataArray objectAtIndex:section] objectForKey:@"products"] count]+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        RMSopCarHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMSopCarHeadTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMSopCarHeadTableViewCell" owner:self options:nil] lastObject];
            [cell.corpNameL addTarget:self action:@selector(goCorpAction:) forControlEvents:UIControlEventTouchDown];
        }
        cell.corpNameL.tag = 1000*indexPath.section;
        NSDictionary * dic = [dataArray objectAtIndex:indexPath.section];
        [cell.corpNameL setTitle:[dic objectForKey:@"corp_name"] forState:UIControlStateNormal];
        return cell;
    }else if(indexPath.row == [[[dataArray objectAtIndex:indexPath.section] objectForKey:@"products"] count]+1){
        RMShopLeaveMsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMShopLeaveMsTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMShopLeaveMsTableViewCell" owner:self options:nil] lastObject];
            [cell.contactCorpBtn addTarget:self action:@selector(contactCorpAction:) forControlEvents:UIControlEventTouchDown];
            cell.leaveMessageT.delegate = self;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:cell.leaveMessageT];
        }
        cell.leaveMessageT.tag = indexPath.section*10+1;
        cell.contactCorpBtn.tag = indexPath.section*1000+indexPath.row;
        
        RMCorpModel * corpmodel = [[RMCorpModel dbObjectsWhere:[NSString stringWithFormat:@"corp_id=%@",[(RMProductModel *)[[[dataArray objectAtIndex:indexPath.section] objectForKey:@"products"] objectAtIndex:0] corp_id]] orderby:nil] lastObject];
        
        cell.leaveMessageT.text = [corpmodel order_message];
        
//        cell.totalMoneyL.text = [NSString stringWithFormat:@"%.0f",[self caculateSection:indexPath]];
        cell.express_price.text = [NSString stringWithFormat:@"(含运费%@)",[(RMProductModel *)[[[dataArray objectAtIndex:indexPath.section] objectForKey:@"products"] objectAtIndex:0] express_price]];
        cell.totalL.text = [NSString stringWithFormat:@"%.0f",[self caculateSection:indexPath]];
        int n = 0;
        for(RMProductModel * model in [[dataArray objectAtIndex:indexPath.section] objectForKey:@"products"]){
            n+=model.content_num;
        }
        cell.numL.text = [NSString stringWithFormat:@"%d",n];
        return cell;
    }else{
        RMShopCarGoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RMShopCarGoodsTableViewCell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMShopCarGoodsTableViewCell" owner:self options:nil] lastObject];
            [cell.addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchDown];
            [cell.subBtn addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchDown];
            [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchDown];
            cell.numTextField.delegate = self;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:cell.numTextField];
        }
        cell.deleteBtn.tag = 100000*indexPath.section+indexPath.row;
        cell.numTextField.tag = 3000*indexPath.section+indexPath.row;
        cell.addBtn.tag = 1000*indexPath.section+indexPath.row;
        cell.subBtn.tag = 1000*indexPath.section+indexPath.row+1;
        RMProductModel * product = [[[dataArray objectAtIndex:indexPath.section] objectForKey:@"products"] objectAtIndex:indexPath.row-1];
        [cell.content_imgV sd_setImageWithURL:[NSURL URLWithString:product.content_img] placeholderImage:[UIImage imageNamed:@"nophote"]];
        cell.content_titleL.text = product.content_name;
        cell.content_priceL.text = product.content_price;
        cell.numTextField.text = [NSString stringWithFormat:@"%ld",(long)product.content_num];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 30;
    }else if (indexPath.row == [[[dataArray objectAtIndex:indexPath.section] objectForKey:@"products"] count]+1){
        return 106;
    }else{
        return 77;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}




#pragma mark - 进入店铺
- (void)goCorpAction:(UIButton *)sender{
    NSInteger tag = sender.tag/1000;
    RMMyCorpViewController * corp = [[RMMyCorpViewController alloc]initWithNibName:@"RMMyCorpViewController" bundle:nil];
    RMProductModel * product = [[[dataArray objectAtIndex:tag]  objectForKey:@"products"] lastObject];
    corp.auto_id = product.corp_id;
    [self.navigationController pushViewController:corp animated:YES];
}

- (RMShopCarGoodsTableViewCell *)getShopCell:(NSInteger)section and:(NSInteger)row
{
    RMShopCarGoodsTableViewCell * cell = (RMShopCarGoodsTableViewCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    return cell;
}
#pragma mark - 购物车商品数量的增减
- (void)addAction:(UIButton *)sender{
//    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:sender.tag%1000 inSection:sender.tag/1000];
//    RMShopCarGoodsTableViewCell * cell = (RMShopCarGoodsTableViewCell *)[_mTableView cellForRowAtIndexPath:indexpath];
//    NSInteger num = [cell.numTextField.text integerValue];
//    num++;
//    cell.numTextField.text = [NSString stringWithFormat:@"%ld",(long)num];
    RMProductModel * model = [[[dataArray objectAtIndex:sender.tag/1000] objectForKey:@"products"] objectAtIndex:sender.tag%1000-1];
    if([model.plante isEqualToString:@"1"]){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"一肉一拍区的宝贝只能选择一个哦！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    
    NSInteger section = sender.tag/1000;
    NSInteger row = sender.tag%1000;
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:row inSection:section];
    RMShopCarGoodsTableViewCell * cell = [self getShopCell:indexpath.section and:indexpath.row];
    NSInteger n = [cell.numTextField.text integerValue];
    defaultNumber = cell.numTextField.text ;
    [self validationAction:indexpath andN:++n];
}

- (void)validationAction:(NSIndexPath *)indexpath andN:(NSInteger)num{
    
    RMProductModel * product = [[[dataArray objectAtIndex:indexpath.section] objectForKey:@"products"] objectAtIndex:indexpath.row-1];
    RMShopCarGoodsTableViewCell * cell = [self getShopCell:indexpath.section and:indexpath.row];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager valliateGoodsNumWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] auto_id:product.auto_id Nums:num andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if(success){
            RMPublicModel * model = object;
            if(model.status){
                RMProductModel * pro = [[RMProductModel alloc]init];
                pro.content_num = product.content_num;
                pro.auto_id = product.auto_id;
                if([RMProductModel existDbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",product.auto_id]])
                {
                    RMProductModel * product2 = [[RMProductModel dbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",product.auto_id] orderby:nil] lastObject];
                    product2.content_num = num;
                    [product2 updatetoDb];
                }
                else
                {
                    [pro insertToDb];
                }
                
                cell.numTextField.text = [NSString stringWithFormat:@"%ld",(long)num];
                [self caculateProductTotal];
            }else{
                cell.numTextField.text = defaultNumber;
            }
            [self showHint:model.msg];
        }else{
            [self showHint:object];
        }
    }];

}

- (void)subAction:(UIButton *)sender{
//    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:sender.tag%1000-1 inSection:sender.tag/1000];
//    RMShopCarGoodsTableViewCell * cell = (RMShopCarGoodsTableViewCell *)[_mTableView cellForRowAtIndexPath:indexpath];
//    NSInteger num = [cell.numTextField.text integerValue];
//    num--;
//    if(num == 0){
//        num = 1;
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"商品数量至少为一个" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
//        [alert show];
//    }
//    cell.numTextField.text = [NSString stringWithFormat:@"%ld",(long)num];
    
    NSInteger section = sender.tag/1000;
    NSInteger row = sender.tag%1000-1;
    RMShopCarGoodsTableViewCell * cell = [self getShopCell:section and:row];
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:row inSection:section];
    NSInteger n = [cell.numTextField.text integerValue];
    defaultNumber = cell.numTextField.text ;
    if(n == 1)
    {
        
    }
    else
    {
        [self validationAction:indexpath andN:--n];
    }

}

#pragma mark - 删除
- (void)deleteAction:(UIButton *)sender{
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:sender.tag%100000 inSection:sender.tag/100000];
    RMProductModel * product = [[[dataArray objectAtIndex:indexpath.section] objectForKey:@"products"] objectAtIndex:indexpath.row-1];
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要删除这个宝贝吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert handlerClickedButton:^(UIAlertView *alertView, NSInteger btnIndex) {
         if(btnIndex == 1){
             if( [RMProductModel removeDbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",product.auto_id]])
             {
           
                 if([RMProductModel dbObjectsWhere:[NSString stringWithFormat:@"corp_id=%@",product.corp_id] orderby:@"corp_id"] == nil)
                 {
                     [RMCorpModel removeDbObjectsWhere:[NSString stringWithFormat:@"corp_id=%@",product.corp_id] ];
                 }
             }
         }
        
        [self caculateProductTotal];
    }];
    [alert show];

}

#pragma mark - 联系卖家
- (void)contactCorpAction:(UIButton *)sender{
     NSIndexPath * indexpath = [NSIndexPath indexPathForRow:sender.tag%1000 inSection:sender.tag/1000];
    NSDictionary * dic = [dataArray objectAtIndex:sender.tag/1000];
    NSLog(@"联系卖家%@",indexpath);
    [self.navigationController popToRootViewControllerAnimated:NO];
    AppDelegate * dele = [[UIApplication sharedApplication] delegate];
    [dele tabSelectController:3];
    [dele.talkMoreCtl._chatListVC jumpToChatView:[(RMProductModel *)[[dic objectForKey:@"products"] objectAtIndex:0] corp_user]];
    NSLog(@"%@",[(RMProductModel *)[[dic objectForKey:@"products"] objectAtIndex:0] corp_user]);
}

#pragma mark - 结算
- (void)settlementAction:(UIButton *)sender{
    
    if(![[RMUserLoginInfoManager loginmanager] state]){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    
    if([dataArray count]== 0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"购物篮空空如也！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    __block RMShopCarViewController * SELF = self;
    settle = [[RMSettlementViewController alloc]initWithNibName:@"RMSettlementViewController" bundle:nil];
    
    settle.view.frame = CGRectMake(20, 60, kScreenWidth-20*2, kScreenHeight-60*2);
    [settle.titleView drawCorner:UIRectCornerTopLeft | UIRectCornerTopRight withFrame:CGRectMake(0, 0,kScreenWidth-20*2, kScreenHeight-60*2)];
    settle.callback = ^(void){
        [SELF dismissPopUpViewControllerWithcompletion:nil];
    };
    settle.settle_callback = ^(RMPublicModel * model){//支付宝网站支付
        [SELF commitOrderAction];
    };
    settle.editAddress_callback = ^(RMPublicModel * model_){
        RMAddressEditViewController * address_edit = [[RMAddressEditViewController alloc]initWithNibName:@"RMAddressEditViewController" bundle:nil];
        address_edit._model = [[RMPublicModel alloc]init];
        address_edit._model = model_;
        address_edit.delegate = SELF;
        
        [SELF.navigationController pushViewController:address_edit animated:YES];
    };
    settle.addAddress_callback = ^(void){
        RMAddressEditViewController * address_edit = [[RMAddressEditViewController alloc]initWithNibName:@"RMAddressEditViewController" bundle:nil];
        address_edit.delegate = SELF;
        [SELF.navigationController pushViewController:address_edit animated:YES];
    };
    settle.payment_callback = ^(NSString * payment_id){
        SELF->parameterModel.payment_id = payment_id;
    };
    settle.selectAddress_callback = ^ (RMPublicModel * model){
        SELF->parameterModel.content_linkname = model.contentName;
        SELF->parameterModel.content_mobile = model.contentMobile;
        SELF->parameterModel.content_address = model.contentAddress;
    };
    [self presentPopUpViewController:settle overlaybounds:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
}

#pragma mark - 提交订单
- (void)commitOrderAction{
    NSString * auto_id = @"";
    NSString * num = @"";
    NSString * express = @"";
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    for(NSDictionary *dic in dataArray){
        for(RMProductModel * model in [dic objectForKey:@"products"]){
            auto_id = [auto_id stringByAppendingString:[NSString stringWithFormat:@",%@",model.auto_id]];
            num = [num stringByAppendingString:[NSString stringWithFormat:@",%ld",(long)model.content_num]];
        }
        RMProductModel * lastmodel = [[dic objectForKey:@"products"] objectAtIndex:0];
        express = [express stringByAppendingString:[NSString stringWithFormat:@",%@",lastmodel.express]];
        
        RMCorpModel * corp = [[RMCorpModel dbObjectsWhere:[NSString stringWithFormat:@"corp_id=%@",[[[dic objectForKey:@"products"] objectAtIndex:0] corp_id]] orderby:nil] lastObject];
        [dict setValue:corp.order_message forKey:[NSString stringWithFormat:@"order_message[%@]",corp.corp_id]];
    }
    auto_id = [auto_id substringFromIndex:1];
    num = [num substringFromIndex:1];
    express = [express substringFromIndex:1];

    [dict setValue:auto_id forKey:@"auto_id"];
    [dict setValue:num forKey:@"num"];
    [dict setValue:parameterModel.payment_id forKey:@"frm[payment_id]"];
    [dict setValue:express forKey:@"express"];
    [dict setValue:parameterModel.content_linkname forKey:@"frm[content_linkname]"];
    [dict setValue:parameterModel.content_mobile forKey:@"frm[content_mobile]"];
    [dict setValue:parameterModel.content_address forKey:@"frm[content_address]"];
    NSLog(@"%@",dict);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager commitOrderWithUser:[[RMUserLoginInfoManager loginmanager] user] Pwd:[[RMUserLoginInfoManager loginmanager] pwd] withDic:dict andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            RMPublicModel * model = object;
            if(model.status){
//                if([parameterModel.payment_id isEqualToString:@"2"]){
//                    
//                }
                [settle dismissPopUpViewControllerWithcompletion:nil];
                
                if([model.is_redirect boolValue]){
                    RMAliPayViewController * alipay = [[RMAliPayViewController alloc]initWithNibName:@"RMAliPayViewController" bundle:nil];
                    alipay.is_direct = NO;
                    alipay.order_id = model.content_sn;//支付宝支付的订单号
                    [self.navigationController pushViewController:alipay animated:YES];
                }else{
                    //跳到订单列表
                    RMMyOrderViewController * order = [[RMMyOrderViewController alloc]initWithNibName:@"RMMyOrderViewController" bundle:nil];
                    [self.navigationController pushViewController:order animated:YES];
                }
                 [self dismissPopUpViewControllerWithcompletion:nil];
                
                for(RMProductModel * model in [RMProductModel allDbObjects]){
                    if( [RMProductModel removeDbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",model.auto_id]])
                    {
                        
                        if([RMProductModel dbObjectsWhere:[NSString stringWithFormat:@"corp_id=%@",model.corp_id] orderby:@"corp_id"] == nil)
                        {
                            [RMCorpModel removeDbObjectsWhere:[NSString stringWithFormat:@"corp_id=%@",model.corp_id] ];
                        }
                    }
                }
                
                
            }else{
            
            }
            [self showHint:model.msg];
        }else{
            [self showHint:object];
        }
    }];
}

#pragma mark - RMAddressEditDelegate
- (void)RMAddressEditViewCompleted{
    
    [settle requestAddresslist];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    switch (sender.tag) {
        case 1:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%@",[textField.superview superview]);
    if([[textField.superview superview] isKindOfClass:[RMShopCarGoodsTableViewCell class]]){
        defaultNumber = textField.text;
    }else if([[textField.superview superview] isKindOfClass:[RMShopLeaveMsTableViewCell class]]){
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if([[textField.superview superview] isKindOfClass:[RMShopCarGoodsTableViewCell class]]){

    }else if([[textField.superview superview] isKindOfClass:[RMShopLeaveMsTableViewCell class]]){
        NSDictionary * dic = [dataArray objectAtIndex:textField.tag/10];
        RMCorpModel * model = [[RMCorpModel dbObjectsWhere:[NSString stringWithFormat:@"corp_id=%@",[(RMProductModel *)[[dic objectForKey:@"products"] objectAtIndex:0] corp_id]] orderby:nil] lastObject];
        model.order_message = textField.text;
        NSLog(@"%ld",(long)model.id__);
        if([model updatetoDb]){
            NSLog(@"更新成功");
        }else{
            NSLog(@"更新失败");
        }
    }
}

#pragma mark - 输入框文字检测

- (void)textFieldChanged:(NSNotification *)noti {
    
    UITextField * textfield = noti.object;
    if([[textfield.superview superview] isKindOfClass:[RMShopCarGoodsTableViewCell class]]){
        NSInteger section = [textfield tag]/3000;
        int row = [textfield tag]%3000;
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:row inSection:section];
        if(textfield.text.length == 0)
        {
            
        }
        else
        {
            [self validationAction:indexpath andN:[[textfield text] integerValue]];
        }

    }else if([[textfield.superview superview] isKindOfClass:[RMShopLeaveMsTableViewCell class]]){
        
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
