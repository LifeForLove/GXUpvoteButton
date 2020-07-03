//
//  GXUpvoteButton.m
//
//  Created by apple on 2017/12/19.
//  Copyright © 2017年 getElementByYou. All rights reserved.
//

#import "GXUpvoteButton.h"

@interface GXUpvoteLabel : UILabel
@property (nonatomic,assign) BOOL showState;
@property (nonatomic,assign) NSInteger upvoteCount;

- (void)show;
- (void)hide;

@end

@implementation GXUpvoteLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.upvoteCount = 0;
    }
    return self;
}

/**
 隐藏点赞文字
 */
- (void)hide {
    self.showState = NO;
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = @1;
    anima.toValue = @0;
    anima.duration = 0.5;
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:anima forKey:@"opacityAniamtion"];
}

/**
 显示点赞文字
 */
- (void)show {
    self.showState = YES;
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = @0;
    anima.toValue = @1;
    anima.duration = 0.2;
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:anima forKey:@"opacityAniamtion"];
}

- (void)setUpvoteCount:(NSInteger)upvoteCount {
    _upvoteCount = upvoteCount;
    self.attributedText = [self getAttributedString:upvoteCount];
    self.textAlignment = NSTextAlignmentCenter;
}

/**
 富文本设置label的图片内容
 
 @param num 当前赞的个数
 @return 要显示的富文本
 */
- (NSMutableAttributedString *)getAttributedString:(NSInteger)num {
    //先把num 拆成个十百
    NSInteger ge = num % 10;
    NSInteger shi = num % 100 / 10;
    NSInteger bai = num % 1000 / 100;
    
    //大于1000则隐藏
    if (num >= 1000) {
        return nil;
    }
    
    
    NSMutableAttributedString * mutStr = [[NSMutableAttributedString alloc]init];
    
    //创建百位显示的图片
    if (bai != 0) {
        NSTextAttachment *b_attch = [[NSTextAttachment alloc] init];
        b_attch.image = [UIImage imageNamed:[NSString stringWithFormat:@"multi_digg_num_%zd",bai]];
        b_attch.bounds = CGRectMake(0, 0, b_attch.image.size.width, b_attch.image.size.height);
        NSAttributedString *b_string = [NSAttributedString attributedStringWithAttachment:b_attch];
        [mutStr appendAttributedString:b_string];
    }
    
    //创建十位显示的图片
    if (!(shi == 0 && bai == 0)) {
        NSTextAttachment *s_attch = [[NSTextAttachment alloc] init];
        s_attch.image = [UIImage imageNamed:[NSString stringWithFormat:@"multi_digg_num_%zd",shi ]];
        s_attch.bounds = CGRectMake(0, 0, s_attch.image.size.width, s_attch.image.size.height);
        NSAttributedString *s_string = [NSAttributedString attributedStringWithAttachment:s_attch];
        [mutStr appendAttributedString:s_string];
    }
    
    //创建个位显示的图片
    if (ge >= 0) {
        NSTextAttachment *g_attch = [[NSTextAttachment alloc] init];
        g_attch.image = [UIImage imageNamed:[NSString stringWithFormat:@"multi_digg_num_%zd",ge]];
        g_attch.bounds = CGRectMake(0, 0, g_attch.image.size.width, g_attch.image.size.height);
        NSAttributedString *g_string = [NSAttributedString attributedStringWithAttachment:g_attch];
        [mutStr appendAttributedString:g_string];
    }
    
    if (num <= 3) {
        //鼓励
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"multi_digg_word_level_1"];
        attch.bounds = CGRectMake(0, 0, attch.image.size.width, attch.image.size.height);
        NSAttributedString *z_string = [NSAttributedString attributedStringWithAttachment:attch];
        [mutStr appendAttributedString:z_string];
    }else if (num <= 6)
    {
        //加油
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"multi_digg_word_level_2"];
        attch.bounds = CGRectMake(0, 0, attch.image.size.width, attch.image.size.height);
        NSAttributedString *z_string = [NSAttributedString attributedStringWithAttachment:attch];
        [mutStr appendAttributedString:z_string];
    }else
    {
        //太棒了
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"multi_digg_word_level_3"];
        attch.bounds = CGRectMake(0, 0, attch.image.size.width, attch.image.size.height);
        NSAttributedString *z_string = [NSAttributedString attributedStringWithAttachment:attch];
        [mutStr appendAttributedString:z_string];
    }
    
    return mutStr;
    
}

@end



@interface GXUpvoteButton()<CAAnimationDelegate>

