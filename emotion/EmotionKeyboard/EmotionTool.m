//
//  EmotionTool.m
//  emoji
//
//  Created by jianghong on 16/1/15.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import "EmotionTool.h"
#import "EmotionModel.h"

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


+ (NSArray *)loadResourceWithName:(NSString *)name{
    
    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"EmotionIcons.bundle" ofType:nil];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"%@/info.plist",name] ofType:@""];

    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    return array;
}

+ (UIImage *)emotionImageWithName:(NSString *)name{
    
    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"EmotionIcons.bundle" ofType:nil];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"%@@2x.png",name] ofType:@""];
    
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)emotionImageWithPath:(NSString *)name{
    
    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"EmotionIcons.bundle" ofType:nil];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    name = name.stringByDeletingPathExtension;
    
    NSLog(@"%@",bundle);
    
    NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"%@@2x",name] ofType:@"png"];

    return [UIImage imageWithContentsOfFile:path];
    
}


+ (NSArray *)defaultEmotions{
    //读取默认表情
    NSArray *array = [self loadResourceWithName:@"default"];
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        EmotionModel *model = [EmotionModel EmotionWithDict:dict];
        [arrayM addObject:model];
    }
    //给集合里面每一个元素都执行某个方法
    [arrayM makeObjectsPerformSelector:@selector(setPath:) withObject:@"EmotionIcons.bundle/default/"];
    
    return arrayM;
}

+ (NSArray *)emojiEmotions{
    //读取emoji表情
    NSArray *array = [self loadResourceWithName:@"emoji"];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        EmotionModel *model = [EmotionModel EmotionWithDict:dict];
        [arrayM addObject:model];
    }
    return arrayM;
}

+ (NSArray *)magicEmotions{
    //读取大表情
    NSArray *array = [self loadResourceWithName:@"GifEmoji"];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        EmotionModel *model = [EmotionModel EmotionWithDict:dict];
        [arrayM addObject:model];
    }
    //给集合里面每一个元素都执行某个方法
    [arrayM makeObjectsPerformSelector:@selector(setPath:) withObject:@"EmotionIcons.bundle/GifEmoji/"];
    return arrayM;
}

+ (void)delectCollectImage:(NSString *)url{
    
    [_collectImages removeObject:url];
    [NSKeyedArchiver archiveRootObject:[_collectImages copy] toFile:CollectImage_PAHT];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"delectCollectImage" object:nil];
    
}

@end
