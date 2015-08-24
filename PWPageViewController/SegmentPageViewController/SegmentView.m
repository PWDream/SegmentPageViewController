//
//  SegmentView.m
//  PWPageViewController
//
//  Created by 潘威 on 15/8/24.
//  Copyright (c) 2015年 潘威. All rights reserved.
//

#import "SegmentView.h"

NSInteger const SegmentViewDefaultW = 75;

@interface SegmentView()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *lastButton;

@end

@implementation SegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setSegments:(NSArray *)segments
{
    _segments = segments;
    
    for (UIButton *button in self.scrollView.subviews) {
        [button removeFromSuperview];
    }
    
    for (NSInteger index = 0; index < segments.count; index ++) {
        UITabBarItem *item = segments[index];
        [self createButton:item.title index:index];
    }
    _lastButton = [self.scrollView.subviews firstObject];
    [_lastButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
}

- (void)createButton:(NSString *)title index:(NSInteger)index
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = index;
    [self.scrollView addSubview:button];
}

- (void)setSegmentIndexColor:(UIColor *)segmentIndexColor
{
    _segmentIndexColor = segmentIndexColor;
    self.lineView.backgroundColor = segmentIndexColor;
}

- (void)buttonClicked:(UIButton *)button
{
    [self changeButton:button];
    if (self.segmentClick) {
        self.segmentClick(button.tag);
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    UIButton *button = self.scrollView.subviews[currentIndex];
    [self changeButton:button];    
}

- (void)changeButton:(UIButton *)button
{
    [_lastButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _lastButton = button;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.35 animations:^{
        CGRect rect = self.lineView.frame;
        rect.origin.x = button.frame.origin.x;
        weakSelf.lineView.frame = rect;
    }];
}

#pragma mark - 布局

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    NSInteger count = self.scrollView.subviews.count;
    CGFloat buttonW = self.bounds.size.width / count;
    CGFloat buttonH = self.bounds.size.height - 1;
    if (buttonW < SegmentViewDefaultW) {
        self.scrollView.contentSize = CGSizeMake(SegmentViewDefaultW * count, buttonH);
    }
    
    for (NSInteger index = 0; index < count; index ++) {
        UIButton *button = self.scrollView.subviews[index];
        CGFloat x = index % count * buttonW;
        button.frame = CGRectMake(x, 0, buttonW, buttonH);
    }
    self.scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, buttonH);

    self.lineView.frame = CGRectMake(0, buttonH, buttonW, 1);
}


#pragma mark - setter方法

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_lineView];
    }
    return _lineView;
}


@end
