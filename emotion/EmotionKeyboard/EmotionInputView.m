//
//  EmotionInputView.m
//  emotion
//
//  Created by jianghong on 2016/11/3.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import "EmotionInputView.h"
#import "EmotionKeyboard.h"
#import "UIView+Extension.h"
#import "RFTextView.h"
#import "KKVoiceRecordHUD.h"
#import "KKVoiceRecordHelper.h"
#import "EmotionTool.h"

#define App_Height [[UIScreen mainScreen] bounds].size.height //主屏幕的高度
#define App_Width  [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;
#define RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]


@interface EmotionInputView ()<UITextViewDelegate,UIScrollViewDelegate,EmoticonViewDelegate,keyInputTextFieldDelegate>

@property (assign, nonatomic) BOOL isTextMaxH; //当文字大于限定高度之后的状态
@property (nonatomic, strong) UIView *backGroundView;
@property (strong, nonatomic) UILabel *lineLbl;
@property(nonatomic, strong) UIView *moreBoard;
@property(nonatomic, strong) EmotionKeyboard *emotionKeyboard;
@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, assign) CGFloat previousTextViewHeight;
@property (assign, nonatomic) CGFloat currentTextViewH;
/** 临时记录输入的textView */
@property (nonatomic, copy) NSString *currentText;
@property (nonatomic, copy) NSString *tempText;



@end


@implementation EmotionInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUI];
        
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

#pragma mark - 录音按钮点击
- (void)voiceBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) { //语音状态
        self.voicePressBtn.hidden = NO;
        self.voicePressBtn.centerY = self.voiceBtn.centerY;
        self.frame = CGRectMake(0, App_Height - 49, self.width, 49);
        
        self.voiceBtn.centerY = self.height * 0.5;
        self.voicePressBtn.centerY = self.height * 0.5;
        self.emojiBtn.centerY = self.height * 0.5;
        self.plusBtn.centerY = self.height * 0.5;
        self.lineLbl.bottom = self.height;
        self.textView.hidden = YES;
        [self.textView resignFirstResponder];

    }else{ //文字状态
        self.voicePressBtn.hidden = YES;
        self.textView.hidden = NO;
        
        self.height = self.textView.height + 13;
    
        self.backGroundView.height = self.textView.bottom + 6.5;
        self.lineLbl.bottom = self.backGroundView.height;
        self.voiceBtn.centerY = self.textView.centerY;
        self.emojiBtn.centerY = self.textView.centerY;
        self.plusBtn.centerY = self.textView.centerY;
        
        [self.textView becomeFirstResponder];
    

    }
}
#pragma mark - 表情按钮点击
- (void)emojiBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (!self.voicePressBtn.isHidden) {
        self.voicePressBtn.hidden = YES;
        self.textView.hidden = NO;
        self.voiceBtn.selected = NO;
    }
    
    if (self.textView.inputView == nil || self.textView.inputView == self.moreBoard ) {
        self.textView.inputView = self.emotionKeyboard;
         [self.textView reloadInputViews];
        if (!self.textView.isFirstResponder) {
            [self.textView becomeFirstResponder];
        }
    }else{
        self.textView.inputView = nil;
        [self.textView reloadInputViews];
        if (!self.textView.isFirstResponder) {
            [self.textView becomeFirstResponder];
        }
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.textView reloadInputViews];
//    });
    


}

#pragma mark - 更多按钮点击
- (void)plusBtnClick:(UIButton *)sender{
     sender.selected = !sender.selected;
    
    if (!self.voicePressBtn.isHidden) {
        self.voicePressBtn.hidden = YES;
        self.textView.hidden = NO;
        self.voiceBtn.selected = NO;
    }
    self.emojiBtn.selected = NO;
    
    if (self.textView.inputView == nil || self.textView.inputView == self.emotionKeyboard ) {
        self.textView.inputView = self.moreBoard;
        [self.textView reloadInputViews];
        if (!self.textView.isFirstResponder) {
            [self.textView becomeFirstResponder];
        }
    }else{
        self.textView.inputView = nil;
        [self.textView reloadInputViews];
        if (!self.textView.isFirstResponder) {
            [self.textView becomeFirstResponder];
        }
    }
    
//[self.textView reloadInputViews];
}

