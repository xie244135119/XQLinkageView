//
//  ViewController.m
//  TestScrollView联动效果
//
//  Created by SunSet on 14-12-2.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import "ViewController.h"
#import "XQLinkageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 视图加载
- (void)initView
{
    XQLinkageView *v = [[XQLinkageView alloc]initWithFrame:CGRectMake(0,100 , 320, 100) imageNames:@[@"1.jpg",@"2.jpg",@"3.jpg"]];
    [self.view addSubview:v];
    
    
}



@end
