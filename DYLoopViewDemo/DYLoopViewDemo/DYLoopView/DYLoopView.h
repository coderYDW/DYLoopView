//
//  DYLoopView.h
//  NeteaseNews1.0
//
//  Created by Yangdongwu on 16/6/14.
//  Copyright © 2016年 Yangdongwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYLoopView : UIView
/**
 *  播放时间,默认为4秒
 */
@property (nonatomic, assign) CGFloat TimeInterval;
/**
 *  是否使能定时器,默认开启
 */
@property (nonatomic, assign) BOOL enableTimer;

/**
 *  初始化轮播器
 *
 *  @param URLs        URL数组
 *  @param titles      标题数组
 *  @param didSelected 选择回调
 *
 *  @return 轮播器
 */
- (instancetype)initWithURLs:(NSArray <NSString *>*)URLs titles:(NSArray <NSString *>*)titles didSelected:(void(^)(NSInteger index))didSelected;

@end
