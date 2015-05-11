//
//  RMCorpInfoEditTableViewCell.h
//  MoreMeatPlant
//
//  Created by 马东凯 on 15/4/25.
//  Copyright (c) 2015年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMBaseTextField.h"
#import "JKCountDownButton.h"
@interface RMCorpInfoEditTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *signatureT;//签名
@property (weak, nonatomic) IBOutlet UITextField *mobileT;
@property (weak, nonatomic) IBOutlet UITextField *apliyT;
@property (weak, nonatomic) IBOutlet UIButton *sureModifyBtn;
@property (weak, nonatomic) IBOutlet UIImageView * content_face;

@property (weak, nonatomic) IBOutlet UITextField *content_link;
@property (weak, nonatomic) IBOutlet UITextField *content_mobile;
@property (weak, nonatomic) IBOutlet UITextView *content_address;//
@property (weak, nonatomic) IBOutlet UIImageView * card_photo;
@property (weak, nonatomic) IBOutlet UIImageView * corp_photo;
@property (weak, nonatomic) IBOutlet RMBaseTextField *codeField;
@property (weak, nonatomic) IBOutlet JKCountDownButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIImageView *textViewBg;
@property (weak, nonatomic) IBOutlet UIImageView *textViewBg2;
@end
