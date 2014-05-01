//
//  ResultViewController.m
//  Plank
//
//  Created by zhoulong on 14-4-15.
//  Copyright (c) 2014年 zhoulong. All rights reserved.
//

#import "ResultViewController.h"
#import "UMSocial.h"
#import "NSUtil.h"
#define UMENG_KEY @"534e44d256240bef0801bc59"


@interface ResultViewController ()<UMSocialUIDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *challengeTip;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UILabel *message;


@end

@implementation ResultViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    switch (_challenge) {
        case ChallengeTypeSuccess:
            self.challengeTip.image = PNGIMAGENAMED(@"success");
            break;
        case ChallengeTypeFiled:
            self.challengeTip.image = PNGIMAGENAMED(@"fail");
            break;
        default:
            break;
    }

    switch (_calType) {
        case CalculateTypeCal:
            self.challengeTip.hidden = YES;
            break;
        case CalculateTypeCha:
            self.challengeTip.hidden = NO;
            break;
        default:
            break;
    }

    self.totalTime.text = [NSUtil formatterSecond:_total showFrac:YES];
    if (_total / 1000 < 30)
        self.message.text   = [NSString stringWithFormat:@"坚持了%llus,再接再厉!!!", _total / 1000];
     else
        self.message.text   = [NSString stringWithFormat:@"哇喔,%llus神一般的存在!!!", _total / 1000];
}

- (IBAction)showOff:(UIButton *)sender {
    if (![NSUtil isNetCheck]) {
        [NSUtil alertNotice:@"无网提示" withMSG:@"当前没有网络,无法炫耀哦\n~~~~(>_<)~~~~ " cancleButtonTitle:@"确定" otherButtonTitle:nil];
        return;
    }
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_KEY
                                      shareText:@"我在Plank完成挑战,你也来试试http://www.pocdoc.cn/"
                                     shareImage:self.screenShot
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                       delegate:self];
    
}

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
    [self passing:nil];
}


- (IBAction)passing:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
