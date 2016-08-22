//
//  DYLoopViewLayout.m
//  NeteaseNews1.0
//
//  Created by Yangdongwu on 16/6/14.
//  Copyright © 2016年 Yangdongwu. All rights reserved.
//

#import "DYLoopViewLayout.h"

@implementation DYLoopViewLayout

/**
 *  准备布局参数
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    //判断当collectionView的大小为零的时候就不在设置布局参数了，直接返回
    if (CGSizeEqualToSize(self.collectionView.bounds.size, CGSizeZero)) {
        return;
    }
    
    self.itemSize = self.collectionView.bounds.size;
    NSLog(@"222--%@",NSStringFromCGRect(self.collectionView.bounds));
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;


}

@end
