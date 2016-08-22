//
//  ViewController.m
//  DYLoopViewDemo
//
//  Created by Yangdongwu on 16/8/20.
//  Copyright © 2016年 DovYoung. All rights reserved.
//

#import "ViewController.h"

#import "DYLoopView.h"



@interface ViewController ()




@property (nonatomic, strong) NSArray *imageURLs;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",self.imageURLs);
    
    DYLoopView *loopView = [[DYLoopView alloc] initWithURLs:self.imageURLs titles:nil didSelected:^(NSInteger index) {
        
        UIViewController *seletedVC = [[UIViewController alloc] init];
        
        seletedVC.view.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
        
        seletedVC.navigationItem.title = [NSString stringWithFormat:@"第%zd张",index];
        
        [self.navigationController pushViewController:seletedVC animated:YES];
        
        
    }];
    
    loopView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 250);
    
    [self.view addSubview:loopView];
    
    
    
    
}

- (NSArray *)imageURLs {

    if (_imageURLs == nil) {
        _imageURLs = @[
                       
                       @"http://img22.mtime.cn/get.ashx?uri=http://img31.mtime.cn/mg/2016/08/19/153422.98385854.jpg&width=640&height=340&quality=75&clipType=4",
                       @"http://img22.mtime.cn/get.ashx?uri=http://img31.mtime.cn/mg/2016/08/22/102621.26681607.jpg&width=640&height=340&quality=75&clipType=4",
                       @"http://img22.mtime.cn/get.ashx?uri=http://img31.mtime.cn/mt/2016/08/12/165936.89834669_1280X720X2.jpg&width=120&height=180&quality=75&clipType=4"
                       
                       ];
    }
    return _imageURLs;

}

@end
