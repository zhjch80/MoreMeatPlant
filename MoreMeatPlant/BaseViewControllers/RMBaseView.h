//
//  RMBaseView.h
//  MoreMeatPlant
//
//  Created by runmobile on 15/3/12.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMBaseView : UIView {
    id _target;
    SEL _sel;
}
@property (nonatomic, strong) NSString *identifierString;

- (void)addTarget:(id)target withSelector:(SEL)sel;

@end
