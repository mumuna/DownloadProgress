
//
//  HandwritingManageController.m
//  TianJinDL
//
//  Created by apple on 17/8/13.
//  Copyright © 2017年 troilamac. All rights reserved.
//

#import "HandwritingManageController.h"
#import "HandwritingCell.h"
#import "MCDownloadManager.h"
#import "MCWiFiManager.h"
@interface HandwritingManageController ()<UITableViewDelegate,UITableViewDataSource,HandwritingCellDelegate>
@property (nonatomic,weak) UIButton *selectedBtn;
@end

@implementation HandwritingManageController
{
    NSArray *dataArr;
    UITableView *handtable;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [handtable reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文件下载";
    [self setNav];
    [self getData];
    [self setMain];
    MCWiFiManager *wifiManager = [[MCWiFiManager alloc]init];
    [wifiManager scanNetworksWithCompletionHandler:^(NSArray<MCWiFi *> * _Nullable networks, MCWiFi * _Nullable currentWiFi, NSError * _Nullable error) {
        NSLog(@"name = %@,mac = %@",currentWiFi.wifiName,currentWiFi.wifiBSSID);
    }];
    NSLog(@"网关:%@",[wifiManager getGatewayIpForCurrentWiFi]);

}
-(void)getData{
    dataArr = @[@{@"name":@"纽约",@"url":@"http://119.23.125.153:8000/puty/upload/fonts/cc765f30-a51c-4a35-8447-06bc472ec77a/cc765f30-a51c-4a35-8447-06bc472ec77a.ttc"},@{@"name":@"新泽西",@"url":@"http://119.23.125.153:8000/puty/upload/fonts/8027dc6d-78b9-4e46-b27e-2c74dbaccafa/8027dc6d-78b9-4e46-b27e-2c74dbaccafa.ttc"}];
}
-(void)setNav{
    //返回键
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btn setImage:[UIImage imageNamed:@"back_button_white"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
-(void)setMain{
    handtable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    handtable.dataSource = self;
    handtable.delegate =self;
    [self.view addSubview:handtable];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HandwritingCell *cell;
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HandWritingCell" owner:self options:nil].firstObject;
    }
    cell.delegate = self;
    NSDictionary *model = dataArr[indexPath.row];
    [cell resetModel:model];
 
    cell.url =[NSString stringWithFormat:@"%@",[model objectForKey:@"url"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)cell:(HandwritingCell *)cell didClickedBtn:(UIButton *)btn {
    if (_selectedBtn!=btn) {
        self.selectedBtn.selected = NO;
        self.selectedBtn = btn;
    }
    btn.selected = YES;
}
@end
