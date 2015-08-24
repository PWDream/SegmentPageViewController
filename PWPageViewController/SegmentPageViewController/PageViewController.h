//
//  PageViewController.h
//  PWPageViewController
//
//  Created by 潘威 on 15/8/24.
//  Copyright (c) 2015年 潘威. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageViewController;

@protocol PageViewControllerDelegate <NSObject>

@optional

- (void)pageViewController:(PageViewController *)pageViewController selectedIndex:(NSInteger)selectedIndex;

@end


@interface PageViewController : UIViewController

@property (nonatomic, strong) NSArray *viewcontrollers;

/** 委托 */
@property (nonatomic, weak) id<PageViewControllerDelegate> delegate;

@property (nonatomic, assign, readonly) NSInteger currentSelectedIndex;

@end
