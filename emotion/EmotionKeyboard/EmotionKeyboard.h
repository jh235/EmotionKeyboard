//
//  EmotionKeyboard.h
//  emoji
//
//  Created by jianghong on 16/1/14.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Emoji.h"
#import "EmotionTool.h"
#import "EmotionModel.h"

/**
 *  屏幕宽度
 */
#define ScreenW [UIScreen mainScreen].bounds.size.width
/**
 *  屏幕高度
 */
#define ScreenH [UIScreen mainScreen].bounds.size.height

@protocol EmoticonViewDelegate <NSObject>
@optional
/**
 *  获取图片对应文字
 *
 *  @param text 文字
 */
- (void)emoticonInputDidTapText:(NSString *)text;

/**
 *  获取收藏图片表情对应的url
 *
 *  @param url 图片路径
 */
- (void)emoticonCollectImageDidTapUrl:(NSString *)url;
/**
 *  获取魔法图片表情对应的url
 *
 *  @param url 图片路径
 */
- (void)emoticonMagicEmotionDidTapText:(NSString *)text;

/**
 *  删除表情
 */
- (void)emoticonInputDidTapBackspace;
/**
 *  发送表情
 */
- (void)emoticonInputDidTapSend;
@end


@interface EmotionKeyboard : UIView

@property (nonatomic, weak) id<EmoticonViewDelegate> delegate;
+ (instancetype)sharedEmotionKeyboardView;
- (instancetype)initWithDefault;
- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;


@end
