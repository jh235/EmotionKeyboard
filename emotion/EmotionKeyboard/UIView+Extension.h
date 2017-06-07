//
//  UIView+Extension.h
//  emoji
//
//  Created by jiang on 15/9/14.
//  Copyright (c) 2015年 jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
//宽高位置大小
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;


//中心点的x与y
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGPoint origin;



@end
