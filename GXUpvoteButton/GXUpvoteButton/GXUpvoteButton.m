//
//  GXUpvoteButton.m
//
//  Created by apple on 2017/12/19.
//  Copyright © 2017年 getElementByYou. All rights reserved.
//

#import "GXUpvoteButton.h"

@interface GXUpvoteButton()

/**
 展示的layer
 */
@property (strong, nonatomic) CAEmitterLayer *streamerLayer;

/**
 图片数组
 */
@property (nonatomic, strong) NSMutableArray *imagesArr;

/**
 cell的数组
 */
@property (nonatomic, strong) NSMutableArray *CAEmitterCellArr;

/**
 展示多少个赞的label
 */
@property (nonatomic, strong) UILabel *zanLabel;

@end



@implementation GXUpvoteButton

{
    NSTimer *_timer; //定时器
    NSInteger countNum;//赞的个数
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
    //初始化 赞的个数
    countNum = 1;
    
    //展示多少个赞的label
    self.zanLabel = [[UILabel alloc]init];
    [self addSubview:self.zanLabel];
    self.zanLabel.frame = CGRectMake(-50 ,- 100, 200, 40);
    self.zanLabel.hidden = YES;
    
    //添加点击事件
    //点一下
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressOnece:)]];
    //长按
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)]];
    
    [self setImage:[UIImage imageNamed:@"feed_like"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"feed_like_press"] forState:UIControlStateSelected];
    
    //设置暂时的layer
    _streamerLayer               = [CAEmitterLayer layer];
    _streamerLayer.emitterSize   = CGSizeMake(30, 30);
    _streamerLayer.masksToBounds = NO;
    _streamerLayer.renderMode = kCAEmitterLayerAdditive;
    [self.layer addSublayer:_streamerLayer];
}


/**
 点了一下

 @param ges 手势
 */
- (void)pressOnece:(UIGestureRecognizer *)ges
{
    UIButton * sender = (UIButton *)ges.view;
    sender.selected = !sender.selected;
    [self animation];
    [self performSelector:@selector(explode) withObject:nil afterDelay:0.1];
    if (sender.selected == NO) {
        countNum = 0;
        [self.imagesArr removeAllObjects];
        [self.CAEmitterCellArr removeAllObjects];
    }
}


/**
 长按

 @param ges 手势
 */
- (void)longPress:(UIGestureRecognizer *)ges
{
    UIButton * sender = (UIButton *)ges.view;
    sender.selected = YES;
    if (ges.state == UIGestureRecognizerStateBegan) {
        [self animation];
    }else if (ges.state == UIGestureRecognizerStateEnded)
    {
        [self explode];
    }
}

/**
 *  开始动画
 */
- (void)animation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    if (self.selected) {
        animation.values = @[@1.5 ,@0.8, @1.0,@1.2,@1.0];
        animation.duration = 0.5;
        [self startAnimate];
    }else
    {
        animation.values = @[@0.8, @1.0];
        animation.duration = 0.4;
    }
    animation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:animation forKey:@"transform.scale"];
}

/**
 *  开始喷射
 */
- (void)startAnimate {
    
    for (int i = 1; i < 10; i++)
    {
        //78张图片 随机选9张
        int x = arc4random() % 78;
        NSString * imageStr = [NSString stringWithFormat:@"emoji_%d",x];
        [self.imagesArr addObject:imageStr];
    }
    
    //设置展示的cell
    for (NSString * imageStr in self.imagesArr) {
        CAEmitterCell * cell = [self emitterCell:[UIImage imageNamed:imageStr] Name:imageStr];
        [self.CAEmitterCellArr addObject:cell];
    }
    _streamerLayer.emitterCells  = self.CAEmitterCellArr;
    
    
    // 开启计时器 设置点赞次数的label
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(changeText) userInfo:nil repeats:YES];
    self.zanLabel.hidden = NO;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@0.8, @1.0];
    animation.duration = 0.4;
    [self.zanLabel.layer addAnimation:animation forKey:@"transform.scale"];
    
    //_streamerLayer开始时间
    _streamerLayer.beginTime = CACurrentMediaTime();
    for (NSString * imgStr in self.imagesArr) {
        NSString * keyPathStr = [NSString stringWithFormat:@"emitterCells.%@.birthRate",imgStr];
        [_streamerLayer setValue:@5 forKeyPath:keyPathStr];
    }
    
}


