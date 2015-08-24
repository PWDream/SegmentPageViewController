//
//  ViewController.m
//  PWPageViewController
//
//  Created by 潘威 on 15/8/24.
//  Copyright (c) 2015年 潘威. All rights reserved.
//

#import "ViewController.h"
#import "PageViewController.h"
#import "OneViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *viewcontrollers = [NSMutableArray array];
    for (NSInteger index = 0; index < 5; index ++)
    {
        OneViewController *oneVC = [[OneViewController alloc] init];
        oneVC.title = @"oanh";
        [viewcontrollers addObject:oneVC];
    }
    PageViewController *pageViewcontroller = [[PageViewController alloc] init];
    [self addChildViewController:pageViewcontroller];
    pageViewcontroller.viewcontrollers = viewcontrollers;
    pageViewcontroller.view.frame = CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height - 30);
    [self.view addSubview:pageViewcontroller.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
