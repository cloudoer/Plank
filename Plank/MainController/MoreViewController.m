//
//  MoreViewController.m
//  Plank
//
//  Created by zhoulong on 14-4-18.
//  Copyright (c) 2014年 zhoulong. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:.3 animations:^{
        self.view.frame = CGRectMake(DEVICE_WIDTH - MORE_VIEW_WIDTH, 64, MORE_VIEW_WIDTH, 0);
    }];
}

@end
