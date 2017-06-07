//
//  EmotionInputView.h
//  emotion
//
//  Created by jianghong on 2016/11/3.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmoticonInputViewDelegate <NSObject>
@optional

/**
 更多按钮点击

 @param index index
 */
- (void)emoticonInputViewMoreBoardBntClick:(NSInteger)index;

/**
 完成录音
 @param path 录音地址
 @param time 录音时长
 */
- (void)emoticonInputViewDidFinishRecoingVoiceActionWithPath:(NSString *)path time:(float)time;

/**
 发送按钮点击

 @param textBarText 输入框文字
 */
- (void)emoticonInputViewDidTapSend:(NSString *)textBarText;

/**
 *  点击了收藏图片
 *
 *  @param url 图片路径
 */
- (void)emoticonImageDidTapUrl:(NSString *)url;

/**
 *  点击了魔法表情
 *
 *  @param text 表情文字
 */
- (void)emoticonMagicEmotionDidTapText:(NSString *)text;




@end

@class RFTextView;
@class KKVoiceRecordHUD;
@class KKVoiceRecordHelper;

@interface EmotionInputView : UIView

@property (nonatomic, weak) id<EmoticonInputViewDelegate> delegate;

@property (nonatomic, strong) RFTextView *textView;
@property (strong, nonatomic) UIButton *plusBtn;
@property (strong, nonatomic) UIButton *emojiBtn;
@property (strong, nonatomic) UIButton *voiceBtn;
@property (strong, nonatomic) UIButton *voicePressBtn;

@property (nonatomic, strong, readwrite) KKVoiceRecordHUD *voiceRecordHUD; //录音提示
@property (nonatomic, strong) KKVoiceRecordHelper *voiceRecordHelper; //录音管理工具
@property (nonatomic) BOOL isMaxTimeStop; //判断是不是超出了录音最大时长

@property (assign, nonatomic) BOOL isCancleRecord;
@property (assign, nonatomic) BOOL isRecording;

@end
