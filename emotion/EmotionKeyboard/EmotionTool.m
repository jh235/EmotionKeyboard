//
//  EmotionTool.m
//  emoji
//
//  Created by jianghong on 16/1/15.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import "EmotionTool.h"
#import "EmotionModel.h"
#import "MJExtension.h"

//最新表情的路径
#define RECENTEMOTIONS_PAHT [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recentemotions.archive"]

//收藏图片的路径
#define CollectImage_PAHT [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CollectImage.archive"]

#define CollectImage_path [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CollectImage"]


static NSMutableArray *_recentEmotions;
static NSMutableArray *_collectImages;

@interface EmotionTool()

//@property (nonatomic, strong) NSMutableArray *collectImages;

@end

@implementation EmotionTool

/**
 *  当你第一次要用到这个类的时候,这个initialize就会调用,而且只会调用1次
 */
+ (void)initialize{
    if (!_recentEmotions) {
        _recentEmotions = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:RECENTEMOTIONS_PAHT]];
    }
    if (!_collectImages) {
        _collectImages = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:CollectImage_PAHT]];
    }
    
}



+ (EmotionModel *)emotionWithChs:(NSString *)chs{
    
    
    //先遍历默认表情
    NSArray *defaultEmotions = [self defaultEmotions];
    for (EmotionModel *emotion in defaultEmotions) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    
    //再遍历浪小花表情
    NSArray *magicEmotions = [self magicEmotions];
    for (EmotionModel *emotion in magicEmotions) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    return nil;
}
/**
 *  添加收藏图片
 *
 *  @param url 图片url
 */
+ (void)addCollectImage:(NSString *)url{
    
     NSString *path = CollectImage_path;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
       [[NSFileManager defaultManager] createDirectoryAtPath:path
                                            withIntermediateDirectories:YES attributes:nil error:nil];
    }
    path = [path stringByAppendingPathComponent:url.lastPathComponent];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    BOOL result =[data writeToFile:path atomically:YES];
    if (result) {
        NSLog(@"添加收藏成功");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectImages removeObject:path];
            [_collectImages insertObject:path atIndex:0];
            [NSKeyedArchiver archiveRootObject:[_collectImages copy] toFile:CollectImage_PAHT];
        });
    }else{
       NSLog(@"添加收藏失败");
    }
    
    });
}


+ (NSArray *)CollectImages{
    return _collectImages;
}

+ (void)addRecentEmotion:(EmotionModel *)emotion{
    
    NSString *path = RECENTEMOTIONS_PAHT;
    [_recentEmotions removeObject:emotion];
    [_recentEmotions insertObject:emotion atIndex:0];
    
    //3.保存
    [NSKeyedArchiver archiveRootObject:[_recentEmotions copy] toFile:path];
}



+ (NSArray *)recentEmotions{

    return _recentEmotions;
   
}


+ (NSArray *)defaultEmotions{
    //读取默认表情
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:@""];
    NSArray *emotions = [EmotionModel objectArrayWithFile:path];
    
    //给集合里面每一个元素都执行某个方法
    [emotions makeObjectsPerformSelector:@selector(setPath:) withObject:@"EmotionIcons/default/"];
    
    return emotions;
}

+ (NSArray *)emojiEmotions{
    //读取默认表情
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:@""];
    NSArray *emotions = [EmotionModel objectArrayWithFile:path];
    
    return emotions;
}


+ (NSArray *)magicEmotions{
    //读取默认表情
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/GifEmoji/info.plist" ofType:@""];
    NSArray *emotions = [EmotionModel objectArrayWithFile:path];
    
    //给集合里面每一个元素都执行某个方法
    [emotions makeObjectsPerformSelector:@selector(setPath:) withObject:@"EmotionIcons/GifEmoji/"];
    return emotions;
}



+ (void)delectCollectImage:(NSString *)url{
    
    [_collectImages removeObject:url];
    [NSKeyedArchiver archiveRootObject:[_collectImages copy] toFile:CollectImage_PAHT];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"delectCollectImage" object:nil];
    
}



@end