/**
 展示多少个赞的label
 */
@property (nonatomic, strong) GXUpvoteLabel *upvoteLabel;

@property (nonatomic,strong) NSMutableArray *imgArr;

@property (nonatomic,strong) CAEmitterLayer * longPressLayer;

@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGes;

@end



@implementation GXUpvoteButton {
    NSTimer *_timer; //定时器
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 *  配置WclEmitterButton
 */
- (void)setup {
    //显示赞数量的label
    [self upvoteLabel];
    
    //添加点击事件
    //点一下
    [self addTarget:self action:@selector(pressOnece:) forControlEvents:UIControlEventTouchUpInside];
    //长按
    self.longPressGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:self.longPressGes];
    
    [self setImage:[UIImage imageNamed:@"feed_like"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"feed_like_press"] forState:UIControlStateSelected];
}

/**
 点了一下
 */
- (void)pressOnece:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(upvoteBtnTouchUpInsideAction:)]) {
        [self.delegate upvoteBtnTouchUpInsideAction:sender];
    }
    
    //如果快速点赞
    if ([self.imageView.layer animationForKey:@"transform.scale"] && sender.selected) {
        self.upvoteLabel.upvoteCount ++;
        if (self.upvoteLabel.upvoteCount > 2 && self.upvoteLabel.showState == NO) {
            [self.upvoteLabel show];
        }
        [self tapAnimation];
    } else {
        sender.selected = !sender.selected;
        if (sender.selected) {
            if (self.upvoteLabel.showState) {
                [self.upvoteLabel hide];
            }
            [self tapAnimation];
        } else {
            self.upvoteLabel.upvoteCount = 1;
            if (self.upvoteLabel.showState) {
                [self.upvoteLabel hide];
            }
        }
    }
}

/**
 点按动画
 */
- (void)tapAnimation {
    [self handimgAnimation];
    CAEmitterLayer * layer = [self createStreamLayer];
    [self upvoteShowWithStreamLayer:layer];
    [self upvoteHiddenWithStreamLayer:layer];
    [self feedBackGeneratorAction];
}

/**
振动
*/
- (void)feedBackGeneratorAction {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator * impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleHeavy];
        [impactLight impactOccurred];
    } else {
        // Fallback on earlier versions
    }
}

/**
 点赞图片动画
 */
- (void)handimgAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    if (self.selected) {
        animation.values = @[@1.5 ,@0.8, @1.0,@1.2,@1.0];
        animation.duration = 0.5;
    }else
    {
        animation.values = @[@0.8, @1.0];
        animation.duration = 0.4;
    }
    animation.calculationMode = kCAAnimationCubic;
    animation.delegate = self;
    [self.imageView.layer addAnimation:animation forKey:@"transform.scale"];
}

/**
 长按

 @param ges 手势
 */
- (void)longPress:(UIGestureRecognizer *)ges {
    UIButton * sender = (UIButton *)ges.view;
    sender.selected = YES;
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        if ([self.layer.sublayers containsObject:self.longPressLayer]) {
            return;
        }
        if ([self.delegate respondsToSelector:@selector(upvoteBtnLongPressStateBeganAction:)]) {
            [self.delegate upvoteBtnTouchUpInsideAction:sender];
        }
        if (!self.upvoteLabel.showState) {
            [self.upvoteLabel show];
        }
        self.longPressLayer = [self createStreamLayer];
        [self upvoteShowWithStreamLayer:self.longPressLayer];

        _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(longPressTimerAction) userInfo:nil repeats:YES];
    }else if (ges.state == UIGestureRecognizerStateEnded) {
        self.longPressGes.enabled = NO;
        [self removeLongPressLayer];
        if (self.upvoteLabel.showState) {
            [self.upvoteLabel hide];
        }
        [_timer invalidate];
        _timer = nil;
    }
}

/**
 定时器事件
 */
- (void)longPressTimerAction {
    self.upvoteLabel.upvoteCount ++;
    [self feedBackGeneratorAction];
}

- (void)upvoteShowWithStreamLayer:(CAEmitterLayer *)streamerLayer  {
    [self createEmitterCellArr:self.imgArr streamerLayer:streamerLayer];
    for (NSString * imageStr in self.imgArr) {
           [streamerLayer setValue:[NSNumber numberWithInteger:5] forKeyPath:[NSString stringWithFormat:@"emitterCells.%@.birthRate",imageStr]];
    }
}

