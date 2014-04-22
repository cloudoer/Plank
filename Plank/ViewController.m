//
//  ViewController.m
//  Plank
//
//  Created by zhoulong on 14-4-14.
//  Copyright (c) 2014年 zhoulong. All rights reserved.
//

#import "ViewController.h"
#import "TimingViewController.h"
#import "ChallengeViewController.h"
#import "ChartViewController.h"
#import "KDFeedbackViewController.h"
#import "HelpViewController.h"
#import "MoreViewController.h"

#define ITEM_TAG        20140415


@interface ViewController ()<UIScrollViewDelegate>
{
    int currentNO;
    MoreViewController *more;
}
@property (weak, nonatomic) IBOutlet UILabel *itemLine;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UIView *itemView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self init4ContentViews];
    
    self.contentView.contentSize = CGSizeMake(DEVICE_WIDTH * 3, WIDTH(_contentView));
    
    self.lineLabel.backgroundColor = RGBCOLOR(188., 215., 172.);
    self.itemLabel.backgroundColor = RGBCOLOR(120., 193., 55.);
    
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideItem)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)init4ContentViews {
    [self init4Timing];
    
    [self init4Challenge];
    
    [self init4Chart];
    
    [self init4Item];

}

- (void)init4Timing {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    TimingViewController *timingVC = [storyboard instantiateViewControllerWithIdentifier:@"timing"];
    [self moveToView:timingVC];
}

- (void)init4Challenge {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    ChallengeViewController *challengeVC = [storyboard instantiateViewControllerWithIdentifier:@"challenge"];
    [self moveToView:challengeVC];
    challengeVC.view.frame = CGRectMake(DEVICE_WIDTH, 0, WIDTH(challengeVC.view), HEIGHT(challengeVC.view));
}

- (void)init4Chart {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    ChartViewController *chart = [storyboard instantiateViewControllerWithIdentifier:@"chart"];
    [self moveToView:chart];
    chart.view.frame = CGRectMake(2 * DEVICE_WIDTH, 0, WIDTH(chart.view), HEIGHT(chart.view));
}

- (void)init4Item {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    more = [storyboard instantiateViewControllerWithIdentifier:@"more"];
    [self addChildViewController:more];
    [self.view addSubview:more.view];
    [more didMoveToParentViewController:self];
     more.view.frame = CGRectMake(DEVICE_WIDTH - MORE_VIEW_WIDTH, 64, MORE_VIEW_WIDTH, 0);
    
}

- (void)moveToView:(UIViewController *)viewController {
    [self addChildViewController:viewController];
    [self.contentView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.itemLine.frame = CGRectMake((100 + 10) * currentNO, Y(_itemLine), WIDTH(_itemLine), HEIGHT(_itemLine));
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (DEVICE_SYSTEM_VERSION < 7.) {
        self.itemView.frame    = CGRectMake(0, 0, DEVICE_WIDTH, 62);
        CGRect frame           = self.contentView.frame;
        frame.origin.y         = HEIGHT(_itemView);
        self.contentView.frame = frame;
    }
}

- (IBAction)switchItem:(UIButton *)sender {
    [self hideItem];
    [self.contentView setContentOffset:CGPointMake(DEVICE_WIDTH * (sender.tag - ITEM_TAG), 0) animated:YES];
}

#pragma mark - 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideItem];
    CGPoint offset = scrollView.contentOffset;
    currentNO      = (offset.x + (DEVICE_WIDTH / 2)) / DEVICE_WIDTH;
    [UIView animateWithDuration:.3 animations:^{
        self.itemLine.frame = CGRectMake( (100 + 10) * currentNO, Y(_itemLine), WIDTH(_itemLine), HEIGHT(_itemLine));
    }];
    
}

- (IBAction)setting:(UIBarButtonItem *)sender {
    
    if (HEIGHT(more.view)) {
        [UIView animateKeyframesWithDuration:.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            more.view.frame = CGRectMake(DEVICE_WIDTH - MORE_VIEW_WIDTH, 64, MORE_VIEW_WIDTH, 0);
        } completion:nil];
        return;
    }
    
    [UIView animateKeyframesWithDuration:.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        more.view.frame = CGRectMake(DEVICE_WIDTH - MORE_VIEW_WIDTH, 64, MORE_VIEW_WIDTH, 88);
    } completion:nil];
   
}

- (void)hideItem {
    if (HEIGHT(more.view)) {
        [UIView animateKeyframesWithDuration:.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            more.view.frame = CGRectMake(DEVICE_WIDTH - MORE_VIEW_WIDTH, 64, MORE_VIEW_WIDTH, 0);
        } completion:nil];
    }
}

@end
