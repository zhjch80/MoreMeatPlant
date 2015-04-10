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

@property (nonatomic, strong) NSIndexPath * indexPath;

- (void)addTarget:(id)target withSelector:(SEL)sel;

@end
