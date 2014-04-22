//
//  ResultViewController.h
//  Plank
//
//  Created by zhoulong on 14-4-15.
//  Copyright (c) 2014年 zhoulong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CalculateTypeCal = 0,
    CalculateTypeCha
}CalculateType;

typedef enum {
    ChallengeTypeSuccess = 0,
    ChallengeTypeFiled
}ChallengeType;


@interface ResultViewController : UIViewController

@property (nonatomic) CalculateType calType;
@property (nonatomic) CalculateType challenge;
@property (nonatomic) unsigned long long total;

@property (nonatomic, strong) UIImage *screenShot;

@end
