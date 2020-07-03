//
//  GXUpvoteButton.h
//
//  Created by apple on 2017/12/19.
//  Copyright © 2017年 getElementByYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GXUpvoteButtonDelegate <NSObject>

/// 按钮点击的回调
/// @param sender sender description
- (void)upvoteBtnTouchUpInsideAction:(UIButton *)sender;

/// 按钮开始长按的回调
/// @param sender sender description
- (void)upvoteBtnLongPressStateBeganAction:(UIButton *)sender;

@end

@interface GXUpvoteButton : UIButton

@property (nonatomic,weak) id<GXUpvoteButtonDelegate> delegate;


@end
