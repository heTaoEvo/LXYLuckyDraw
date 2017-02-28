//
//  LXYLuckyDrawView.m
//  UNIVERTWO
//
//  Created by 廖雪原 on 2016/10/21.
//  Copyright © 2016年 com.LiXiang. All rights reserved.
//

#import "LXYLuckyDrawView.h"
#import <Masonry.h>
@interface LXYLuckyDrawView ()
@property (nonatomic, strong) UIImageView *rotateWheel; //转盘背景

@property (nonatomic, strong) UILabel *chanceLabel;
@property (nonatomic, assign) float speed;
@end

@implementation LXYLuckyDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.rotateWheel];
        [self addSubview:self.playButton];
        [self.playButton addSubview:self.chanceLabel];
        [self commit];
    }
    return self;
}



- (void)commit {
    
    self.rotateWheel.frame = self.bounds;
    
    NSLog(@"%@",self);
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).multipliedBy(79/341.0);
        make.height.equalTo(self).multipliedBy(100/341.0);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);

    }];

    [self.chanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@300);
        make.top.equalTo(self.playButton.mas_top).offset(66);
        make.centerX.equalTo(self.playButton.mas_centerX);

    }];
}

#pragma mark -动画


- (void)StartAnimationWithNumberIndex:(NSInteger)numberIndex andPrizeJingGao:(NSString *)content completed:(void(^)(void))completed;
{
    CGFloat jiaoDu = 2 * M_PI * 3 -2*M_PI/6/2-(2*M_PI/self.numberIndex*(numberIndex));
    CABasicAnimation* animation = [[CABasicAnimation alloc] init];
    animation.keyPath = @"transform.rotation";
    //设置动画在哪结束
    animation.toValue = @(jiaoDu);
    // animation.toValue = @(2 * M_PI * 5);
    animation.duration = 3;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    self.link.paused = YES;
    [self.rotateWheel.layer addAnimation:animation forKey:@"zhuandong"];
    __weak LXYLuckyDrawView *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.rotateWheel.transform = CGAffineTransformMakeRotation(jiaoDu);
        [weakSelf.rotateWheel.layer removeAnimationForKey:@"zhuandong"];
        completed();

    });

    

}

#pragma mark -定时器
- (void)startRotate
{
    self.speed = 0;
    CADisplayLink* link = [CADisplayLink displayLinkWithTarget:self selector:@selector(Rotate)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.link = link;
}
- (void)Rotate{
    self.speed = self.speed + 0.001;
    if (self.speed > 0.3) {
        self.rotateWheel.transform = CGAffineTransformRotate(self.rotateWheel.transform, 0.3);
    }else{
        self.rotateWheel.transform = CGAffineTransformRotate(self.rotateWheel.transform, self.speed);

    }
    
}

#pragma mark -按钮响应
- (void)playButtonPressed:(UIButton *)sender
{
    if (_numberOfChance > 0) {
        self.BeginAction();
        
    }else
    {
       

    }
    
}

#pragma mark -setter

- (void)setNumberOfChance:(NSInteger)numberOfChance
{
    _numberOfChance = numberOfChance;
    NSUserDefaults * usert = [NSUserDefaults standardUserDefaults];
    
    NSString * str = [usert objectForKey:@"token"];
    if (str.length > 0) {
    
        _chanceLabel.text = [NSString stringWithFormat:@"%ld次机会",(long)numberOfChance];

    }else{
    _chanceLabel.text = [NSString stringWithFormat:@"请先登录"];
    }
}

- (void)setImageUrlString:(NSString *)imageUrlString
{
    
        _rotateWheel.image = [UIImage imageNamed:@"zhuanpanxindeyo"];
}
#pragma mark -懒加载
- (UIImageView *)rotateWheel
{
    if (_rotateWheel == nil) {
        _rotateWheel = [[UIImageView alloc]init];
        _rotateWheel.image = [UIImage imageNamed:@"zhuanpanxindeyo"];
    }
    return _rotateWheel;
}

- (UIButton *)playButton
{
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"btn_choujiang"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _playButton.adjustsImageWhenDisabled = NO;
    }
    return _playButton;
}

- (UILabel *)chanceLabel
{
    if (_chanceLabel == nil) {
        _chanceLabel = [[UILabel alloc]init];
        _chanceLabel.font = [UIFont systemFontOfSize:13];
        _chanceLabel.textColor = [UIColor colorWithRed:255/255.0 green:92/255.0 blue:67/255.0 alpha:1];
        _chanceLabel.textAlignment = NSTextAlignmentCenter;
        _chanceLabel.text = @"1次机会";
    }
    return _chanceLabel;
}

@end
