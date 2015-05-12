//
//  RMPublishClassTableViewCell.m
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/3/19.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import "RMPublishClassTableViewCell.h"
#import "NSString+Addtion.h"
#import "CONST.h"
#import "RMPublicModel.h"

@implementation RMPublishClassTableViewCell
@synthesize x,y,index;
- (void)awakeFromNib {
    // Initialization code
     x = 10;
     y = 31;
    index = 100;
    _titles = [[NSMutableArray alloc]init];
    
    _bottom_line.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"heidian", @"png")];
    
    _addClassBtn.backgroundColor = [UIColor colorWithPatternImage:LOADIMAGE(@"hei_btn", @"png")];
    _addClassBtn.layer.cornerRadius = 5;
    _addClassBtn.clipsToBounds = YES;
}

- (void)createItem:(NSArray *)array andCallBack:(PublishClassAdded) block{
    
    NSMutableArray * arr = [[NSMutableArray alloc]initWithCapacity:0];
    for(RMPublicModel * model in array){
        if( [self.titles containsObject:model.content_name]){
            [arr addObject:model.content_name];
        }
        else{
            
        }
    }
    if([arr count]!=0){
        NSString * tips = [NSString stringWithFormat:@"%@已经存在,请重新添加!",[arr componentsJoinedByString:@","]];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:tips delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    
    for(RMPublicModel * model in array){
        [self.titles addObject:model.content_name];
    }
    
    if(block){
        block();
    }
    
    for(RMPublicModel * model in array){
        CGSize size = [model.content_name getcontentsizeWithfont:FONT_0(13) constrainedtosize:CGSizeMake(100, 20) linemode:NSLineBreakByCharWrapping];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"fbbb_no_select"] forState:UIControlStateNormal];
        if(x+20+size.width+10*2>kScreenWidth){
            y+=20+5;
            x = 10;
        }
        btn.frame = CGRectMake(x, y, 20, 20);
        btn.tag = index;//从100开始的
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width+10, y, size.width, size.height)];
        label.center = CGPointMake(label.center.x, btn.center.y);
        label.font = FONT_0(13);
        label.text = model.content_name;
        
        [btn addTarget:self action:@selector(selectClass:) forControlEvents:UIControlEventTouchDown];
        
        [self.contentView addSubview:btn];
        [self.contentView addSubview:label];
        
        x+= 10+20+size.width+10;
        
        index++;
//        NSLog(@"-----------%ld",(long)index);
    }
//    NSLog(@"+++++++%@",self.titles);

}
- (void)selectClass:(UIButton *)sender{
    if(self.delegate){
        [self.delegate RMPublishClassTableViewCellDidSelectCourse:sender];
    }
}
- (void)layoutSubviews{
    
    
    
   }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
