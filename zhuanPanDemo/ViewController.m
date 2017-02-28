//
//  ViewController.m
//  zhuanPanDemo
//
//  Created by 廖雪原 on 2017/2/27.
//  Copyright © 2017年 廖雪原. All rights reserved.
//

#import "ViewController.h"
#import "LXYLuckyDrawView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LXYLuckyDrawView *luckyDrawView = [[LXYLuckyDrawView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth)];
    luckyDrawView.numberOfChance = 5;
    luckyDrawView.numberIndex = 6;
    __weak __typeof__(LXYLuckyDrawView) *weakView = luckyDrawView;
    luckyDrawView.BeginAction = ^(){
        __strong __typeof__(LXYLuckyDrawView) *strongView = weakView;
        [strongView startRotate];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongView StartAnimationWithNumberIndex:arc4random()%5 andPrizeJingGao:@"抽奖提示" completed:^{
                NSLog(@"结束");
            }];
        });
        
    };
    [self.view addSubview:luckyDrawView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