#pragma mark - 键盘各种状
-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    
        NSValue *rectValue =  notification.userInfo[UIKeyboardFrameEndUserInfoKey];
        
        CGRect rect = [rectValue CGRectValue];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.y = rect.origin.y - self.height;
            
        }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if ([self.delegate respondsToSelector:@selector(emoticonInputViewDidTapSend:)])
        {
            self.currentText = @"";
            [self.delegate emoticonInputViewDidTapSend:textView.text];
            self.textView.text = @"";
        }
        return NO;
    }
    
    if ([text isEqualToString:@""]) {
        self.tempText = textView.text;
//        [self emoticonInputDidTapBackspace];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.currentText = textView.text;
    
}

#pragma mark - kvo回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"self.textView.contentSize"]) {
        [self layoutAndAnimateTextView:self.textView];
    }
}

#pragma mark -- 私有方法

- (void)adjustTextViewContentSize
{
    //调整 textView和recordBtn frame
    self.currentText = self.textView.text;
    self.textView.text = @"";
    self.textView.contentSize = CGSizeMake(CGRectGetWidth(self.textView.frame), 36);
    self.voiceBtn.frame = CGRectMake(self.textView.frame.origin.x, 6.5, self.textView.frame.size.width, 36);
}

- (void)resumeTextViewContentSize
{
    self.textView.text = self.currentText;
}


#pragma mark -- 计算textViewContentSize改变

- (CGFloat)getTextViewContentH:(RFTextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

- (CGFloat)fontWidth
{
    return 36.f; //16号字体
}

- (CGFloat)maxLines
{
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    CGFloat line = 5;
    if (h == 480) {
        line = 3;
    }else if (h == 568){
        line = 3.5;
    }else if (h == 667){
        line = 4;
    }else if (h == 736){
        line = 4.5;
    }
    return line;
}

- (void)layoutAndAnimateTextView:(RFTextView *)textView
{
    CGFloat maxHeight = [self fontWidth] * [self maxLines];
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < self.previousTextViewHeight;
    CGFloat changeInHeight = contentH - self.previousTextViewHeight;
    
    if (!isShrinking && (self.previousTextViewHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             if (!isShrinking) {
                                 
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        self.previousTextViewHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    //动态改变自身的高度和输入框的高度
    CGRect prevFrame = self.textView.frame;
    
    NSUInteger numLines = MAX([self.textView numberOfLinesOfText],
                              [[self.textView.text componentsSeparatedByString:@"\n"] count] + 1);
    
    
    CGRect inputViewFrame = self.frame;
    
    self.frame = CGRectMake(0, inputViewFrame.origin.y - changeInHeight , inputViewFrame.size.width, inputViewFrame.size.height + changeInHeight);
    
    
    self.textView.frame = CGRectMake(prevFrame.origin.x, 6.5, prevFrame.size.width, prevFrame.size.height + changeInHeight);
    
    self.backGroundView.height = self.textView.bottom + 6.5;
    self.lineLbl.bottom = self.backGroundView.height;
    self.voiceBtn.centerY = self.textView.centerY;
    self.emojiBtn.centerY = self.textView.centerY;
    self.plusBtn.centerY = self.textView.centerY;
    
    self.textView.contentInset = UIEdgeInsetsMake((numLines >=6 ? 4.0f : 0.0f), 0.0f, (numLines >=6 ? 4.0f : 0.0f), 0.0f);
    
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    //self.messageInputTextView.scrollEnabled = YES;
    if (numLines >=6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.textView.contentSize.height-self.textView.bounds.size.height);
        [self.textView setContentOffset:bottomOffset animated:YES];
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length-2, 1)];
    }
}


#pragma mark - 发送按钮 回车


#pragma mark - 录音按钮各种点击状态
- (void)holdDownButtonTouchDown {
    self.isCancleRecord = NO;
    self.isRecording = NO;
    
    [self.voiceRecordHelper prepareRecordingWithPath:[self getRecorderPath] prepareRecorderCompletion:^BOOL{
        WEAKSELF
        //這邊要判斷回調回來的時候, 使用者是不是已經早就鬆開手了
        if (weakSelf && !weakSelf.isCancleRecord) {
            weakSelf.isRecording = YES;
            [weakSelf didStartRecordingVoiceAction];
            return YES;
        } else {
            NSLog(@"说话时间太短");
            return NO;
        }
    }];
}

- (void)holdDownButtonTouchUpOutside {
    //如果已經開始錄音了, 才需要做取消的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        
        WEAKSELF
        [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
            weakSelf.voiceRecordHUD = nil;
        }];
        [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
        }];
    } else {
        self.isCancleRecord = YES;
    }
}

