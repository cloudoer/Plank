//
//  ChallengeViewController.m
//  Plank
//
//  Created by zhoulong on 14-4-15.
//  Copyright (c) 2014年 zhoulong. All rights reserved.
//

#import "ChallengeViewController.h"
#import "RMDownloadIndicator.h"
#import "TTCounterLabel.h"
#import "DirectionPanGestureRecognizer.h"
#import "ResultViewController.h"
#import "NetFileUtil.h"

#define DEFAULT_TIME 30 * 1000

@interface ChallengeViewController ()
{
    CGPoint lastPoint;
    CGFloat total;
}
@property (weak, nonatomic) IBOutlet RMDownloadIndicator *timerCircle;
@property (weak, nonatomic) IBOutlet TTCounterLabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIView *bgTimeCircle;
@property (weak, nonatomic) IBOutlet UIImageView *noticeImage;


@end

@implementation ChallengeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    RMDownloadIndicator *closedIndicator = [[RMDownloadIndicator alloc]initWithFrame:self.bgTimeCircle.frame type:kRMClosedIndicator];
    closedIndicator.backgroundColor = [UIColor clearColor];
    closedIndicator.fillColor       = RGBCOLOR(135., 199., 86.);
    closedIndicator.strokeColor     = RGBCOLOR(135., 199., 86.);
    [self.view addSubview:closedIndicator];
    _timerCircle = closedIndicator;
    [self.timerCircle loadIndicator];
    
    self.stopBtn.hidden  = YES;
    self.startBtn.hidden = NO;
    
    self.timeLabel.countDirection = kCountDirectionDown;
    self.timeLabel.text = @"00:30.00";
    total = DEFAULT_TIME;
    [self.timeLabel updateProgress:^(unsigned long long currentValue) {
        [self.timerCircle updateWithTotalBytes:total downloadedBytes:currentValue];
        if (currentValue <= 39) {
            [self timerEnd:nil];
        }
    }];


    DirectionPanGestureRecognizer *voicePan = [[DirectionPanGestureRecognizer alloc] initWithTarget:self action:@selector(changeTimeLabel:)];
    voicePan.direction = DirectionPangestureRecognizerVertical;
    [self.view addGestureRecognizer:voicePan];
    
    if (NSUSERDEFAULTS(FIRST_LOGIN))
        self.noticeImage.hidden = YES;
    else
        self.noticeImage.hidden = NO;
    
    
    [self.noticeImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenNotice:)]];
}

- (void)hiddenNotice:(UITapGestureRecognizer *)sender {
    self.noticeImage.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:FIRST_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)changeTimeLabel:(DirectionPanGestureRecognizer *)sender {
     CGPoint point =  [sender translationInView:self.view];
    
    if (self.timeLabel.isRunning)
        return;
    
    if (point.y < lastPoint.y)
        total += 1000;
    else
        total -= 1000;
    
   
    if (total < DEFAULT_TIME)
        total = DEFAULT_TIME;
    
    self.timeLabel.text = [NSUtil formatterSecond:total showFrac:NO];
    lastPoint = point;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)timerStart:(UIButton *)sender {
    self.timeLabel.startValue = total;
    
    [self.timeLabel start];
    self.startBtn.hidden = YES;
    self.stopBtn.hidden  = NO;
    
    
}

- (IBAction)timerEnd:(UIButton *)sender {
    
    [NSUtil playSoundName:@"msgcome" type:@"wav"];
    UIStoryboard *storyboard     = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    ResultViewController *result = [storyboard instantiateViewControllerWithIdentifier:@"result"];
    UIImage *image               = [NSUtil screenShot:self.view size:CGSizeMake(DEVICE_WIDTH, 300)];
    result.screenShot            = image;
    result.calType               = CalculateTypeCha;
    result.challenge             = self.timeLabel.isRunning ? ChallengeTypeFiled : ChallengeTypeSuccess;
    result.total                 = self.timeLabel.isRunning ? total - self.timeLabel.currentValue : total;
    [self.navigationController pushViewController:result animated:YES];
    NSString *key                = [NSUtil formatterDate:[NSDate date] formatter:@"yyyy.MM.dd"];
    if (NSUSERDEFAULTS(key)) {
        if ([NSUSERDEFAULTS(key) unsignedLongLongValue] < total) {
            [NetFileUtil editorMaxGrade:total];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedLongLong:total] forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } else {
        [NetFileUtil editorMaxGrade:total];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedLongLong:total] forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

   
    
    self.startBtn.hidden = NO;
    self.stopBtn.hidden  = YES;
    
    [self.timeLabel stop];
    [self.timeLabel reset];
}



@end
