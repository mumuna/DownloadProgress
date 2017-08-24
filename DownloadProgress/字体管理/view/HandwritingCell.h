//
//  HandwritingCell.h
//  TianJinDL
//
//  Created by 王娜 on 2017/8/14.
//  Copyright © 2017年 troilamac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QKYDelayButton.h"
@class HandwritingCell;
@protocol HandwritingCellDelegate <NSObject>
-(void)cell:(HandwritingCell *)cell didClickedBtn:(UIButton *)btn;
@end



@interface HandwritingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *bytesLable;

@property (weak, nonatomic) IBOutlet QKYDelayButton *button;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttontop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonbottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonright;

- (IBAction)buttonClick:(id)sender;

-(void)resetModel:(NSDictionary*)model;
@property (nonatomic,weak) id<HandwritingCellDelegate>delegate;
@property (nonatomic,copy)NSString *url;
@end