- (void)holdDownButtonTouchUpInside {
    //如果已經開始錄音了, 才需要做結束的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        
        if (self.isMaxTimeStop == NO) {
            [self finishRecorded];
        } else {
            self.isMaxTimeStop = NO;
        }
    } else {
        self.isCancleRecord = YES;
    }
}

- (void)holdDownDragOutside {
    //如果已經開始錄音了, 才需要做拖曳出去的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        
        [self.voiceRecordHUD resaueRecord];

    } else {
        self.isCancleRecord = YES;
    }
}

- (void)holdDownDragInside {
    //如果已經開始錄音了, 才需要做拖曳回來的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        
        [self.voiceRecordHUD pauseRecord];

    } else {
        self.isCancleRecord = YES;
    }
}

#pragma mark - 发送音频代理

//开始录音
- (void)didStartRecordingVoiceAction {
    [self.voiceRecordHUD startRecordingHUDAtView:self.superview];
    [self.voiceRecordHelper startRecordingWithStartRecorderCompletion:^{
    }];
}

- (void)finishRecorded {
    WEAKSELF
    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        NSString *time = weakSelf.voiceRecordHelper.recordDuration;
        NSString *path = weakSelf.voiceRecordHelper.recordPath;
        
        if ([weakSelf.delegate respondsToSelector:@selector(emoticonInputViewDidFinishRecoingVoiceActionWithPath:time:)]) {
            
            [weakSelf.delegate emoticonInputViewDidFinishRecoingVoiceActionWithPath:path time:[time floatValue]];
        }
        
        NSLog(@"path:%@ time: %@",path,time);
    }];
}
//录音文件地址
- (NSString *)getRecorderPath {
    NSString *recorderPath = nil;
    
   recorderPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/chat/audio"];
    
   BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:recorderPath
                                   withIntermediateDirectories:YES attributes:nil error:nil];
    NSAssert(bo,@"创建目录失败");
    recorderPath = [recorderPath stringByAppendingFormat:@"%d.caf",(int)[NSDate date].timeIntervalSince1970];
    
    return recorderPath;
}


#pragma mark - FaceBoardDelegateMethods

/**
 *  删除表情
 */
- (void)emoticonInputDidTapBackspace
{
    [self delectTextWithText:_textView.text];
}

- (void)deleteBackward{

    [self delectTextWithText:self.tempText];
   
}

