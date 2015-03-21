//
//  RMDaqoDetailsViewController.m
//  MoreMeatPlant
//
//  Created by runmobile on 15/2/17.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMDaqoDetailsViewController.h"
#import "DKLiveBlurView.h"

#define kDKTableViewMainBackgroundImageFileName @"DaQuanBackground.jpg"
#define kDKTableViewDefaultCellHeight 50.0f
#define kDKTableViewDefaultContentInset ([UIScreen mainScreen].bounds.size.height - kDKTableViewDefaultCellHeight)

@interface RMDaqoDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) DKLiveBlurView *liveBlur;

@end

@implementation RMDaqoDetailsViewController
@synthesize mTableView, dataArr, liveBlur;

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [liveBlur.scrollView removeObserver: self forKeyPath: @"contentOffset"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setHideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    dataArr = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
    
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mTableView.separatorColor = [UIColor clearColor];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.rowHeight = kDKTableViewDefaultCellHeight;
    
    liveBlur = [[DKLiveBlurView alloc] initWithFrame: self.view.bounds];
    
    liveBlur.originalImage = [UIImage imageNamed:@"testBG.jpg"];
    liveBlur.scrollView = mTableView;
    liveBlur.isGlassEffectOn = YES;
    
    mTableView.backgroundView = liveBlur;
    mTableView.contentInset = UIEdgeInsetsMake(kDKTableViewDefaultContentInset, 0, 0, 0);
    
    [self.view addSubview:mTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = @"name";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
