//
//  ChartViewController.m
//  Plank
//
//  Created by zhoulong on 14-4-16.
//  Copyright (c) 2014年 zhoulong. All rights reserved.
//

#import "ChartViewController.h"
#import "FDGraphScrollView.h"
#import "NetFileUtil.h"

#define MARGIN  1.3
#define Y_TAG   20140421
@interface ChartViewController ()
{
    NSInteger _previousOrientation;
}

@property (weak, nonatomic) IBOutlet UILabel *bestTip;
@property (weak, nonatomic) IBOutlet UILabel *bestValue;
@property (weak, nonatomic) IBOutlet UILabel *totalTip;
@property (weak, nonatomic) IBOutlet UILabel *totalValue;
@property (weak, nonatomic) IBOutlet FDGraphScrollView *scollView;

@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) NSMutableArray *datas;
@property (strong, nonatomic) NSMutableDictionary *dicDatas;


@end

@implementation ChartViewController

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
    
    self.datas = [NSMutableArray arrayWithCapacity:30];
    self.dicDatas = [NSMutableDictionary dictionaryWithCapacity:30];
    
    [self theDayCountFromNow:30];
    
    [self refresh];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:REFRESH_CHART object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)refresh {
    [NetFileUtil selectGrades:30 findObjectsBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSArray *keys = [self.dicDatas allKeys];
            for (AVObject *tem in objects) {
                NSString *key = [NSUtil formatterDate:[tem objectForKey:@"date"] formatter:@"yyyy.MM.dd"];
                if ([keys containsObject:key]) {
                    [self.dicDatas setObject:[tem objectForKey:@"score"] forKey:key];
                }
            }
            
            NSArray *items = self.datas;
            NSMutableArray *allValues = [NSMutableArray arrayWithCapacity:items.count];
            for (int i = 0; i < items.count; i++) {
                NSString *key = items[i];
                if ([keys containsObject:key])
                    [allValues addObject:self.dicDatas[key]];
                else
                    [allValues addObject:@(0)];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self adjust:allValues];
            });
        }
    }];
    
    [NetFileUtil selectBestGrade:^(NSArray *objects, NSError *error) {
        if (!error && objects.count) {
            AVObject *obj = objects[0];
            unsigned long long score = [[obj objectForKey:@"score"] unsignedLongLongValue] / 1000;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.bestValue.text = [NSString stringWithFormat:@"%llus", score];
            });
            
        }
    }];

}

- (void)onDeviceOrientationChange {

    if(((UIScrollView *)self.view.superview).contentOffset.x == DEVICE_WIDTH * 2) {
        
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        
        // 屏蔽平放和大头朝下
        if (orientation == 2 || orientation == 5 || orientation == 6)
            return;
        // 屏蔽重复方向的操作
        if (orientation == _previousOrientation)
            return;
        else
            _previousOrientation = orientation;
        
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        
//        UIDeviceOrientationUnknown,
//        UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
//        UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
//        UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
//        UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
//        UIDeviceOrientationFaceUp,              // Device oriented flat, face up
//        UIDeviceOrientationFaceDown
//
        
//        UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
//        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//            if (!UIDeviceOrientationIsPortrait(deviceOrientation))
//                [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
//                                               withObject:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight]];
//
//            else
//                [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
//                                               withObject:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait]];
//        }
        
        [UIView animateWithDuration:duration animations:^{
            if(orientation == 3 || orientation == 4) {
                 [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];

                self.view.transform = CGAffineTransformMakeRotation(M_PI*0.5);
//                self.navigationController.navigationBar.frame = CGRectMake(0, 0, DEVICE_HEIGHT, 64);
                self.navigationController.navigationBar.transform = CGAffineTransformMakeRotation(M_PI*0.5);
                NSLog(@"%@", NSStringFromCGRect(self.navigationController.navigationBar.frame));
            }
            
//
        }];
        
    }
}

- (void)adjust:(NSArray *)values {
    FDGraphScrollView *fd = [[FDGraphScrollView alloc] initWithFrame:self.scollView.frame];
    [self.contentView addSubview:fd];
    self.scollView = fd;
    NSArray *datas = values;
    self.scollView.dataPoints = datas;
    self.scollView.dates     = self.datas;
    
    int max = 0;
    int min = 0;
    for (int i = 0; i < datas.count; i++) {
        int value = [datas[i] intValue];
        max = max > value ? max : value;
        min = min < value ? min : value;
    }
    
    for (int i = 0; i < 5; i++) {
        UILabel *y;
        if ([self.contentView viewWithTag:(i + Y_TAG)]) {
            y = (UILabel *)[self.contentView viewWithTag:(i + Y_TAG)];
        } else {
            y      = [[UILabel alloc] initWithFrame:CGRectMake(X(_yLabel) - 30,
                                                               Y(_yLabel) + HEIGHT(_yLabel) / 5. * (4 - i ),
                                                               30, 10)];
            
            y.textAlignment = TextAlignmentRight;
            y.font          = SYSTEMFONT(10.);
            y.tag           = Y_TAG + i;
            [self.contentView addSubview:y];
        }
        if (i) {
            y.text          = [NSUtil formatterSecond:(i + 1) / 5. * max showFrac:NO];
        } else
            y.text          = [NSUtil formatterSecond:0 showFrac:NO];


    }
    
    [self.scollView setContentOffset:CGPointMake(fd.contentSize.width - WIDTH(_scollView), 0) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)theDayCountFromNow:(int)count {
    NSMutableArray *total      = [NSMutableArray arrayWithCapacity:count];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    for (int i = 0; i < count; i++) {
        NSDate *date = [NSDate date];
        date         = [date dateByAddingTimeInterval:-i * 3600 * 24];
        [total addObject:[formatter stringFromDate:date]];
        [self.datas addObject:[formatter stringFromDate:date]];
        [self.dicDatas setObject:@(0) forKey:[formatter stringFromDate:date]];
    }
    return total;
}

@end
