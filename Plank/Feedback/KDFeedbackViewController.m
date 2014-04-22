//
//  KDFeedbackViewController.m
//  pocketplayer
//
//  Created by zhoulong on 14-1-1.
//  Copyright (c) 2014年 koudaiv. All rights reserved.
//

#import "KDFeedbackViewController.h"
#import "KDFeedBackView.h"

@interface KDFeedbackViewController ()

@property (nonatomic, retain) KDFeedBackView *feedBackView;

@end

@implementation KDFeedbackViewController

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
    self.feedBackView = [[KDFeedBackView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_feedBackView];
}


- (IBAction)closeCurrentViewController:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
