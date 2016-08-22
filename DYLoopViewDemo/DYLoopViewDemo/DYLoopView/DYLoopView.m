//
//  DYLoopView.m
//  NeteaseNews1.0
//
//  Created by Yangdongwu on 16/6/14.
//  Copyright © 2016年 Yangdongwu. All rights reserved.
//

#import "DYLoopView.h"
#import "DYLoopViewLayout.h"
#import "DYLoopViewCell.h"
#import "DYWeakTimerTargetObj.h"


@interface DYLoopView () <UICollectionViewDataSource,UICollectionViewDelegate>

/**
 *  图片轮播collectionView
 */
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 *  URL数组
 */
@property (nonatomic, strong) NSArray *URLs;
/**
 *  标题数组
 */
@property (nonatomic, strong) NSArray *titles;
/**
 *  用于轮播的计时器
 */
@property (nonatomic, weak) NSTimer *timer;
/**
 *  选择事件的回调
 */
@property (nonatomic, copy) void (^didSelected)(NSInteger index);
/**
 *  显示标题的label
 */
@property (nonatomic, strong) UILabel *titleLbl;
/**
 *  分页控制器
 */
@property (nonatomic, strong) UIPageControl *pageCtrl;


@end

@implementation DYLoopView

- (instancetype)initWithURLs:(NSArray <NSString *>*)URLs titles:(NSArray <NSString *>*)titles didSelected:(void(^)(NSInteger index))didSelected{
    if (self = [super init]) {
        
        self.URLs = URLs;
        self.titles = titles;
        //选择赋值
        self.didSelected = didSelected;

        //NSLog(@"titles = %@",titles);
        
        //设置默认的自动轮播2秒，可以在外界设置，当外界设置的时候这里的设置就失效
        self.enableTimer = YES;
        self.TimeInterval = 4.0;
        
        
        
        //开启一个主队列异步，这样，当主队列空闲的时候就执行这段程序
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.URLs.count > 1) {
                
                //将图片轮播器滚动到指定的位置
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.URLs.count inSection:0];
                
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];

                //添加定时器
                [self addTimer];
                
            }
            
        });
        
    }
    return self;
}

- (void)addTimer {
    
    //当图片轮播器没有使能的时候
    if (!self.enableTimer) return;
    //当定时器为空的时候
    if (self.timer != nil) return;
    //当图片的个数小于2的时候
    if (self.URLs.count < 2) return;
    
    //添加图片，使用weak类进行添加，接管强引用
    NSTimer *timer = [DYWeakTimerTargetObj scheduledTimerWithTimeInterval:self.TimeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    self.timer = timer;
    //添加到循环中
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}


- (void)removeTimer {
    
    [self.timer invalidate];
    self.timer = nil;
    
}

- (void)nextPage {
    
    
    CGFloat offsetX = self.collectionView.contentOffset.x;
    CGFloat width = self.collectionView.bounds.size.width;
    
    NSInteger page = offsetX / width;
    
    [self.collectionView setContentOffset:CGPointMake((page + 1) * width, 0) animated:YES];
    
    //这里不用再判断了是否滚动到第0张或者最后一张，
    //当滚动动画结束的时候调用一下滚动结束代理方法，
    //就在那个方法里面判断了，并且执行相应的方法

    
}

#pragma mark - 代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    //开始滚动的时候要移除定时器
    [self removeTimer];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    //动画结束的时候调用滚动结束的方法，这样就会判断是否滚动到最后了
    [self scrollViewDidEndDecelerating:(UIScrollView *)scrollView];
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //得到偏移值和宽度
    CGFloat offsetX = scrollView.contentOffset.x;
    
    CGFloat width = scrollView.bounds.size.width;
    
    //计算出当前页数
    NSInteger page = offsetX / width;
    
    //NSLog(@"page end = %zd", page);
    
    //判断是否是第0页或者最后一页，在拖动结束的时候进行替换，这样就神不知鬼不觉了
    if (page == 0) {
        
        //第0页，偷偷的将偏移值设置为一倍的cell个数值
        page = self.URLs.count;
        self.collectionView.contentOffset = CGPointMake(page * width, 0);
        
    }else if (page == [self.collectionView numberOfItemsInSection:0] - 1) {
        
        //最后一页，偷偷的将偏移值设置为二倍的cell个数值减去一
        page = self.URLs.count - 1;
        self.collectionView.contentOffset = CGPointMake(page * width, 0);
        
    }
    
    [self addTimer];
    
    //滚动结束后设置标题内容和页面控制器的当前页
    self.titleLbl.text = self.titles[page % self.URLs.count];
    self.pageCtrl.currentPage = page % self.URLs.count;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.didSelected) {
        self.didSelected(indexPath.item % self.URLs.count);
    }
    
    //[self.collectionView removeFromSuperview];

}



#pragma mark - 创建view 方法

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
    
}

- (void)setup {
    
    //创建collectionView
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[DYLoopViewLayout alloc] init]];
    
    self.collectionView = collectionView;
    
    [self addSubview:collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    //注册cell
    [collectionView registerClass:[DYLoopViewCell class] forCellWithReuseIdentifier:@"loopView"];
    
    
    //创建label
    
    self.titleLbl = [[UILabel alloc] init];
    self.titleLbl.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLbl];
    
    //创建分页控制器
    
    self.pageCtrl = [[UIPageControl alloc] init];
    
    self.pageCtrl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageCtrl.currentPageIndicatorTintColor = [UIColor redColor];
    
    [self addSubview:self.pageCtrl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //布局图片轮播器
    self.collectionView.frame = self.bounds;
    
    CGFloat marginX = 10;
    
    CGFloat pageW = [self.pageCtrl sizeForNumberOfPages:self.URLs.count].width;
    CGFloat pageH = 50;
    CGFloat pageY = self.bounds.size.height - pageH;
    
    CGFloat titleX = marginX;
    CGFloat titleW = self.bounds.size.width - pageW - 3*marginX ;
    CGFloat titleH = 50;
    CGFloat titleY = pageY;
    
    CGFloat pageX = marginX * 2 + titleW;
    
    //布局标题
    self.titleLbl.frame = CGRectMake(titleX, titleY, titleW, titleH);
    //布局pageController
    self.pageCtrl.frame = CGRectMake(pageX, pageY, pageW, pageH);
    
}

#pragma mark - 数据源方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.URLs.count > 1 ? self.URLs.count * 3:self.URLs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DYLoopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"loopView" forIndexPath:indexPath];
    
    cell.URL = [NSURL URLWithString:self.URLs[indexPath.row % self.URLs.count]];
    
    return cell;
    
}

/**
 *  重写URLs的set方法，
 *  只有当加载完数据的时候才会来设置URLs的值
 *  所以可以在这里面来设置好pageCTRL和title的值默认的值
 *  这样就不用外界来参与设置默认值了
 */
- (void)setURLs:(NSArray *)URLs {
    _URLs = URLs;
    //设置分页控制器的个数和默认的页数
    self.pageCtrl.numberOfPages = URLs.count;
    self.pageCtrl.currentPage = 0;
    //设置标题的默认内容
    self.titleLbl.text = self.titles[0];
    [self setNeedsLayout];

}


- (void)dealloc {
    
    NSLog(@"%s", __FUNCTION__);
    
}

@end
