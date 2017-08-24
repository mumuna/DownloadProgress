//
//  HandwritingCell.m
//  TianJinDL
//
//  Created by 王娜 on 2017/8/14.
//  Copyright © 2017年 troilamac. All rights reserved.
//

#import "HandwritingCell.h"
#import "QKYDelayButton.h"
#import "MCDownloadManager.h"
@implementation HandwritingCell
{
    UIButton *select;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.button.clickDurationTime = 1.0;
    select = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 14.5, 15, 15)];
    [select setImage:[UIImage imageNamed:@"checked-mark_nor_grey"] forState:UIControlStateNormal];
    [select setImage:[UIImage imageNamed:@"checked_mark_sel_grey"] forState:UIControlStateSelected];
    [select addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setUrl:(NSString *)url{
    _url = url;
    MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:url];
    NSLog(@"下载的url ＝ %@",url);

   
    self.bytesLable.text = nil;
    self.progressView.progress = 0;
    self.progressView.progress = receipt.progress.fractionCompleted;
    
    if (receipt.state == MCDownloadStateDownloading) {
        //停止
        [self.button setTitle:@"" forState:UIControlStateNormal];
        self.button.backgroundColor = [UIColor clearColor];
    }else if (receipt.state == MCDownloadStateCompleted) {
        //播放
        [_button setTitle:@"" forState:UIControlStateNormal];
        self.button.backgroundColor = [UIColor clearColor];
       
        self.bytesLable.hidden = YES;
        self.progressView.hidden = YES;
         self.button.enabled = NO;
        [self addSubview:select];
        
    }else {
        //下载
        [_button setTitle:@"下载" forState:UIControlStateNormal];
         self.button.backgroundColor = [UIColor blueColor];
    }
    receipt.progressBlock = ^(NSProgress * _Nonnull downloadProgress,MCDownloadReceipt *receipt) {
        if ([receipt.url isEqualToString:self.url]) {
            self.progressView.progress = downloadProgress.fractionCompleted ;
            _bytesLable.text = [NSString stringWithFormat:@"%.0f%%", (downloadProgress.completedUnitCount/1024.0/1024/downloadProgress.totalUnitCount/1024.0/1024)*100];
          
        }
    };
    
    receipt.successBlock = ^(NSURLRequest * _Nullablerequest, NSHTTPURLResponse * _Nullableresponse, NSURL * _NonnullfilePath) {
        //播放
        [_button setTitle:@"" forState:UIControlStateNormal];
        self.button.backgroundColor = [UIColor clearColor];
        self.bytesLable.hidden = YES;
        self.progressView.hidden = YES;
        self.button.enabled = NO;
        [self addSubview:select];
    };
    
    receipt.failureBlock = ^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response,  NSError * _Nonnull error) {
        //下载
        [_button setTitle:@"" forState:UIControlStateNormal];
    };
    

}

- (void)download {
    [[MCDownloadManager defaultInstance] downloadFileWithURL:self.url
                                                    progress:^(NSProgress * _Nonnull downloadProgress, MCDownloadReceipt *receipt) {
                                                        
                                                        if ([receipt.url isEqualToString:self.url]) {
                                                            self.progressView.progress = downloadProgress.fractionCompleted ;
                                                            _bytesLable.text = [NSString stringWithFormat:@"%.0f%%", (downloadProgress.completedUnitCount/1024.0/1024)/ (downloadProgress.totalUnitCount/1024.0/1024)*100];
                                                            
                                                        }
                                                        
                                                    }
                                                 destination:nil
                                                     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull filePath) {
                                                         //播放
                                                         [_button setTitle:@"" forState:UIControlStateNormal];
                                                         self.button.backgroundColor = [UIColor clearColor];
                                                         self.bytesLable.hidden = YES;
                                                         self.progressView.hidden = YES;
                                                         self.button.enabled = NO;
                                                         [self addSubview:select];
                                                     }
                                                     failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                         //下载
                                                         [_button setTitle:@"" forState:UIControlStateNormal];
                                                     }];
    
}

- (IBAction)buttonClick:(id)sender {
    self.button.backgroundColor = [UIColor clearColor];
    
    MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:self.url];
    
    if (receipt.state == MCDownloadStateDownloading) {
        //下载
        [_button setTitle:@"" forState:UIControlStateNormal];
        [[MCDownloadManager defaultInstance] suspendWithDownloadReceipt:receipt];
    }else if (receipt.state == MCDownloadStateCompleted) {
//        
//        if ([self.delegate respondsToSelector:@selector(cell:didClickedBtn:)]) {
//            [self.delegate cell:self didClickedBtn:sender];
//        }
    }else {
        //停止
        [_button setTitle:@"" forState:UIControlStateNormal];
        [self download];
    }
}
-(void)chooseType:(UIButton*)sender{
    
            if ([self.delegate respondsToSelector:@selector(cell:didClickedBtn:)]) {
                [self.delegate cell:self didClickedBtn:sender];
            }
}
-(void)resetModel:(NSDictionary *)model

{
    self.nameLab.text = [model objectForKey:@"name"];
}
@end
