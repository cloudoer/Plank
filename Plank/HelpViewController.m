//
//  HelpViewController.m
//  Plank
//
//  Created by zhoulong on 14-4-16.
//  Copyright (c) 2014年 zhoulong. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController () <UIWebViewDelegate>
{
    UIActivityIndicatorView *indic;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HelpViewController

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
	// Do any additional setup after loading the view.
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://plank.tijian8.cn/index.html"]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    indic = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indic.frame = CGRectMake((DEVICE_WIDTH - 100) / 2., (DEVICE_HEIGHT - 100) / 2., 100, 100);
    [self.view addSubview:indic];
    [self.view bringSubviewToFront:indic];
    [indic startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeMe:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [indic stopAnimating];
    [indic removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [indic stopAnimating];
    [indic removeFromSuperview];
}
@end
