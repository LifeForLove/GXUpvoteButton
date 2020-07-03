# GXUpvoteButton
仿今日头条点赞喷射表情动画

### 简述

	 核心代码主要是使用CAEmitterLayer来实现，通过设置CAEmitterCell的各种属性，来达到粒子发射的效果，相比今日头条的点赞效果，我只能说比较接近，多少还是有点差距，后续仍在不断完善中。
	 代码内容比较简短，所以没有做成第三方pod，代码中的点赞次数提示，主要是仿照今日头条的效果，逻辑稍微有点绕，大家可自行根据需求修改效果。

		
### 效果图

![image](https://github.com/LifeForLove/GXUpvoteButton/blob/master/QQ20171220-104707-HD.gif)

### 使用方法

非cell

```

GXUpvoteButton *upvoteButton = [GXUpvoteButtonbuttonWithType:UIButtonTypeCustom];
[self.view addSubview:upvoteButton];
    
```

cell中使用(主要要实现两个代理方法的回调，在此感谢melo30这位老哥提供的解决方案)

```
- (void)upvoteBtnTouchUpInsideAction:(UIButton *)sender {
    [self.superview bringSubviewToFront:self];
}

- (void)upvoteBtnLongPressStateBeganAction:(UIButton *)sender {
    [self.superview bringSubviewToFront:self];
}
```

### Author

如果使用中遇到任何问题欢迎加我微信ios_gx,如果觉得写得还行欢迎star。

getElementByYou@163.com



