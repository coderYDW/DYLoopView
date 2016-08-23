//
//  DYLoopViewCell.m
//  NeteaseNews1.0
//
//  Created by Yangdongwu on 16/6/14.
//  Copyright © 2016年 Yangdongwu. All rights reserved.
//

#import "DYLoopViewCell.h"
#import "UIImageView+WebCache.h"

@interface DYLoopViewCell ()

@property (nonatomic,strong) UIImageView *iconView;

@end

@implementation DYLoopViewCell

//这里要重写initWithFrame方法，重写init方法无效
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建cell的子控件，UICollectionCell没有自带的子控件，一定要自己创建
        self.iconView = [[UIImageView alloc] init];
        //添加到contentView
        [self.contentView addSubview:self.iconView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconView.frame = self.bounds;

}

- (void)setURL:(NSURL *)URL {

    _URL = URL;
    //通过URL获得图片，从网络下载图片，就给一个URL接口就好了
    [self.iconView sd_setImageWithURL:URL];

}



@end