/**
 *  停止喷射
 */
- (void)explode {
    //让chareLayer每秒喷射的个数为0个
    for (NSString * imgStr in self.imagesArr) {
        NSString * keyPathStr = [NSString stringWithFormat:@"emitterCells.%@.birthRate",imgStr];
        [self.streamerLayer setValue:@0 forKeyPath:keyPathStr];
    }
    _zanLabel.hidden = YES;
    [_timer invalidate];
    _timer = nil;
}



/**
 更改点赞个数label的文字
 */
- (void)changeText
{
    countNum ++;
    self.zanLabel.attributedText = [self getAttributedString:countNum];
    self.zanLabel.textAlignment = NSTextAlignmentCenter;
}


/**
 富文本设置label的图片内容
 
 @param num 当前赞的个数
 @return 要显示的富文本
 */
- (NSMutableAttributedString *)getAttributedString:(NSInteger)num
{
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
        b_attch.image = [UIImage imageNamed:[NSString stringWithFormat:@"multi_digg_num_%ld",bai]];
        b_attch.bounds = CGRectMake(0, 0, b_attch.image.size.width, b_attch.image.size.height);
        NSAttributedString *b_string = [NSAttributedString attributedStringWithAttachment:b_attch];
        [mutStr appendAttributedString:b_string];
    }
    
    //创建十位显示的图片
    if (!(shi == 0 && bai == 0)) {
        NSTextAttachment *s_attch = [[NSTextAttachment alloc] init];
        s_attch.image = [UIImage imageNamed:[NSString stringWithFormat:@"multi_digg_num_%ld",shi ]];
        s_attch.bounds = CGRectMake(0, 0, s_attch.image.size.width, s_attch.image.size.height);
        NSAttributedString *s_string = [NSAttributedString attributedStringWithAttachment:s_attch];
        [mutStr appendAttributedString:s_string];
    }
    
    //创建个位显示的图片
    if (ge >= 0) {
        NSTextAttachment *g_attch = [[NSTextAttachment alloc] init];
        g_attch.image = [UIImage imageNamed:[NSString stringWithFormat:@"multi_digg_num_%ld",ge]];
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



/**
 创建发射的表情cell
 
 @param image 传入随机的图片
 @param name 图片的名字
 @return cell
 */
- (CAEmitterCell *)emitterCell:(UIImage *)image Name:(NSString *)name
{
    CAEmitterCell * smoke = [CAEmitterCell emitterCell];
    smoke.birthRate = 0;//每秒出现多少个粒子
    smoke.lifetime = 2;// 粒子的存活时间
    smoke.lifetimeRange = 2;
    smoke.scale = 0.35;
    
    smoke.alphaRange = 1;
    smoke.alphaSpeed = -1.0;//消失范围
    smoke.yAcceleration = 450;//可以有下落的效果
    
    CGImageRef image2 = image.CGImage;
    smoke.contents= (__bridge id _Nullable)(image2);
    smoke.name = name; //设置这个 用来展示喷射动画 和隐藏
    
    smoke.velocity = 450;//速度
    smoke.velocityRange = 30;// 平均速度
    smoke.emissionLongitude = 3 * M_PI / 2 ;
    smoke.emissionRange = M_PI_2;//粒子的发散范围
    smoke.spin = M_PI * 2; // 粒子的平均旋转速度
    smoke.spinRange = M_PI * 2;// 粒子的旋转速度调整范围
    return smoke;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置发射点的位置
    _streamerLayer.position = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
}


- (NSMutableArray *)imagesArr
{
    if (_imagesArr == nil) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
}

- (NSMutableArray *)CAEmitterCellArr
{
    if (_CAEmitterCellArr == nil) {
        _CAEmitterCellArr = [NSMutableArray array];
    }
    return _CAEmitterCellArr;
}


@end
