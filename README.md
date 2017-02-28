

# 这个是什么
这个demo是一个关于抽奖转盘的demo.产品告诉我需要有一个抽奖转盘等等需求,然后就花了1天撸了一个大概,原理很简单.无非就是一些旋转动画.但是还是有一些细节需要处理

## 基本原理
转盘转盘,那肯定就是转了,当然就跟动画中的`CABasicAnimation`有关了.
### 首先
我们来看看转盘转动的过程

**慢慢启动-匀速转动-慢慢减速**

还根据业务中需要有请求等待时间.所以我选择把这3个步分为2个部分

**慢慢启动-匀速转动**

**匀速转动-慢慢减速**

在这2个阶段中穿插的是数据的请求.

那么 我们首先需要实现*慢慢启动-匀速转动*的过程

### 慢慢启动-匀速转动
这个过程打算使用`CADisplayLink`来完成

使用这个定时器的原因首先不是很熟悉他,所以想通过使用来了解他,其次由于这个定时器的特性,这样动画看着不会掉帧.

通过定时器去改变view的transform,为了实现这个变加速的转动过程,那么我们需要改变transform的幅度,同样通过定时器去改变幅度

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
	    }else
	    {
	        self.rotateWheel.transform = CGAffineTransformRotate(self.rotateWheel.transform, self.speed);
	
	    }
	    
	}

这样第一个过程就完成了.

### 匀速转动-慢慢减速
接下来来完成第二个过程

从匀速转动到慢慢减速的过程,其中还需要让指针指向服务器给你的奖品区域.所以.我这里选择的就是最开始提到的`CABasicAnimation `中的`transform.rotation` 

    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];


`timingFunction`可以控制动画的速度.例如匀速,浅进,浅出.

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
	    
动画是完成了,但是有一个尴尬的问题,就是layer动画是转过去了,但是view并没有转过去,所以还需要将view转过去

		weakSelf.rotateWheel.transform = CGAffineTransformMakeRotation(jiaoDu);
        [weakSelf.rotateWheel.layer removeAnimationForKey:@"zhuandong"];
        
这样第二个步骤也完成了

### 整合
最后就是把2个动画给结合起来.
首先点击抽奖,开启定时器,这个时候转盘开始慢慢地转动,同时开始向服务器请求中奖结果.一旦请求到数据,算出需要转动的角度,就开始启动基本动画并且关掉定时器,在基本动画完成后最后改变view的角度,到此,整个抽奖动画完成.

## 遇到的坑

* 由于按钮可以开始动画,因此在转动开始时,需要关闭交互,在结束时打开,不然你会得到一个快起飞的转盘~~~
* 定时器的runloop别忘记了
	
[我的Github](https://github.com/heTaoEvo/LXYLuckyDraw)

[我的blog](http://chloe.lol/)




![](https://www.mercedesamgf1.com/wp-content/uploads/sites/3/2017/02/header_20170228_01-1280x640.jpg)
