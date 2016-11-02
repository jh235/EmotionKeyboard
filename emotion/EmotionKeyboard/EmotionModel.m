//
//  EmotionModel.m
//  emoji
//
//  Created by jianghong on 16/1/14.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import "EmotionModel.h"
#import <objc/runtime.h>

#define iKY_AUTO_SERIALIZATION  \
\
+ (NSArray *)propertyOfSelf{  \
unsigned int count = 0;  \
Ivar *ivarList = class_copyIvarList(self, &count); \
NSMutableArray *properNames =[NSMutableArray array]; \
for (int i = 0; i < count; i++) { \
Ivar ivar = ivarList[i]; \
NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)]; \
NSString *key = [name substringFromIndex:1]; \
[properNames addObject:key]; \
} \
free(ivarList); \
return [properNames copy];\
} \
- (void)encodeWithCoder:(NSCoder *)enCoder{ \
NSArray *properNames = [[self class] propertyOfSelf]; \
for (NSString *propertyName in properNames) { \
[enCoder encodeObject:[self valueForKey:propertyName] forKey:propertyName]; \
} \
} \
- (id)initWithCoder:(NSCoder *)aDecoder{ \
NSArray *properNames = [[self class] propertyOfSelf]; \
for (NSString *propertyName in properNames) { \
[self setValue:[aDecoder decodeObjectForKey:propertyName] forKey:propertyName]; \
} \
return  self; \
} \
- (NSString *)description{ \
NSMutableString *descriptionString = [NSMutableString stringWithFormat:@"\n"]; \
NSArray *properNames = [[self class] propertyOfSelf]; \
for (NSString *propertyName in properNames) { \
NSString *propertyNameString = [NSString stringWithFormat:@"%@ - %@\n",propertyName,[self valueForKey:propertyName]]; \
[descriptionString appendString:propertyNameString]; \
} \
return [descriptionString copy]; \
}


@implementation EmotionModel

iKY_AUTO_SERIALIZATION

+(instancetype)EmotionWithDict:(NSDictionary *)dict{
    id obj = [[self alloc]init];
    
    NSArray *properties = [self loadProperties];
    
    for (NSString *key in properties) {
        if (dict[key]) {
            [obj setValue:dict[key] forKey:key];
        }
        
    }
    
    return obj;
    
}

+(NSArray *)loadProperties{
    
    unsigned int count = 0;
    
    // 返回值是所有属性的数组
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; ++i) {
        // 1. 从数组中获得属性
        objc_property_t pty = properties[i];
        
        // 2. 拿到属性名称
        const char *cname = property_getName(pty);
        [arrayM addObject:[NSString stringWithUTF8String:cname]];
    }
    
    // 释放属性数组
    free(properties);
    
    return arrayM;
    
}

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
