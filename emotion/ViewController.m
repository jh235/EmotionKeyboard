//
//  ViewController.m
//  emotion
//
//  Created by jianghong on 16/1/25.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import "EmotionKeyboard.h"
#import "EmotionTool.h"
#import "NSString+Emoji.h"
#import "ViewController.h"

@interface ViewController () <EmoticonViewDelegate>

@property (nonatomic, weak) UITextField* textField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 200, 360, 44)];
    textField.backgroundColor = [UIColor lightGrayColor];

    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 300, 80, 40)];
    [btn setTitle:@"添加收藏" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    //    EmotionKeyboard *emotionKeyboard = [[EmotionKeyboard alloc]initWithFrame:CGRectMake(0, ScreenH - 235, ScreenW, 235)];

    //    EmotionKeyboard *emotionKeyboard = [[EmotionKeyboard alloc]init];

    //    EmotionKeyboard *emotionKeyboard = [[EmotionKeyboard alloc]initWithDefault];

    EmotionKeyboard* emotionKeyboard = [EmotionKeyboard sharedEmotionKeyboardView];
    emotionKeyboard.delegate = self;
    textField.inputView = emotionKeyboard;
    _textField = textField;

    [self.view addSubview:textField];
}

- (void)btnClick
{

    for (int i = 0; i < 18; i++) {
        NSString* url = [NSString stringWithFormat:@"http://77g9ox.com1.z0.glb.clouddn.com/gift_%d@2x.png", i + 1];

        [EmotionTool addCollectImage:url];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FaceBoardDelegateMethods
/**
 *  删除表情
 */
- (void)emoticonInputDidTapBackspace
{
    NSString* inputString;
    inputString = _textField.text;
    NSString* string = nil;
    NSInteger stringLength = inputString.length;

    if (stringLength > 0) {
        if (stringLength == 1 || stringLength == 2) { //只有1个或2个字符时
            if ([inputString isEmoji]) { //emoji
                string = @"";
            }
            else { //普通字符
                string = [inputString substringToIndex:stringLength - 1];
            }
        }
        else if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength - 1]]) { //默认表情

            if ([inputString rangeOfString:@"["].location == NSNotFound) {
                string = [inputString substringToIndex:stringLength - 1];
            }
            else {
                string = [inputString substringToIndex:[inputString rangeOfString:@"[" options:NSBackwardsSearch].location];
            }
        }
        else if ([[inputString substringFromIndex:stringLength - 1] isEmoji] || [[inputString substringFromIndex:stringLength - 2] isEmoji]) { //末尾是emoji

            if ([[inputString substringFromIndex:stringLength - 2] isEmoji]) {
                string = [inputString substringToIndex:stringLength - 2];
            }
            else if ([[inputString substringFromIndex:stringLength - 1] isEmoji]) {
                string = [inputString substringToIndex:stringLength - 1];
            }
        }
        else { //是普通文字
            string = [inputString substringToIndex:stringLength - 1];
        }
    }
    [_textField setText:string];
}

/**
 *  发送表情
 */
- (void)emoticonInputDidTapSend
{
    NSLog(@"发送");
    //    [self sendComment];
}

/**
 *  获取表情对应字符
 *
 *  @param text 表情对应字符串
 */
- (void)emoticonInputDidTapText:(NSString*)text
{
    [_textField insertText:text];
}
/**
 *  获取图片表情对应的url
 *
 *  @param url <#url description#>
 */
- (void)emoticonImageDidTapUrl:(NSString*)url
{
    NSLog(@"%@", url);
}

@end
