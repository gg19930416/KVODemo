//
//  ViewController.m
//  KVODemo
//
//  Created by 郭刚 on 2018/11/5.
//  Copyright © 2018 郭刚. All rights reserved.
//

#import "ViewController.h"
#import "myKVO.h"


@interface ViewController ()
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIButton *changeNumBtn;
@property (nonatomic,strong) myKVO *myKVO;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.changeNumBtn];
    // 初始化待观察类对象
    self.myKVO = [[myKVO alloc] init];
    /* 1.注册对象myKVO为观察者: option中,
     NSKeyValueObservingOptionOld 以字典的形式提供 "初始对象数据"
     NSKeyValueObservingOptionNew 以字典的形式提供 "更新后新的数据"
     */
    
    [self.myKVO addObserver:self forKeyPath:@"num" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    // Do any additional setup after loading the view, typically from a nib.
}

/* 2.只要object的keyPath 属性发生变化,就会调用此回调方法,进行相应的处理: UI更新 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // 判断是否为self.myKVO的属性"num"
    if ([keyPath isEqualToString:@"num"] && object == self.myKVO) {
        // 相应变化处理: UI更新 (label文本改变)
        self.contentLabel.text = [NSString stringWithFormat:@"当前的num值为: %@",[change valueForKey:@"new"]];
        
        // change的使用: 上文注册时,枚举为2个,因此可以提取change字典中的新、旧值得这两个方法
        NSLog(@"\\nolodnum:%@ newnum:%@",[change valueForKey:@"old"],[change valueForKey:@"new"]);
    }
}

/**KVO以及通知的注销,一般在 -(void)dealloc 中编写.
 为什么要在 didReceiveMemoryWarning 中注销?   因为这个例子是在书上看到的,所以试着使用它的例子,
 (最好还是在 -(void)dealloc 中注销)
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    /* 3.移除KVO */
    [self.myKVO removeObserver:self forKeyPath:@"num" context:nil];
}

#pragma mark - Action
- (IBAction)changeNumBtnDidClicked:(UIButton *)sender {
    // 按一次,使用num的值+1
    self.myKVO.num = self.myKVO.num + 1;
}

#pragma mark - 懒加载

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"label初始化";
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        [_contentLabel setTextColor:[UIColor blueColor]];
        _contentLabel.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50);
    }
    return _contentLabel;
}

- (UIButton *)changeNumBtn {
    if (!_changeNumBtn) {
        _changeNumBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_changeNumBtn setTitle:@"增加1" forState:(UIControlStateNormal)];
        _changeNumBtn.backgroundColor = [UIColor grayColor];
        [_changeNumBtn.titleLabel setTextColor:[UIColor yellowColor]];
        _changeNumBtn.frame = CGRectMake(0, CGRectGetMaxY(_contentLabel.frame)+100, [UIScreen mainScreen].bounds.size.width, 30);
        [_changeNumBtn addTarget:self action:@selector(changeNumBtnDidClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _changeNumBtn;
}


@end
