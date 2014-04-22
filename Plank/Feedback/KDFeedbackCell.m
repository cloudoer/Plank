//
//  KDFeedbackCell.m
//  pocketplayer
//
//  Created by zhoulong on 14-1-1.
//  Copyright (c) 2014年 koudaiv. All rights reserved.
//

#import "KDFeedbackCell.h"
#import "UIView+Util.h"

#define kColorGrey1     [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]
#define StringWidth 200

@implementation KDFeedbackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *timeLb = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLb.backgroundColor = [UIColor clearColor];
        timeLb.textAlignment = TextAlignmentCenter;
        timeLb.font = [UIFont systemFontOfSize:10];
        timeLb.textColor = kColorGrey1;
        self.labTime = timeLb;
        [self.contentView addSubview:timeLb];
        
        self.ivBg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_ivBg];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.labTime sizeToFit];
    self.labTime.width = self.width;
    
    CGSize labelSize = [self.textLabel.text sizeWithFont:self.textLabel.font
                                       constrainedToSize:CGSizeMake(StringWidth, MAXFLOAT)
                                           lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat width = labelSize.width < StringWidth ? labelSize.width : StringWidth;
    
    if (self.isLeft) {
        UIImage *img = [[UIImage imageNamed:@"bg_feedback_pop1"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
        
        self.ivBg.image = img;
        self.ivBg.frame = CGRectMake(0, self.labTime.maxY, width + 25, labelSize.height + 20);
        
        self.textLabel.frame = CGRectMake(self.ivBg.minX + 17, self.ivBg.minY + 10, width, labelSize.height);
    }
    else {
        UIImage *img = [[UIImage imageNamed:@"bg_feedback_pop2"] stretchableImageWithLeftCapWidth:15 topCapHeight:10];
        
        self.ivBg.image = img;
        self.ivBg.frame = CGRectMake(0, self.labTime.maxY, width + 25, labelSize.height + 20);
        self.ivBg.maxX = self.width;
        
        self.textLabel.frame = CGRectMake(self.ivBg.minX + 8, self.ivBg.minY + 10, width, labelSize.height);
    }
    
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.numberOfLines = 0;
}

@end
