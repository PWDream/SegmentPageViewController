//
//  PageView.m
//  PWPageViewController
//
//  Created by 潘威 on 15/8/24.
//  Copyright (c) 2015年 潘威. All rights reserved.
//

#import "PageView.h"

#define separatorW 6

@interface PageView ()
{
    BOOL panGestureShouldBegin;
    CGFloat panGestureDragDistance;
}

@property(nonatomic,weak) UIView *contentView;

@end

@implementation PageView

-(instancetype)initWithFrame:(CGRect)frame Pages:(NSArray *)pages
{
    self=[super initWithFrame:frame];
    [self initPages:pages];
    return self;
}

-(void)initPages:(NSArray *)pages{
    _index=1;
    
    UIView *content=[[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:content];
    self.layer.masksToBounds=YES;
    //content.backgroundColor=HEXCOLOR(0xF0F0F0);
    self.contentView=content;
    
    
    if (pages&&pages.count) {
        _pages=pages;
        CGFloat width=self.frame.size.width+separatorW;
        self.contentView.frame=CGRectMake(0, 0, width*pages.count-separatorW, self.frame.size.height);
        
        for (int index=0;index<pages.count-1;index++) {
            UIView *view=(UIView *)[pages objectAtIndex:index];
            [self.contentView addSubview:view];
            view.frame=CGRectMake(index*width, 0, width-separatorW, self.frame.size.height);
            
            UIImageView *separator=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view.frame), 0, separatorW, self.frame.size.height)];
            separator.image=[UIImage imageNamed:@"separator"];
            [self.contentView addSubview:separator];
        }
        UIView *view=(UIView *)[pages lastObject];
        [self.contentView addSubview:view];
        view.frame=CGRectMake((pages.count-1)*width, 0, width-separatorW, self.frame.size.height);
    }
    
    UIImageView *separatorLeft=[[UIImageView alloc]initWithFrame:CGRectMake(-separatorW/2, 0, separatorW/2, self.frame.size.height)];
    separatorLeft.image=[UIImage imageNamed:@"separator_left"];
    [self.contentView addSubview:separatorLeft];
    
    UIImageView *separatorRight=[[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.bounds.size.width, 0, separatorW/2, self.frame.size.height)];
    separatorRight.image=[UIImage imageNamed:@"separator_right"];
    [self.contentView addSubview:separatorRight];
    
    self.panGestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    //self.panGestureRecognizer.delaysTouchesBegan=YES;
    [self.contentView addGestureRecognizer:self.panGestureRecognizer];
    
}

-(void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)sender{
    if (sender.state==UIGestureRecognizerStateBegan) {
        [self touchBegin:sender];
    }else if (sender.state==UIGestureRecognizerStateChanged){
        [self touchMove:sender];
    }else if (sender.state==UIGestureRecognizerStateEnded){
        [self touchEnd:sender];
    }
}


-(void)touchBegin:(UIPanGestureRecognizer *)sender{
    CGPoint location=[sender locationInView:self];
    NSLog(@"%f",location.x);
    if (location.x>43||self.index!=1||[sender velocityInView:self].x<0) {
        panGestureShouldBegin=YES;
    }else{
        panGestureShouldBegin=NO;
    }
    panGestureDragDistance=0;
}
-(void)touchMove:(UIPanGestureRecognizer *)sender{
    if (panGestureShouldBegin) {
        CGFloat delta=[sender translationInView:self].x;
        if (self.contentView.frame.origin.x>=0) {
            delta=delta/3;
        }
        if (self.contentView.frame.origin.x<=self.frame.size.width-self.contentView.frame.size.width) {
            delta=delta/3;
        }
        self.contentView.center=CGPointMake(self.contentView.center.x+delta, self.contentView.center.y);
        panGestureDragDistance+=delta;
        [sender setTranslation:CGPointZero inView:self];
    }
}
-(void)touchEnd:(UIPanGestureRecognizer *)sender{
    CGFloat pageWidth=self.frame.size.width+separatorW;
    CGFloat targetX=self.contentView.frame.origin.x;
    
    CGFloat v=[sender velocityInView:self].x;
    targetX+=v*fabs(v)/3000;
    
    
    
    if (targetX-(1-self.index)*pageWidth>pageWidth/2) {
        self.index--;
    }else if (targetX-(1-self.index)*pageWidth<-pageWidth/2) {
        self.index++;
    }else{
        self.index=self.index;NSLog(@"\n000%f - %f  ?  %f",targetX,(1-self.index)*pageWidth,pageWidth/2);
    }
}

-(void)setIndex:(NSInteger)index{
    
    if (index<1) {
        index=1;
    }
    if (index>self.pages.count) {
        index=self.pages.count;
    }
    
    if (self.indexChange) {
        self.indexChange(index,_index);
    }
    _index=index;
    
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:3.0f options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.contentView.frame=CGRectMake((self.frame.size.width+separatorW)*(1-_index), 0,
                                                           self.contentView.frame.size.width
                                                           ,self.contentView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
}


@end
