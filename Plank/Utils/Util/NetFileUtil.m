//
//  NetFileUtil.m
//  Plank
//
//  Created by zhoulong on 14-4-17.
//  Copyright (c) 2014年 zhoulong. All rights reserved.
//

#import "NetFileUtil.h"

#define tab_max_grade @"tab_max_grade"
#define tab_grade     @"tab_grade"

#define devId @"devId"
#define date  @"date"
#define score @"score"

@implementation NetFileUtil

+ (void)editorMaxGrade:(unsigned long long)time {
    AVQuery *query = [AVQuery queryWithClassName:tab_max_grade];
    [query whereKey:devId equalTo:[NSUtil theUUID]];
    [query whereKey:date equalTo:[NSUtil theNowTimeDate:@"yyyy-MM-dd"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count) {
                AVObject *obj = objects[0];
                [obj setObject:[NSNumber numberWithUnsignedLongLong:time] forKey:score];
                [obj saveEventually];
                [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_CHART object:nil];
            } else {
                AVObject *grade = [AVObject objectWithClassName:tab_max_grade];
                [grade setObject:[NSNumber numberWithUnsignedLongLong:time] forKey:score];
                [grade setObject:[NSUtil theNowTimeDate:@"yyyy-MM-dd"] forKey:date];
                [grade setObject:[NSUtil theUUID] forKey:devId];
                [grade saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"保存成功");
                        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_CHART object:nil];
                    }
                }];
            }
        } else
            NSLog(@"error==%@", error);
    }];
}

+ (void)selectGrades:(int)dayCount findObjectsBlock:(void (^) (NSArray *objects, NSError *error))block{
    AVQuery *query = [AVQuery queryWithClassName:tab_max_grade];
    [query whereKey:devId equalTo:[NSUtil theUUID]];
    query.limit    = dayCount;
    [query orderByDescending:date];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
}

+ (void)selectBestGrade:(void (^) (NSArray *objects, NSError *error))block {
    AVQuery *query = [AVQuery queryWithClassName:tab_max_grade];
    [query whereKey:devId equalTo:[NSUtil theUUID]];
    [query orderByDescending:score];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
}
@end
