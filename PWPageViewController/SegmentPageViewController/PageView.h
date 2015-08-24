//
//  PageView.h
//  PWPageViewController
//
//  Created by 潘威 on 15/8/24.
//  Copyright (c) 2015年 潘威. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IndexChange)(NSInteger newIndex,NSInteger oldIndex);

@interface PageView : UIView

@property(nonatomic)NSInteger index;
@property(nonatomic,readonly)NSArray *pages;
@property(nonatomic,copy)IndexChange indexChange;
@property(nonatomic,strong)UIPanGestureRecognizer *panGestureRecognizer;

-(instancetype)initWithFrame:(CGRect)frame Pages:(NSArray *)pages;

@end
