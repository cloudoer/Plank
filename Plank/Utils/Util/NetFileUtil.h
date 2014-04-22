//
//  NetFileUtil.h
//  Plank
//
//  Created by zhoulong on 14-4-17.
//  Copyright (c) 2014年 zhoulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetFileUtil : NSObject

//更新每日最大分数
+ (void)editorMaxGrade:(unsigned long long)time;

//查询最新的记录
+ (void)selectGrades:(int)dayCount findObjectsBlock:(void (^) (NSArray *objects, NSError *error))block;

//最高得分
+ (void)selectBestGrade:(void (^) (NSArray *objects, NSError *error))block;

@end
