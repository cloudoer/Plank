//
//  KDFeedBackView.m
//  pocketplayer
//
//  Created by zhoulong on 14-1-1.
//  Copyright (c) 2014年 koudaiv. All rights reserved.
//

#import "KDFeedBackView.h"
#import "UIView+Util.h"
#import "KDFeedbackCell.h"

#define Font [UIFont systemFontOfSize:16]
#define StringWidth 200

#define kLinePixel  0.6
#define kColorLine      [UIColor colorWithWhite:0 alpha:0.1]
#define kDeviceSystemVersion [[UIDevice currentDevice].systemVersion floatValue]

#define UMENG_KEY @"534e44d256240bef0801bc59"

@implementation KDFeedBackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        //监听键盘
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        //友盟反馈
        _feedback = [UMFeedback sharedInstance];
        [_feedback setAppkey:UMENG_KEY delegate:self];
        
        [self getData];
        
        UIImage *imgSend = [UIImage imageNamed:@"bg_feedback_btn_send"];
        
        // 反馈条
        _bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, imgSend.size.height + 10)];
        _bottomBar.userInteractionEnabled = YES;
        _bottomBar.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        _bottomBar.maxY = self.height;
        if (kDeviceSystemVersion < 7.) {
            _bottomBar.maxY -= 44;
        }
        
        _bottomBar.layer.shadowColor = [UIColor blackColor].CGColor;
        _bottomBar.layer.shadowOffset = CGSizeZero;
        UIView *view = [[UIView alloc] initLineWithFrame:CGRectMake(0, 0, self.width, kLinePixel) color:kColorLine];
        [_bottomBar addSubview:view];
        [self addSubview:_bottomBar];

        
        // 发送按钮
        _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSend.frame = CGRectMake(self.width-imgSend.size.width-5, 5, imgSend.size.width, imgSend.size.height);
        [_btnSend setTitle:@"发送" forState:0];
        [_btnSend setBackgroundImage:imgSend forState:UIControlStateNormal];
        _btnSend.titleLabel.font = [UIFont systemFontOfSize:16];
        [_btnSend setTitleColor:[UIColor colorWithRed:50/255.0 green:93/255.0 blue:152/255.0 alpha:1] forState:UIControlStateNormal];
        [_btnSend setTitleColor:[UIColor colorWithRed:22/255.0 green:48/255.0 blue:87/255.0 alpha:1] forState:UIControlStateHighlighted];
        [_btnSend addTarget:self action:@selector(sendFeedback:) forControlEvents:UIControlEventTouchUpInside];
        _btnSend.enabled = NO;
        [_bottomBar addSubview:_btnSend];
        
        // 反馈输入框
        _tvFeedbackText = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, _btnSend.minX-10, _btnSend.height)];
        _tvFeedbackText.delegate = self;
        _tvFeedbackText.layer.masksToBounds = YES;
        _tvFeedbackText.font = Font;
        _tvFeedbackText.layer.borderWidth =1.0;
        [[_tvFeedbackText layer] setCornerRadius:5];
        [[_tvFeedbackText layer] setBorderWidth:1];
        [[_tvFeedbackText layer] setBorderColor:kColorLine.CGColor];
        [_bottomBar addSubview:_tvFeedbackText];
       
        // 反馈内容tableView
        CGFloat y = 64;
        CGFloat marginHeight = 64;
        if (kDeviceSystemVersion < 7.f) {
            y = 0;
            marginHeight = 44;
        }
        _tvFeedback = [[UITableView alloc] initWithFrame:CGRectMake(0, y, self.width, self.height - _bottomBar.height - marginHeight)];
        _tvFeedback.delegate = self;
        _tvFeedback.dataSource = self;
        _tvFeedback.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tvFeedback.backgroundColor = [UIColor whiteColor];
        _tvFeedback.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        [self addSubview:_tvFeedback];

        
        UIControl *vRecoverBack = [[UIControl alloc] initWithFrame:_tvFeedback.bounds];
        [vRecoverBack addTarget:self action:@selector(tapCloseKeybroad) forControlEvents:UIControlEventTouchUpInside];
        vRecoverBack.backgroundColor = [UIColor clearColor];
        [_tvFeedback addSubview:vRecoverBack];

//        if (kDeviceSystemVersion >= 7. && DEVICE_HEIGHT < 500) {
//            CGRect frame = _bottomBar.frame;
//            frame.origin.y = _tvFeedback.maxY;
//            _bottomBar.frame = frame;
//        }
        //滑动到底部
        [self scrollToBottomAnimated:NO];
                       
    }
    return self;
}

/* 收回选择框 */
-(void)tapCloseKeybroad{
    
    if (_tvFeedbackText.isFirstResponder)
        [_tvFeedbackText resignFirstResponder];
}

#pragma mark - 发送反馈信息
- (void)sendFeedback:(UIButton *)bt
{
    if ([_tvFeedbackText hasText]) {
        bt.enabled = NO;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timeStr = [dateFormatter stringFromDate:[NSDate date]];

        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:_tvFeedbackText.text forKey:@"content"];
        [dictionary setObject:@"user_reply" forKey:@"type"];
        [dictionary setObject:timeStr forKey:@"datetime"];
        
        [_feedback post:dictionary];
    }
}

