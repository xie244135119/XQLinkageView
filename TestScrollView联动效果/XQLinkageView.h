//
//  XQLinkageView.h
//  TestScrollView联动效果
//
//  Created by 谢强 on 14-12-2.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#define XQLinkageTimer      3       //设置定时器切换时间

#import <UIKit/UIKit.h>

@interface XQLinkageView : UIView


@property(nonatomic,strong,readonly) NSArray *imageNameOrURLs;          //图片名称或请求地址
@property(nonatomic,weak) UIPageControl *currentPageControl;            //当前pagecontrol

- (id)initWithFrame:(CGRect)frame imageNames:(NSArray *)imagenames;

//使定时器无效
- (void)invalidate;

@end
