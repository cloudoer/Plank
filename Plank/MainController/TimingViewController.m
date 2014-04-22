//
//  TimingViewController.m
//  Plank
//
//  Created by zhoulong on 14-4-14.
//  Copyright (c) 2014年 zhoulong. All rights reserved.
//

#import "TimingViewController.h"
#import "ResultViewController.h"
#import "RMDownloadIndicator.h"
#import "TTCounterLabel.h"
#import "NetFileUtil.h"

#define PER_SECOND (60 * 1000)

typedef NS_ENUM(NSInteger, kTTCounter){
    kTTCounterRunning = 0,
    kTTCounterStopped,
    kTTCounterReset,
    kTTCounterEnded
};

@interface TimingViewController ()

@property (weak, nonatomic) IBOutlet RMDownloadIndicator *timerCircle;
@property (weak, nonatomic) IBOutlet TTCounterLabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;


@end

@implementation TimingViewController

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

    RMDownloadIndicator *closedIndicator = [[RMDownloadIndicator alloc]initWithFrame:self.timerCircle.frame type:kRMClosedIndicator];
    closedIndicator.backgroundColor = [UIColor clearColor];
    closedIndicator.fillColor = RGBCOLOR(135., 199., 86.);
    closedIndicator.strokeColor = [UIColor greenColor];
    [self.view addSubview:closedIndicator];
    _timerCircle = closedIndicator;
    [self.timerCircle loadIndicator];
    
   
    self.stopBtn.hidden  = YES;
    self.startBtn.hidden = NO;

    [self.timeLabel updateProgress:^(unsigned long long currentValue) {
        [self.timerCircle updateWithTotalBytes:PER_SECOND downloadedBytes:currentValue % PER_SECOND];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)timerStart:(UIButton *)sender {
    [self.timeLabel start];
    self.startBtn.hidden = YES;
    self.stopBtn.hidden  = NO;
    
    
}

- (IBAction)timerEnd:(UIButton *)sender {
    unsigned long long total     = self.timeLabel.currentValue;
    UIStoryboard *storyboard     = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    ResultViewController *result = [storyboard instantiateViewControllerWithIdentifier:@"result"];
    UIImage *image               = [NSUtil screenShot:self.view size:CGSizeMake(DEVICE_WIDTH, 300)];
    result.screenShot            = image;
    result.calType               = CalculateTypeCal;
    result.total                 = total;
    NSString *key                = [NSUtil formatterDate:[NSDate date] formatter:@"yyyy.MM.dd"];
    
    NSLog(@"====%@", NSUSERDEFAULTS(key));
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

    [self.navigationController pushViewController:result animated:YES];
    
    self.startBtn.hidden = NO;
    self.stopBtn.hidden  = YES;
    
    [self.timeLabel stop];
    [self.timeLabel reset];
    
}



@end
