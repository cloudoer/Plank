//
//  FDGraphView.m
//  disegno
//
//  Created by Francesco Di Lorenzo on 14/03/13.
//  Copyright (c) 2013 Francesco Di Lorenzo. All rights reserved.
//

#import "FDGraphView.h"
#import "CMPopTipView.h"

@interface FDGraphView()

@property (nonatomic, strong) NSNumber *maxDataPoint;
@property (nonatomic, strong) NSNumber *minDataPoint;
@property (nonatomic, strong) UIButton *last;
@property (nonatomic, strong) CMPopTipView *tip;
//@property (nonatomic, strong) NSMutableArray *points;

@end

@implementation FDGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // default values
        _edgeInsets = UIEdgeInsetsMake(10, 30, 30, 10);
        _dataPointColor = [UIColor whiteColor];
        _dataPointStrokeColor = [UIColor blackColor];
        _linesColor = [UIColor grayColor];
        _autoresizeToFitData = NO;
        _dataPointsXoffset = 100.0f;
        self.backgroundColor = [UIColor whiteColor];
        self.tip = [[CMPopTipView alloc] initWithMessage:@"00:00"];
        self.tip.hasShadow = NO;
        self.tip.backgroundColor = [UIColor whiteColor];
        self.tip.textColor = [UIColor redColor];
        self.tip.borderColor = [UIColor grayColor];
    }
    return self;
}

- (NSNumber *)maxDataPoint {
    if (_maxDataPoint) {
        return _maxDataPoint;
    } else {
        __block CGFloat max = ((NSNumber *)self.dataPoints[0]).floatValue;
        [self.dataPoints enumerateObjectsUsingBlock:^(NSNumber *n, NSUInteger idx, BOOL *stop) {
            if (n.floatValue > max)
                max = n.floatValue;
        }];
        return @(max);
    }
}

- (NSNumber *)minDataPoint {
    if (_minDataPoint) {
        return _minDataPoint;
    } else {
        __block CGFloat min = ((NSNumber *)self.dataPoints[0]).floatValue;
        [self.dataPoints enumerateObjectsUsingBlock:^(NSNumber *n, NSUInteger idx, BOOL *stop) {
            if (n.floatValue < min)
                min = n.floatValue;
        }];
        return @(min);
    }
}

- (CGFloat)widhtToFitData {
    CGFloat res = 0;
    
    if (self.dataPoints) {
        res += (self.dataPoints.count - 1)*self.dataPointsXoffset; // space occupied by data points
        res += (self.edgeInsets.left + self.edgeInsets.right) ; // lateral margins;
    }
    
    return res;
}

- (void)drawXLabel:(CGPoint[])graphPoints count:(int)count {
    UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width + 20, 1)];
    xLabel.backgroundColor = [UIColor grayColor];
    [self addSubview:xLabel];
    
    for (int i = 0; i < count; i++) {
        UILabel *x = [[UILabel alloc] initWithFrame:CGRectMake(graphPoints[i].x - 15, Y(xLabel), 30, 20)];
        x.text = [self.dates[count - i - 1] substringFromIndex:5];
        x.textAlignment = TextAlignmentLeft;
        x.font = SYSTEMFONT(10.);
        [self addSubview:x];
    }
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    // STYLE
    // lines color
    [self.linesColor setStroke];
    // lines width
    CGContextSetLineWidth(context, 1.);
    
    // CALCOLO I PUNTI DEL GRAFICO
    NSInteger count = self.dataPoints.count;
    CGPoint graphPoints[count];
    
    CGFloat drawingWidth, drawingHeight, min, max;
    
    drawingWidth = rect.size.width - self.edgeInsets.left - self.edgeInsets.right;
    drawingHeight = rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
    min = ((NSNumber *)[self minDataPoint]).floatValue;
    max = ((NSNumber *)[self maxDataPoint]).floatValue;
    
    if (count > 1) {
        for (int i = 0; i < count; ++i) {
            CGFloat x, y, dataPointValue;
            
            dataPointValue = ((NSNumber *)self.dataPoints[count - i - 1]).floatValue;
            
            x = self.edgeInsets.left + (drawingWidth/(count-1))*i;
            if (max != min)
                y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (dataPointValue - min) / (max - min) ) );
            else 
                y = rect.size.height - self.edgeInsets.bottom;
            
            graphPoints[i] = CGPointMake(x, y);
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.frame = CGRectMake(x - 20, y - 20, 40, 40);
            btn.backgroundColor = [UIColor clearColor];
            [btn setImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"red"] forState:UIControlStateSelected];
            [self addSubview:btn];
            [btn addTarget:self action:@selector(showTip:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else if (count == 1) {
        // pongo il punto al centro del grafico
        graphPoints[0].x = drawingWidth/2;
        graphPoints[0].y = drawingHeight/2;
    } else {
        return;
    }
    
    [self drawXLabel:graphPoints count:count];
    
    // DISEGNO IL GRAFICO
    CGContextAddLines(context, graphPoints, count);
    CGContextStrokePath(context);
    
    // DISEGNO I CERCHI NEL GRANO
    for (int i = 0; i < count; ++i) {
        CGRect ellipseRect = CGRectMake(graphPoints[i].x-3, graphPoints[i].y-3, 6, 6);
        CGContextAddEllipseInRect(context, ellipseRect);
        CGContextSetLineWidth(context, 2);
        [[UIColor whiteColor] setStroke];
        [[UIColor whiteColor] setFill];
        CGContextFillEllipseInRect(context, ellipseRect);
        CGContextStrokeEllipseInRect(context, ellipseRect);
    }
}

#pragma mark - Custom setters

- (void)changeFrameWidthTo:(CGFloat)width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setDataPointsXoffset:(CGFloat)dataPointsXoffset {
    _dataPointsXoffset = dataPointsXoffset;
    
    if (self.autoresizeToFitData) {
        CGFloat widthToFitData = [self widhtToFitData];
        if (widthToFitData > self.frame.size.width) {
            [self changeFrameWidthTo:widthToFitData];
        }
    }
}

- (void)setAutoresizeToFitData:(BOOL)autoresizeToFitData {
    _autoresizeToFitData = autoresizeToFitData;
    
    CGFloat widthToFitData = [self widhtToFitData];
    if (widthToFitData > self.frame.size.width) {
        [self changeFrameWidthTo:widthToFitData];
    }
}

- (void)setDataPoints:(NSArray *)dataPoints {
    _dataPoints = dataPoints;
    
    if (self.autoresizeToFitData) {
        CGFloat widthToFitData = [self widhtToFitData];
        if (widthToFitData > self.frame.size.width) {
            [self changeFrameWidthTo:widthToFitData];
        }
    }
}

- (void)showTip:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.last) {
        self.last.selected = !self.last.selected;
    }
    self.last = sender;

    self.tip.message = [NSUtil formatterSecond:[self.dataPoints[self.dataPoints.count - sender.tag - 1] longLongValue] showFrac:NO];
    [self.tip presentPointingAtView:sender inView:self animated:YES];
    
}

@end
