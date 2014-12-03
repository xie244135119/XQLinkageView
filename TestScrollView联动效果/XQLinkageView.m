//
//  XQLinkageView.m
//  TestScrollView联动效果
//
//  Created by SunSet on 14-12-2.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import "XQLinkageView.h"

typedef NS_ENUM(NSUInteger, XQScrollLocationType) {
    XQScrollLocationTypeLeft,           //左侧
    XQScrollLocationTypeMiddle,         //中间
    XQScrollLocationTypeRight           //右侧
};

@interface XQLinkageImageView : UIImageView

@property(nonatomic,copy) NSString *imageNameOrURL;      //图片名称或url地址
@property(nonatomic) NSInteger imageIndex;          //图片索引值

@end

@interface XQLinkageView()  <UIScrollViewDelegate>
{
    __weak UIImageView *_topImageView;      //顶部视图
    __weak UIScrollView *_currentScrollView;    //当前scrollView
//    XQScrollLocationType _currentLocationType;
    
    __weak XQLinkageImageView *_leftImageView;              //左侧视图
    __weak XQLinkageImageView *_middleImageView;            //中间视图
    __weak XQLinkageImageView *_rightImageView;             //右侧视图
    NSTimer *_currentTimer;                                 //当前定时器
}

@end

@implementation XQLinkageView

- (void)dealloc
{
    _imageNameOrURLs = nil;
    _currentTimer = nil;
}

- (id)initWithFrame:(CGRect)frame imageNames:(NSArray *)imagenames
{
    if (self = [super initWithFrame:frame]) {
        _imageNameOrURLs = imagenames;
        [self initView];
        
        _currentTimer = [NSTimer scheduledTimerWithTimeInterval:XQLinkageTimer target:self selector:@selector(change:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)invalidate
{
    [_currentTimer invalidate];
}

#pragma mark - 视图加载
//
- (void)initView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    _currentScrollView = scrollView;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    scrollView.contentSize = CGSizeMake(width*3, height);
    [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    //加载默认视图
    for (int i = 0; i<3; i++) {
        //
        XQLinkageImageView *imgview = [[XQLinkageImageView alloc]initWithFrame:CGRectMake(width*i, 0, width, height)];
        [scrollView addSubview:imgview];
        //
        switch (i) {
            case 0:{
                _leftImageView = imgview;
                imgview.imageNameOrURL = _imageNameOrURLs[_imageNameOrURLs.count-1];
                imgview.imageIndex = _imageNameOrURLs.count-1;
            }
                break;
            case 1:{
                _middleImageView = imgview;
                imgview.imageNameOrURL = _imageNameOrURLs[0];
                imgview.imageIndex = 0;
            }
                break;
            case 2:{
                _rightImageView = imgview;
                imgview.imageNameOrURL = _imageNameOrURLs[1];
                imgview.imageIndex = 1;
            }
                break;
            default:
                break;
        }
    }
    
//    [self initTopShowView];
    [self initPageControlView];
}

//增加一个显示的视图---目前么用
- (void)initTopShowView
{
    //底部视图
    UIImageView *topimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height)];
    [self addSubview:topimgView];
    topimgView.hidden = YES;
    _topImageView = topimgView;
}

//pagecontrol效果
- (void)initPageControlView
{
    UIPageControl *control = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
    control.numberOfPages = _imageNameOrURLs.count;
    control.currentPageIndicatorTintColor = [UIColor redColor];
    control.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self addSubview:control];
    _currentPageControl = control;
}

#pragma mark - 定时器处理
- (void)change:(NSTimer *)timer
{
    NSInteger offset = _currentScrollView.contentOffset.x+self.frame.size.width;
    [_currentScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}


#pragma mark - 数据处理
//加载一张页面显示视图--用于处理--加载后端处理操作
- (void)dealInBackgroundWithType:(XQScrollLocationType)type
{
    _topImageView.hidden = NO;
    
    //后台处理图片的换位问题
    switch (type) {
        case XQScrollLocationTypeLeft:{
            _topImageView.image = _leftImageView.image;
            
            //设置右侧视图
            _rightImageView.imageIndex = _middleImageView.imageIndex;
            _rightImageView.imageNameOrURL = _middleImageView.imageNameOrURL;
            //设置中间视图
            _middleImageView.imageIndex = _leftImageView.imageIndex;
            _middleImageView.imageNameOrURL = _leftImageView.imageNameOrURL;
            
            //设置左侧视图的效果
            NSInteger leftindex = _leftImageView.imageIndex;
            if (leftindex == 0) {   //首页
                leftindex = _imageNameOrURLs.count-1;
            }
            else{
                leftindex--;
            }
            _leftImageView.imageIndex = leftindex;
            _leftImageView.imageNameOrURL = _imageNameOrURLs[leftindex];
            
        }
            break;
        case XQScrollLocationTypeMiddle:{//中间
//            _topImageView.image = _middleImageView.image;
        }
            break;
        case XQScrollLocationTypeRight:{
            _topImageView.image = _rightImageView.image;
            
            //设置左侧视图
            _leftImageView.imageIndex = _middleImageView.imageIndex;
            _leftImageView.imageNameOrURL = _middleImageView.imageNameOrURL;
            
            //设置中间视图
            _middleImageView.imageIndex = _rightImageView.imageIndex;
            _middleImageView.imageNameOrURL = _rightImageView.imageNameOrURL;
            
            //设置左侧视图的效果
            NSInteger rightIndex = _rightImageView.imageIndex;
            if (rightIndex == _imageNameOrURLs.count-1) {   //
                rightIndex = 0;
            }
            else{
                rightIndex++;
            }
            _rightImageView.imageIndex = rightIndex;
            _rightImageView.imageNameOrURL = _imageNameOrURLs[rightIndex];
        }
            break;
            
        default:
            break;
    }
    
    [_currentScrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    [_currentPageControl setCurrentPage:_middleImageView.imageIndex];
    _topImageView.hidden = YES;
}


#pragma mark - UIScrollViewDelegate
//结束减速---即当scrollView滑动停止的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self dealOffSetX:scrollView.contentOffset.x];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}


- (void)dealOffSetX:(CGFloat )offsetx
{
    XQScrollLocationType type = 0;
    if(offsetx > 320) {//右滑
        type = XQScrollLocationTypeRight;
    }
    else if(offsetx < 320){//左滑
        type = XQScrollLocationTypeLeft;
    }
    else{//当前状态--不做任何处理
        type = XQScrollLocationTypeMiddle;
    }
    
    [self dealInBackgroundWithType:type];
}


@end




@implementation XQLinkageImageView

- (void)dealloc
{
    self.imageNameOrURL = nil;
}

//设置图像
- (void)setImageNameOrURL:(NSString *)imageNameOrURL
{
    if (_imageNameOrURL != imageNameOrURL) {
        _imageNameOrURL = imageNameOrURL;
        
        //如果包含主机地址--则是网络请求
        if ([imageNameOrURL hasPrefix:@"http"]) {
            
        }
        else{
            self.image = [UIImage imageNamed:imageNameOrURL];
        }
    }
}

//- (void)setImageIndex:(NSInteger)imageIndex
//{
//    if (_imageIndex != imageIndex) {
//        _imageIndex = imageIndex;
//        
//    }
//}

@end




