- (void)delectTextWithText:(NSString *)text{
    
    NSString* inputString;
    inputString = text;
    NSString* string = nil;
    NSInteger stringLength = inputString.length;
    
    if (stringLength > 0) {
        if (stringLength == 1 || stringLength == 2) {//只有1个或2个字符时
            if ([inputString isEmoji]) {//emoji
                string = @"";
            }else {//普通字符
                string = [inputString substringToIndex:stringLength - 1];
            }
        }else if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength - 1]]) {//默认表情
            
            if ([inputString rangeOfString:@"["].location == NSNotFound) {
                string = [inputString substringToIndex:stringLength - 1];
            }else {
                string = [inputString substringToIndex:[inputString rangeOfString:@"["options:NSBackwardsSearch].location];
            }
        }else if ([[inputString substringFromIndex:stringLength - 1] isEmoji] || [[inputString substringFromIndex:stringLength - 2] isEmoji]) {//末尾是emoji
            
            if ([[inputString substringFromIndex:stringLength - 2] isEmoji]) {
                string = [inputString substringToIndex:stringLength - 2];
            }else if ([[inputString substringFromIndex:stringLength - 1] isEmoji]) {
                string = [inputString substringToIndex:stringLength - 1];
            }
        }else {//是普通文字
            string = [inputString substringToIndex:stringLength - 1];
        }
    }
    _textView.text = string;
    
}

/**
 *  发送表情
 */
- (void)emoticonInputDidTapSend
{
    if (![self isBlankString:_textView.text]) {
        
        if ([self.delegate respondsToSelector:@selector(emoticonInputViewDidTapSend:)]) {
            [self.delegate emoticonInputViewDidTapSend:_textView.text];
            self.textView.text = @"";
        }
//        [_delegate returnBtnClickWithKeyboardType:EMOJI_CONTENT_TYPE];
    }
}

/**
 *  获取表情对应字符
 *
 *  @param text 表情对应字符串
 */
- (void)emoticonInputDidTapText:(NSString*)text
{
    [_textView insertText:text];
}

- (void)emoticonCollectImageDidTapUrl:(NSString *)url{
    if ([self.delegate respondsToSelector:@selector(emoticonImageDidTapUrl:)]) {
        [self.delegate emoticonImageDidTapUrl:url];
    }
}

- (void)emoticonMagicEmotionDidTapText:(NSString *)text{
    if ([self.delegate respondsToSelector:@selector(emoticonMagicEmotionDidTapText:)]) {
        [self.delegate emoticonMagicEmotionDidTapText:text];
    }
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}


#pragma mark - 更多按钮代理

- (void)moreBoardBntClick:(id)sender {
    UIButton *btn = (UIButton *)sender;

    if ([_delegate respondsToSelector:@selector(emoticonInputViewMoreBoardBntClick:)]) {
        [_delegate emoticonInputViewMoreBoardBntClick:btn.tag - 200];
    }
}


#pragma mark - UI

- (void)setUI{
//    [self addSubview:self.backGroundView];
    self.previousTextViewHeight = 36;
    [self.backGroundView addSubview:self.plusBtn];
    [self.backGroundView addSubview:self.emojiBtn];
    
    self.lineLbl.width = self.width;
    self.lineLbl.bottom = self.backGroundView.bottom;
    self.lineLbl.height = 0.5;
    
    self.voiceBtn.x = 10;
    self.voiceBtn.width = 30;
    self.voiceBtn.height = 30;
    self.voiceBtn.centerY = self.backGroundView.centerY;
    
    self.plusBtn.width = 30;
    self.plusBtn.height = 30;
    self.plusBtn.right = self.width - 10;
    self.plusBtn.centerY = self.backGroundView.centerY;
    
    self.emojiBtn.size = CGSizeMake(30, 30);
    self.emojiBtn.right = self.plusBtn.x - 10;
    self.emojiBtn.centerY = self.backGroundView.centerY;
//    
    self.textView.size = CGSizeMake(self.width - 140, 38);
    self.textView.x = self.voiceBtn.right + 10;

    self.textView.bottom = self.backGroundView.bottom - 6;
//
    self.voicePressBtn.x = self.voiceBtn.right + 10;
    self.voicePressBtn.centerY = self.voiceBtn.centerY;
    self.voicePressBtn.size = CGSizeMake(self.width - 140, 38);
    
    
    [self addObserver:self forKeyPath:@"self.textView.contentSize" options:(NSKeyValueObservingOptionNew) context:nil];
    
}