- (void)upvoteHiddenWithStreamLayer:(CAEmitterLayer *)streamerLayer {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSString * imageStr in self.imgArr) {
               [streamerLayer setValue:[NSNumber numberWithInteger:0] forKeyPath:[NSString stringWithFormat:@"emitterCells.%@.birthRate",imageStr]];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [streamerLayer removeFromSuperlayer];
        });
    });
}

- (void)removeLongPressLayer {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSString * imageStr in self.imgArr) {
               [self.longPressLayer setValue:[NSNumber numberWithInteger:0] forKeyPath:[NSString stringWithFormat:@"emitterCells.%@.birthRate",imageStr]];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.longPressLayer removeFromSuperlayer];
            if (self.longPressLayer) {
                self.longPressLayer = nil;
                self.longPressGes.enabled = YES;
            }
        });
    });
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([self.imageView.layer animationForKey:@"transform.scale"] == nil) {
        if (self.upvoteLabel.showState) {
            [self.upvoteLabel hide];
        }
    }
}

- (CAEmitterLayer *)createStreamLayer {
     //设置暂时的layer
    CAEmitterLayer *streamerLayer = [CAEmitterLayer layer];
    streamerLayer.position = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    //发射器的尺寸
    streamerLayer.emitterSize   = self.layer.bounds.size;
    streamerLayer.masksToBounds = NO;
    streamerLayer.renderMode = kCAEmitterLayerBackToFront;
    return streamerLayer;
}

- (NSMutableArray *)imgArr {
    if (_imgArr == nil) {
        _imgArr = [NSMutableArray array];
        for (int i = 1; i < 8; i++) {
            //78张图片 随机选9张
            int x = arc4random() % 77 + 1;
            NSString * imageStr = [NSString stringWithFormat:@"emoji_%d",x];
            [_imgArr addObject:imageStr];
        }
    }
    return _imgArr;
}

/**
 创建粒子单元数组
 */
- (NSMutableArray *)createEmitterCellArr:(NSMutableArray *)imgArr streamerLayer:(CAEmitterLayer *)streamerLayer {
    //设置展示的cell
    NSMutableArray * emitterCellArr = [NSMutableArray array];
    for (NSString * imageStr in imgArr) {
        CAEmitterCell * cell = [self emitterCell:[UIImage imageNamed:imageStr] Name:imageStr];
        [emitterCellArr addObject:cell];
    }
    streamerLayer.emitterCells  = emitterCellArr;
    [self.layer addSublayer:streamerLayer];
    return emitterCellArr;
}


/**
 *  开始动画
 */
- (void)animation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@1.5 ,@0.8, @1.0,@1.2,@1.0];
    animation.duration = 0.5;
    animation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:animation forKey:@"transform.scale"];
}

/**
 更改点赞个数label的文字
 */
- (void)changeText {
    self.upvoteLabel.upvoteCount ++;
}

/**
 创建发射的表情cell
 
 @param image 传入随机的图片
 @param name 图片的名字
 @return cell
 */
- (CAEmitterCell *)emitterCell:(UIImage *)image Name:(NSString *)name {
    CAEmitterCell * smoke = [CAEmitterCell emitterCell];
    smoke.birthRate = 0;//每秒创建的发射对象个数
    smoke.lifetime = 5;// 粒子的存活时间
    smoke.lifetimeRange = 5;
    smoke.scale = 0.5;//设置粒子的大小
    
    smoke.alphaRange = 1;
    smoke.alphaSpeed = -1.5;
    smoke.yAcceleration = 4000;//可以有下落的效果
//    smoke.zAcceleration = 4000;
    CGImageRef image2 = image.CGImage;
    smoke.contents= (__bridge id _Nullable)(image2);
    smoke.name = name; //设置这个 用来展示喷射动画 和隐藏
    
    smoke.velocity = 1500;//速度
    smoke.velocityRange = 1500;// 平均速度
    smoke.emissionRange = M_PI_2;//粒子的发散范围
    smoke.emissionLongitude = 3 * M_PI / 2 ;
//    smoke.spin = M_PI * 2; // 粒子的平均旋转速度
//    smoke.spinRange = M_PI * 2;// 粒子的旋转速度调整范围
    return smoke;
}

- (GXUpvoteLabel *)upvoteLabel {
    if (_upvoteLabel == nil) {
        _upvoteLabel = [[GXUpvoteLabel alloc]init];
        _upvoteLabel.frame = CGRectMake(-50 ,- 100, 200, 40);
        _upvoteLabel.upvoteCount = 1;
        _upvoteLabel.alpha = 0;
        [self addSubview:_upvoteLabel];
    }
    return _upvoteLabel;
}


@end
