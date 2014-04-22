//
//  DirectionPanGestureRecognizer.h
//  Plank
//
//  Created by zhoulong on 14-4-15.
//  Copyright (c) 2014年 zhoulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <uikit/UIGestureRecognizerSubclass.h>

typedef enum {
    DirectionPangestureRecognizerVertical,
    DirectionPanGestureRecognizerHorizontal
} DirectionPangestureRecognizerDirection;

@interface DirectionPanGestureRecognizer : UIPanGestureRecognizer {
    BOOL _drag;
    int _moveX;
    int _moveY;
    DirectionPangestureRecognizerDirection _direction;
}

@property (nonatomic, assign) DirectionPangestureRecognizerDirection direction;

@end
