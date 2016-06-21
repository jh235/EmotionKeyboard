//
//  EmotionModel.h
//  emoji
//
//  Created by jianghong on 16/1/14.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EmoticonGroup;

typedef NS_ENUM(NSUInteger, EmoticonType) {
    EmoticonTypeImage = 0,    ///< 图片表情
    EmoticonTypeEmoji = 1,    ///< Emoji表情
    EmoticonTypeBigImage = 2  ///< 大表情
};

@interface EmotionModel : NSObject<NSCoding>

/**
 *  表情对应的中文描述
 */
@property (nonatomic, copy) NSString *chs;

/**
 *  表情对应的繁体中文描述
 */
@property (nonatomic, copy) NSString *cht;

/**
 *  图片名字
 */
@property (nonatomic, copy) NSString *png;

/**
 *  emoji表情的code
 */
@property (nonatomic, copy) NSString *code;

/**
 *  如果type等于0.代表是图片表情,否则为emoji表情
 */
@property (nonatomic, copy) NSString *type;


/**
 *  表情对应的路径
 */
@property (nonatomic, copy) NSString *path;


@property (nonatomic, copy) NSString *fullPath;

/**
 *  是否是emoji表情
 */
@property (nonatomic, assign) BOOL isEmoji;

/**
 *  是否为默认
 */
@property (nonatomic, assign) BOOL isDefault;

@end



