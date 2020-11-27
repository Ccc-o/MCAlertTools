//
//  ViewController.m
//  Demo
//
//  Created by M了个C on 2020/11/27.
//

#import "ViewController.h"
#import <MCAlertTools.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** <#description#> */
@property (nonatomic,strong) NSMutableArray *dateSource;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dateSource = [NSMutableArray array];
    self.dateSource = [@[@"1.简易（最多支持单一按钮,按钮无执行响应）alert定义 兼容适配",
                         @"2.actionSheet实现 底部简易提示窗 无按钮",
                         @"3.普通alert定义 兼容适配alertView和alertController",
                         @"4.普通 actionSheet 兼容适配",
                         @"5.多按钮列表数组排布alert初始化 兼容适配",
                         @"6.多按钮列表数组排布actionSheet初始化 兼容适配"] mutableCopy];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = self.dateSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [MCAlertTools showTipAlertViewWith:self
                                         title:@"提示"
                                       message:@"简易（最多支持单一按钮,按钮无执行响应）alert定义 兼容适配"
                                   buttonTitle:@"确定"
                                   buttonStyle:MCAlertActionStyleDefault];
            break;
        case 1:
            [MCAlertTools showBottomTipViewWith:self
                                          title:@"提示"
                                        message:@"actionSheet实现 底部简易提示窗 无按钮"];
            break;
        case 2:
            [MCAlertTools showAlertWith:self
                                  title:@"提示"
                                message:@"普通alert定义 兼容适配alertView和alertController"
                          callbackBlock:^(NSInteger index) {
                NSLog(@"index: %ld", index);
            }
                      cancelButtonTitle:@"取消"
                 destructiveButtonTitle:@"确定"
                      otherButtonTitles:nil];
            break;
        case 3:
            [MCAlertTools showActionSheetWith:self
                                        title:@"提示"
                                      message:@"普通 actionSheet 兼容适配"
                                callbackBlock:^(NSInteger index) {
                NSLog(@"index: %ld", index);
            }
                       destructiveButtonTitle:@"确定"
                            cancelButtonTitle:@"取消"
                            otherButtonTitles:@"其它", nil];
            break;
        case 4:
            [MCAlertTools showArrayAlertWith:self
                                       title:@"提示"
                                     message:@"多按钮列表数组排布alert初始化 兼容适配"
                               callbackBlock:^(NSInteger index) {
                NSLog(@"index: %ld", index);
            }
                           cancelButtonTitle:@"取消"
                       otherButtonTitleArray:@[@"1", @"2", @"3"]
                       otherButtonStyleArray:@[@2, @0, @2]];
            break;
        case 5:
            [MCAlertTools showArrayActionSheetWith:self
                                             title:@"提示"
                                           message:@"多按钮列表数组排布actionSheet初始化 兼容适配"
                                     callbackBlock:^(NSInteger index) {
                NSLog(@"index: %ld", index);
            }
                                 cancelButtonTitle:@"取消"
                            destructiveButtonTitle:@"确定"
                             otherButtonTitleArray:@[@"1", @"2", @"3"]
                             otherButtonStyleArray:@[@2, @2, @0]];
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
