//
//  RMNearbyMerchantViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/16.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMNearbyMerchantViewController.h"
#import "BMapKit.h"
#import "AppDelegate.h"
#import "RMPointAnnotation.h"
#import "RMMyCorpViewController.h"
#import "RMActionPaopaoView.h"
#import "NSString+Addtion.h"
@interface RMNearbyMerchantViewController ()<BMKMapViewDelegate>
{
    BMKMapView * _mapView;
    BMKPointAnnotation * myLocationannotation;
    NSMutableArray * dataarray;
}
@end

@implementation RMNearbyMerchantViewController

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}


- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; //不用时，置nil
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setCustomNavTitle:@"附近商家"];
    dataarray = [[NSMutableArray alloc]init];
    [leftBarButton setImage:[UIImage imageNamed:@"img_leftArrow"] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor colorWithRed:0.94 green:0.01 blue:0.33 alpha:1] forState:UIControlStateNormal];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    
    [self.view addSubview:_mapView];
    
    [self location];
    
}

- (void)location{
    if(myLocationannotation == nil){
        myLocationannotation = [[BMKPointAnnotation alloc]init];
    }
    __weak AppDelegate * dele = [[UIApplication sharedApplication] delegate];
    [dele.locationManager startLocation];
    dele.locationManager.callback = ^(BMKUserLocation * userLocation){
        if(userLocation){
            [dele.locationManager stopLocation];
            
            [dele.locationManager ReverseGeoAction:userLocation.location.coordinate];
            NSString * coor = [NSString stringWithFormat:@"%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude];
            [[RMUserLoginInfoManager loginmanager] setCoorStr:coor];
            NSLog(@"%@",coor);
            myLocationannotation.coordinate = userLocation.location.coordinate;

            [self requestNearCorp];
        }
    };
    dele.locationManager.gccallback = ^(NSString * address){
        [[RMUserLoginInfoManager loginmanager] setCurrent_address:address];
        
        myLocationannotation.title = [[RMUserLoginInfoManager loginmanager] current_address];
        [_mapView addAnnotation:myLocationannotation];
        
        [_mapView setCenterCoordinate:myLocationannotation.coordinate animated:YES];
    };

}

- (void)requestNearCorp{
    NSLog(@"%@",[[RMUserLoginInfoManager loginmanager] coorStr]);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RMAFNRequestManager nearCorpRequestwithCoor:[[RMUserLoginInfoManager loginmanager] coorStr] andCallBack:^(NSError *error, BOOL success, id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success){
            NSArray * arr = object;
            if([arr count]>0){
                RMPublicModel * model = [arr objectAtIndex:0];
                if(model.status){
                    [dataarray addObjectsFromArray:object];
                    [self addAnnotion];
                }else{
                    
                }
                [self showHint:model.msg];
            }
        }else{
            [self showHint:object];
        }
    }];
}


- (void)addAnnotion
{
    int i = 0;
    float minlong = myLocationannotation.coordinate.longitude;
    float maxlong = myLocationannotation.coordinate.longitude;
    float minlat = myLocationannotation.coordinate.latitude;
    float maxlat = myLocationannotation.coordinate.latitude;
    for (RMPublicModel * item in dataarray) {
        RMPointAnnotation * ann = [[RMPointAnnotation alloc]init];
        CLLocationCoordinate2D coo = CLLocationCoordinate2DMake([item.content_y floatValue], [item.content_x floatValue]);
        ann.tag = 100+i;
        ann.title = item.content_name;
        ann.coordinate = coo;
        
        [_mapView addAnnotation:ann];
        

        if([item.content_y floatValue]>maxlat)//最大纬度
        {
            maxlat = [item.content_y floatValue];
        }
        if([item.content_x floatValue]>maxlong)//最大经度
        {
            maxlong = [item.content_x floatValue];
        }
        if([item.content_y floatValue]<minlat)
        {
            minlat = [item.content_y floatValue];
        }
        if([item.content_x floatValue]<minlat)
        {
            minlong = [item.content_x floatValue];
        }
        i++;
    }
}

//model.auto_id
//model.content_name
//model.content_face
//model.content_linkname
//model.content_mobile
//model.content_address
//model.levelId
#pragma mark - MapDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    
//    if([annotation isKindOfClass:[RMPointAnnotation class]])
//    {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"shopAnnotation"];
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
//        newAnnotationView.image = [UIImage imageNamed:@"map_shop_icon"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;//附近店铺
        newAnnotationView.tag = [(RMPointAnnotation *)annotation tag];
        RMPublicModel * model = [dataarray objectAtIndex:[(RMPointAnnotation *)annotation tag]-100];
        RMActionPaopaoView * paopao = [[[NSBundle mainBundle] loadNibNamed:@"RMActionPaopaoView" owner:self options:nil] lastObject];
        [paopao.layer setCornerRadius:5.0];
        [paopao.content_face sd_setImageWithURL:[NSURL URLWithString:model.content_face] placeholderImage:[UIImage imageNamed:@"nophote"]];
        paopao.content_content.text = [NSString stringWithFormat:@"店铺名称:%@\n负责人:%@\n联系方式:%@\n店铺地址:%@\n店铺级别:%@",model.content_name,model.content_linkname,model.content_mobile,model.content_address,model.levelId];
        CGSize size = [paopao.content_content.text getcontentsizeWithfont:paopao.content_content.font constrainedtosize:CGSizeMake(paopao.content_content.frame.size.width, 200) linemode:NSLineBreakByCharWrapping];
        paopao.frame = CGRectMake(paopao.frame.origin.x, paopao.frame.origin.y, paopao.frame.size.width, size.height+8*2);
        BMKActionPaopaoView * paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:paopao];
        newAnnotationView.paopaoView = paopaoView;
        return newAnnotationView;
//    }
//    else if ([annotation isKindOfClass:[BMKPointAnnotation class]])//我自己
//    {
//        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
////        newAnnotationView.image = [UIImage imageNamed:@"current_icon"];
//        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
//        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
//        
//        return newAnnotationView;
//    }
    
    return nil;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [_mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"*******%@",myLocationannotation);
    //     [_mapView selectAnnotation:self.myLocationannotation animated:YES];
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    RMPublicModel * model = [dataarray objectAtIndexedSubscript:[(RMPointAnnotation *)view.annotation tag]];
    RMMyCorpViewController * corp = [[RMMyCorpViewController alloc]initWithNibName:@"RMMyCorpViewController" bundle:nil];
    corp.auto_id = model.auto_id;
    [self.navigationController pushViewController:corp animated:YES];
}



- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 2:{
            
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
