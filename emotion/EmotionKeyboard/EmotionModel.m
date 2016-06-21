//
//  EmotionModel.m
//  emoji
//
//  Created by jianghong on 16/1/14.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import "EmotionModel.h"
#import "MJExtension.h"


@implementation EmotionModel

MJCodingImplementation

- (void)setPath:(NSString *)path{
    _path = path;
    self.fullPath = [NSString stringWithFormat:@"%@%@",self.path,self.png];
}

- (void)setType:(NSString *)type{
    _type = type;
    if ([type isEqualToString:@"1"]) {
        self.isEmoji = YES;
    }
    if ([type isEqualToString:@"1"]||[type isEqualToString:@"0"]) {
        self.isDefault = YES;
    }
}

/**
 *  告诉系统当前对象与系统传入进来的对象是否是同一个对象
 *
 *  @param object <#object description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)isEqual:(EmotionModel *)object{
    if ([self.chs isEqualToString:object.chs] || [self.code isEqualToString:object.code]) {
        return YES;
    }else{
        return NO;
    }
}

@end
