//
//  KDFeedBackView.h
//  pocketplayer
//
//  Created by zhoulong on 14-1-1.
//  Copyright (c) 2014年 koudaiv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMFeedback.h"


@interface KDFeedBackView : UIView <UITableViewDataSource, UITableViewDelegate, UMFeedbackDataDelegate, UITextViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
        UMFeedback *_feedback;
        UITextView *_tvFeedbackText;
        UIButton *_btnSend;
        UIImageView *_bottomBar;
        CGFloat _keyboardY;
}

@property (nonatomic, retain) UITableView *tvFeedback;

@property (nonatomic, retain) NSMutableArray *dataArray;

@end
