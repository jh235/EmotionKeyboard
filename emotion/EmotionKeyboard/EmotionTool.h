//
//  EmotionTool.h
//  emoji
//
//  Created by jianghong on 16/1/15.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class EmotionModel;

@interface EmotionTool : NSObject

/**
 *  通过表情的描述字符串找到对应表情模型
 *
 *  @param chs <#chs description#>
 *
 *  @return <#return value description#>
 */
+ (EmotionModel *)emotionWithChs:(NSString *)chs;


/**
 *  添加最近表情到最近表情列表(集合)
 *
 *  @param emotion <#emotion description#>
 */
+ (void)addRecentEmotion:(EmotionModel *)emotion;


/**
 *  添加图片到收藏
 *
 *  @param url 图片url
 */
+ (void)addCollectImage:(NSString *)url;


/**
 *  获取最近表情列表
 *
 *  @return
 */
+ (NSArray *)recentEmotions;

/**
 *  默认表情
 *
 *  @return <#return value description#>
 */
+ (NSArray *)defaultEmotions;

/**
 *  emoji
 *
 *  @return <#return value description#>
 */
+ (NSArray *)emojiEmotions;

/**
 *  magic
 *
 *  @return
 */
+ (NSArray *)magicEmotions;

/**
 *  收藏图片
 *
 *  @return <#return value description#>
 */
+ (NSArray *)CollectImages;

/**
 *  删除收藏图片
 *
 *  @param url <#url description#>
 */
+ (void)delectCollectImage:(NSString *)url;

+ (UIImage *)emotionImageWithName:(NSString *)name;

+ (UIImage *)emotionImageWithPath:(NSString *)name;



@end
