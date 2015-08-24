//
//  PageViewController.m
//  PWPageViewController
//
//  Created by 潘威 on 15/8/24.
//  Copyright (c) 2015年 潘威. All rights reserved.
//

#import "PageViewController.h"
#import "SegmentView.h"
#import "PageView.h"

@interface PageViewController()
<UIGestureRecognizerDelegate>
{
    NSMutableArray *_segments;          //分段视图数据
    SegmentView *_segmentView;          //分段视图
    PageView *_pageView;                //分页视图容器
    NSInteger _lastIndex;               //上一个索引
}
@end

@implementation PageViewController

- (instancetype)init
{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initData
{
    _segments = [NSMutableArray arrayWithCapacity:2];
    _lastIndex = NSNotFound;
}

- (void)setViewcontrollers:(NSArray *)viewcontrollers
{
    
    [_segments removeAllObjects];
    
    for (UIViewController *vc in self.viewcontrollers) {
        [vc removeFromParentViewController];
    }
    
    _viewcontrollers = viewcontrollers;
    
    for (UIViewController *vc in viewcontrollers) {
        if (vc.title.length) {
            [_segments addObject:vc.tabBarItem];
        }
        [self addChildViewController:vc];
    }
    [self loadChildView];
}

#pragma mark - 加载视图

/**
 *  加载子势图
 */
- (void)loadChildView
{
    //1.加载分段视图
    [self loadSegmentView];
    //2.加载内容视图
    [self loadContentView];
    
}
/**
 *  加载分段视图
 */
- (void)loadSegmentView
{
    if (_segments.count == 0) {
        return;
    }
    [_segmentView removeFromSuperview];
    
    SegmentView *segmentView = [[SegmentView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 36)];
    segmentView.segments = _segments;
    segmentView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:segmentView];
    _segmentView = segmentView;
    
    segmentView.layer.shadowColor = [[UIColor colorWithRed:0 green:0/255.f blue:0/255.f alpha:0.25] CGColor];
    segmentView.layer.shadowOffset = CGSizeMake(0, 2);
    segmentView.layer.shadowOpacity = 1;
    segmentView.layer.shadowRadius = 2;
    segmentView.layer.shadowPath= [UIBezierPath bezierPathWithRoundedRect:(CGRect){-2,5,segmentView.bounds.size.width+4,segmentView.bounds.size.height-5} cornerRadius:0].CGPath;
    
    segmentView.segmentClick = ^(NSInteger index){
        _pageView.index = index + 1;
    };
}

/**
 *  加载内容视图
 */
- (void)loadContentView
{
    [_pageView removeFromSuperview];
    
    NSMutableArray *contentViewData = [NSMutableArray arrayWithCapacity:self.childViewControllers.count];
    for (UIViewController *vc in self.childViewControllers) {
        vc.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        [contentViewData addObject:vc.view];
    }
    
    CGFloat viewY = 0;
    if (_segmentView != nil) {
        viewY = CGRectGetMaxY(_segmentView.frame);
    }
    CGFloat viewH = self.view.bounds.size.height - viewY;
    PageView *pageView = [[PageView alloc] initWithFrame:CGRectMake(0, viewY, self.view.bounds.size.width, viewH) Pages:contentViewData];
    if (_segmentView) {
        [self.view insertSubview:pageView belowSubview:_segmentView];
    }else{
        [self.view addSubview:pageView];
    }
    _pageView = pageView;
    pageView.panGestureRecognizer.delegate = self;
    pageView.indexChange = ^(NSInteger newIndex,NSInteger oldIndex){
        _segmentView.currentIndex = newIndex - 1;
        [self responsePageViewIndexChangedDelegate:newIndex - 1];
    };
}

- (void)responsePageViewIndexChangedDelegate:(NSInteger)index
{
    if (_lastIndex == index) {
        return;
    }
    _lastIndex = index;
    if ([self.delegate respondsToSelector:@selector(pageViewController:selectedIndex:)]) {
        [self.delegate pageViewController:self selectedIndex:index];
    }
}

#pragma mark - 手势委托

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint location = [gestureRecognizer locationInView:self.view];
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    
    if (location.x > 60 || _pageView.index != 1 || [pan velocityInView:self.view].x < 0) {
        return YES;
    }else{
        return NO;
    }
}

- (NSInteger)currentSelectedIndex
{
    return _lastIndex == NSNotFound ? 0 : _lastIndex;
}


@end