#pragma mark - Keyboard Methods
//显示键盘
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardRect = [self keyboardRect: notification];
    _keyboardY = self.height - keyboardRect.size.height;
    if (kDeviceSystemVersion < 7.) {
        _keyboardY -= 44;

    }
    if ([_tvFeedbackText isFirstResponder]) {
        [UIView animateWithDuration: 0.25 animations:^{
            _bottomBar.maxY = _keyboardY;
            if (kDeviceSystemVersion < 7.) {
                self.tvFeedback.height = _bottomBar.minY;
            } else {
                self.tvFeedback.height = _bottomBar.minY - 64;
            }
            
        }];
        
        [self scrollToBottomAnimated:YES];
    }
}

//关闭键盘
- (void)keyboardWillHide:(NSNotification *)notification
{
    if ([_tvFeedbackText isFirstResponder]) {
        [UIView animateWithDuration: 0.25 animations:^{
            _bottomBar.maxY = self.height;
            if (kDeviceSystemVersion < 7.) {
                _bottomBar.maxY -= 44;
                self.tvFeedback.height = _bottomBar.minY;
            } else {
                self.tvFeedback.height = _bottomBar.minY - 64;
            }
        }];
    }
    _keyboardY = self.height;
}

- (CGRect)keyboardRect:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    return [value CGRectValue];
}

#pragma mark - UMFeedbackDataDelegate
- (void)getFinishedWithError:(NSError *)error
{
    if (!error) {
        [self getData];
        [self.tvFeedback reloadData];
        [self scrollToBottomAnimated:NO];
    }
}

- (void)getData
{
    self.dataArray = _feedback.topicAndReplies;
    
    NSDictionary *dic = nil;
    if (self.dataArray.count != 0)
        dic = [self.dataArray objectAtIndex:0];
    
    if (!dic || [[dic objectForKey:@"datetime"] length] != 0) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        [tempDic setObject:@"dev_reply" forKey:@"type"];
        [tempDic setObject:@"您好，我是产品经理，欢迎您给我们提产品的使用感受和建议！" forKey:@"content"];
        [tempDic setObject:@"" forKey:@"datetime"];
        [self.dataArray insertObject:tempDic atIndex:0];
    }
}

- (void)postFinishedWithError:(NSError *)error
{
    _btnSend.enabled = YES;
    
    if (!error) {
        _tvFeedbackText.text = @"";
        [_feedback get];
        
        UIImage *imgSend = [UIImage imageNamed:@"bg_feedback_btn_send"];
        
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat height = imgSend.size.height + 10;
            _bottomBar.frame = CGRectMake(_bottomBar.minX, _keyboardY-height, _bottomBar.width, height);
            _tvFeedbackText.height = imgSend.size.height;
            _btnSend.minY = 5;
            
            self.tvFeedback.height = _bottomBar.minY;
        }];
        
        [self endEditing:YES];
    }
    else
        NSLog(@"发送失败");
}

- (void)scrollToBottomAnimated:(BOOL)animate {
    if ([self.tvFeedback numberOfRowsInSection:0] > 1) {
        int lastRowNumber = [self.tvFeedback numberOfRowsInSection:0] - 1;
        NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.tvFeedback scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animate];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    
    int surplus = 255 - textView.text.length;
    if (text.length > surplus) {
        textView.text = [textView.text stringByAppendingString:[text substringToIndex: surplus]];
        [self textViewDidChange:textView];
        return  NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView hasText])
        _btnSend.enabled = YES;
    else
        _btnSend.enabled = NO;
    
    if (textView.contentSize.height > 76.0)
        textView.height = 76.0;
    else
        textView.height = textView.contentSize.height;
    
    _bottomBar.height = textView.height + 10;
    _bottomBar.maxY = _keyboardY;
    
    _btnSend.centerY = _bottomBar.height*0.5;
    
    [textView scrollsToTop];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]])
        [self endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 限制字数
    int surplus = 50 - textField.text.length;
    if (string.length > surplus)
        return NO;
    return YES;
}

//计算字符长度
- (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    NSString *content = [dic objectForKey:@"content"];
    NSString *time = [dic objectForKey:@"datetime"];
    if (time.length != 0)
        return [self stringHeight:content] + 13 + 30;
    
    return [self stringHeight:content] + 30;
}


- (CGFloat)stringHeight:(NSString *)string
{
    CGSize labelSize = [string sizeWithFont:Font
                          constrainedToSize:CGSizeMake(StringWidth, MAXFLOAT)
                              lineBreakMode:NSLineBreakByCharWrapping];
    
    return labelSize.height;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Cell";
    
    KDFeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[KDFeedbackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier] ;
    }
    [cell setNeedsDisplay];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *infoDic = [self.dataArray objectAtIndex:indexPath.row];
    NSString *content = [infoDic objectForKey:@"content"];
    NSString *type = [infoDic objectForKey:@"type"];
    NSString *time = [infoDic objectForKey:@"datetime"];
    if (time.length != 0){
        cell.labTime.text = time;
        cell.labTime.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    }
    else
        cell.labTime.text = @"";
    
    cell.textLabel.text = content;
    cell.textLabel.font = Font;
    
    if ([type isEqualToString:@"dev_reply"])
        cell.isLeft = YES;
    else
        cell.isLeft = NO;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end
