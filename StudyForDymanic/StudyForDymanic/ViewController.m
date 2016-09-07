//
//  ViewController.m
//  StudyForDymanic
//
//  Created by ss-iOS-LLY on 16/9/7.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()
{
    UIDynamicAnimator * _animator; // 物理仿真器
    UIGravityBehavior * _gravityBehavitor; // 重力行为
    UICollisionBehavior * _collisionBehavior; // 碰撞行为
    UIView *  _view; // 模拟运动的视图对象（模拟运动的物体）
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 模拟运动的视图对象
    _view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    _view.backgroundColor = [UIColor redColor];
    [self.view addSubview:_view];
    
    //初始化物理仿真器
    _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view]; // 整个视图控制器就是一个物理仿真器
    // 添加重力行为
    _gravityBehavitor = [[UIGravityBehavior alloc]initWithItems:@[_view]];
    [_animator addBehavior:_gravityBehavitor];
    
    // 添加碰撞行为
    _collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[_view]];
    _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES; // 检测边界
    [_animator addBehavior:_collisionBehavior];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_animator removeAllBehaviors];
}
//TODO:模拟多个物体掉落
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    view.center = point;
    NSInteger r = arc4random_uniform(255) + 1;
     NSInteger g = arc4random_uniform(255) + 1;
     NSInteger b = arc4random_uniform(255) + 1;
    UIColor *color = [UIColor colorWithRed:r/ 255.f green:g / 255.f blue:b / 255.f alpha:1];
    view.backgroundColor = color;
    [self.view addSubview:view];
    
    [_gravityBehavitor addItem:view];
    _gravityBehavitor.gravityDirection = CGVectorMake(-0.2, -1);
    [_collisionBehavior addItem:view];
    
}





















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
