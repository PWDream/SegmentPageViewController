//
//  SegmentView.h
//  PWPageViewController
//
//  Created by 潘威 on 15/8/24.
//  Copyright (c) 2015年 潘威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentView : UIView
/** 分段的数组个数 */
@property (nonatomic, strong) NSArray *segments;
/** 索引的颜色,默认是白色 */
@property (nonatomic, strong) UIColor *segmentIndexColor;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) void (^segmentClick) (NSInteger index);

@end
