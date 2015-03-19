//
//  RMImageView.h
//  RMVideo
//
//  Created by runmobile on 14-10-13.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMImageView : UIImageView {
    id _target;
    SEL _sel;
}
@property (nonatomic, strong) NSString *identifierString;

- (void)addTarget:(id)target WithSelector:(SEL)sel;

@end
