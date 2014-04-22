//
//  FDCaptionGraphView.m
//  SampleProj
//
//  Created by frank on 20/03/13.
//  Copyright (c) 2013 Francesco Di Lorenzo. All rights reserved.
//

#import "FDGraphScrollView.h"

@implementation FDGraphScrollView

- (id)initWithFrame:(CGRect)frame {
    if ( (self = [super initWithFrame:frame]) ) {
        
        CGRect graphViewFrame = frame;
        graphViewFrame.origin.x = 0;
        graphViewFrame.origin.y = 0;
        
        _graphView = [[FDGraphView alloc] initWithFrame:graphViewFrame];
        _graphView.autoresizeToFitData = YES;
        _graphView.linesColor = [UIColor greenColor];
        _graphView.dataPointStrokeColor = [UIColor blueColor];
        _graphView.dataPointsXoffset = 45.;
        self.backgroundColor = self.graphView.backgroundColor;
        
        [self addSubview:_graphView];
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (CGSize)contentSizeWithWidth:(CGFloat)width {
    return CGSizeMake(width, self.frame.size.height);
}

- (void)setDataPoints:(NSArray *)dataPoints {
    self.graphView.dataPoints = dataPoints;
    self.contentSize = [self contentSizeWithWidth:self.graphView.frame.size.width];
}

- (void)setDates:(NSArray *)dates {
    self.graphView.dates = dates;
}
@end
