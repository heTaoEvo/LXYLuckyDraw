//
//  LXYLuckyDrawView.h
//  UNIVERTWO
//
//  Created by 廖雪原 on 2016/10/21.
//  Copyright © 2016年 com.LiXiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
@interface LXYLuckyDrawView : UIView

/**
 转盘的格子
 */
@property (nonatomic, assign) NSInteger numberIndex;

/**
 还剩几次抽奖次数
 */
@property (nonatomic, assign) NSInteger numberOfChance;

/**
 开始按钮回调
 */
@property (nonatomic, copy) void(^BeginAction)();
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, strong) UIButton *playButton;   //抽奖按钮


- (void)startRotate;
- (void)StartAnimationWithNumberIndex:(NSInteger)numberIndex andPrizeJingGao:(NSString *)content completed:(void(^)(void))completed;
@end