#pragma mark - 懒加载控件
- (UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, App_Width, 49)];
        [self addSubview:_backGroundView];
        _backGroundView.backgroundColor = RGB(0xf6f6f6);
        
    }
    return _backGroundView;
}
- (RFTextView *)textView{
    if (!_textView) {
        _textView = [[RFTextView alloc]init];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
        _textView.keyInputDelegate = self;
        _textView.layer.cornerRadius = 5;
        _textView.returnKeyType =  UIReturnKeySend;
        _textView.placeHolder = @"说点什么吧...";
        [self.backGroundView addSubview:_textView];
    }
    return _textView;
}
- (UIButton *)plusBtn {
    if (_plusBtn == nil) {
        _plusBtn = [[UIButton alloc]init];
        [_plusBtn setImage:[EmotionTool emotionImageWithName:@"IM_plus"] forState:UIControlStateNormal];
        [_plusBtn addTarget:self action:@selector(plusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusBtn;
}

- (UIButton *)emojiBtn {
    if (_emojiBtn == nil) {
        _emojiBtn = [[UIButton alloc]init];
        [_emojiBtn setImage:[EmotionTool emotionImageWithName:@"face"] forState:UIControlStateNormal];
        [_emojiBtn setImage:[EmotionTool emotionImageWithName:@"word"] forState:UIControlStateSelected];
        [_emojiBtn addTarget:self action:@selector(emojiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiBtn;
}

- (EmotionKeyboard *)emotionKeyboard{
    if (!_emotionKeyboard) {
        _emotionKeyboard = [[EmotionKeyboard alloc]init];
        _emotionKeyboard.delegate = self;
    }
    return _emotionKeyboard;
}

- (UIView *)moreBoard{
    if (!_moreBoard) {
        _moreBoard = [[UIView alloc]initWithFrame:CGRectMake(0, 0, App_Width, 226)];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, App_Width, 226)];
        scrollView.backgroundColor = RGBCOLOR(235, 235, 237);
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        //开启分页
        scrollView.pagingEnabled = YES;
        //设置代理
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(scrollView.width * 2,scrollView.height);
        [_moreBoard addSubview:scrollView];
        
        //添加uipageControl
        UIPageControl *control = [[UIPageControl alloc] init];
        control.size = CGSizeMake(_moreBoard.width, 16);
        control.bottom = _moreBoard.height - 10 ;
//        control.numberOfPages = 2;
        control.backgroundColor = RGBCOLOR(235, 235, 237);
        
        [control setCurrentPageIndicatorTintColor:RGBCOLOR(134, 134, 134)];
        [control setPageIndicatorTintColor:RGBCOLOR(180, 180, 180)];
        self.pageControl = control;
        
        [_moreBoard addSubview:control];
        
        NSArray *imageArr = [NSArray arrayWithObjects:
                             @"piazza_keyboard_commer",
                             @"piazza_keyboard_Image",
                             @"piazza_keyboard_vodio",
                             @"piazza_keyboard_gift",
                             @"piazza_keyboard_location",
                             @"piazza_keyboard_redEnvelope",
                             @"piazza_keyboard_clear",
                             @"piazza_keyboard_report",
                             nil];
        
        NSInteger page = (imageArr.count + 8 - 1 )/ 8 ;
        
        if (page > 1) {
            
            control.numberOfPages = page;
        }
        scrollView.contentSize = CGSizeMake(scrollView.width * page,scrollView.height);
        
        for (int i = 0; i < imageArr.count; i ++) {
            
            UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [moreBtn addTarget:self action:@selector(moreBoardBntClick:) forControlEvents:UIControlEventTouchUpInside];
            [moreBtn setBackgroundImage:[EmotionTool emotionImageWithName:imageArr[i]] forState:UIControlStateNormal];
            [moreBtn sizeToFit];
            
            CGFloat margin = (App_Width - moreBtn.width * 4 ) / 5 ;
            
            int row = i / 4;
            int col = i % 4;
            CGFloat x = margin + (moreBtn.width + margin) * col;
            CGFloat y = 25 + (moreBtn.height + 25) * row;

            if (i < 8) {
                
                moreBtn.origin = CGPointMake(x,y);
                
            }else{
                
                moreBtn.origin = CGPointMake(_moreBoard.width + margin, 25);
            }
            moreBtn.tag = i + 200;
            [scrollView addSubview:moreBtn];
        }
        
    }
    return _moreBoard;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat page = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(page + 0.5);
    
}

- (UILabel *)lineLbl {
    if (_lineLbl == nil) {
        _lineLbl = [[UILabel alloc]init];
        _lineLbl.backgroundColor = RGB(0xe5e5e5);
        [self addSubview:_lineLbl];
    }
    return _lineLbl;
}

- (UIButton *)voiceBtn {
    if (_voiceBtn == nil) {
        _voiceBtn = [[UIButton alloc]init];
        _voiceBtn.titleLabel.textColor = RGB(0x666666);
        _voiceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voiceBtn setImage:[EmotionTool emotionImageWithName:@"voice"] forState:UIControlStateNormal];
        [_voiceBtn setImage:[EmotionTool emotionImageWithName:@"word"] forState:UIControlStateSelected];
        [self addSubview:_voiceBtn];
        [_voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}
- (UIButton *)voicePressBtn {
    if (_voicePressBtn == nil) {
        _voicePressBtn = [[UIButton alloc]init];
        [_voicePressBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_voicePressBtn setTitleColor:RGB(0x666666) forState:UIControlStateNormal];
        _voicePressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _voicePressBtn.layer.borderColor = RGB(0x666666).CGColor;
        _voicePressBtn.layer.borderWidth = 0.5;
        _voicePressBtn.layer.cornerRadius = 5;
        [_voicePressBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [_voicePressBtn setBackgroundImage:[EmotionTool emotionImageWithName:@"im_input_voice_normal"] forState:UIControlStateNormal];
        [_voicePressBtn setBackgroundImage:[EmotionTool emotionImageWithName:@"im_input_voice_highlited"] forState:UIControlStateHighlighted];
        [self addSubview:_voicePressBtn];
        _voicePressBtn.hidden = YES;
        _voicePressBtn.backgroundColor = RGB(0xf6f6f6);
        
        [_voicePressBtn addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_voicePressBtn addTarget:self action:@selector(holdDownButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_voicePressBtn addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_voicePressBtn addTarget:self action:@selector(holdDownDragOutside) forControlEvents:UIControlEventTouchDragExit];
        [_voicePressBtn addTarget:self action:@selector(holdDownDragInside) forControlEvents:UIControlEventTouchDragEnter];
    }
    return _voicePressBtn;
}

//录音HUD
- (KKVoiceRecordHUD *)voiceRecordHUD {
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[KKVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
}
//录音
- (KKVoiceRecordHelper *)voiceRecordHelper {
    if (!_voiceRecordHelper) {
        _isMaxTimeStop = NO;
        
        WEAKSELF
        _voiceRecordHelper = [[KKVoiceRecordHelper alloc] init];
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            NSLog(@"已经达到最大限制时间了，进入下一步的提示");
            weakSelf.isMaxTimeStop = YES;
            //            [weakSelf finishRecorded]; //超时 直接发送
        };
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
            weakSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
        };
        _voiceRecordHelper.maxRecordTime = 60.0;
    }
    return _voiceRecordHelper;
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.textView.contentSize"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
