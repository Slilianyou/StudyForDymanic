//
//  SnapAndAttachmentViewController.m
//  StudyForDymanic
//
//  Created by ss-iOS-LLY on 16/9/7.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "SnapAndAttachmentViewController.h"



@interface BackView : UIView
@property (nonatomic, assign) CGPoint point1;
@property (nonatomic, assign) CGPoint point2;

@end

@implementation BackView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 4.0);
    
    CGContextMoveToPoint(context, _point1.x, _point1.y);
    CGContextAddLineToPoint(context, _point2.x, _point2.y);
    
    CGContextStrokePath(context);
}

@end
@interface SnapAndAttachmentViewController ()
{
    UIDynamicAnimator *_animator; // 物理仿真器
    UIGravityBehavior * _gravityBehavior;
    UICollisionBehavior *_collisionBehavior;
    UISnapBehavior    *_snapBehavior;// 吸附（捕捉）行为
    UIAttachmentBehavior *_attchmentBehavior; // 附着行为
    UIView * _view1;
    UIView *_view2;
    
    BackView *_backView; // 用来做物理仿真器视图容器容器范围
    CADisplayLink *_link;
}


@end

@implementation SnapAndAttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
}
- (void)setupUI
{
    _backView = [[BackView alloc]initWithFrame:self.view.bounds];
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    _view2 = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 200, 50)];
    
    
    _backView.backgroundColor = [UIColor whiteColor];
    _view1.backgroundColor = [UIColor blueColor];
    _view1.layer.cornerRadius = 25.f;
    _view2.backgroundColor = [[UIColor greenColor]colorWithAlphaComponent:0.5];
    
    [self.view addSubview:_backView];
    [_backView addSubview:_view1];
    [_backView addSubview:_view2];
    
    // 初始化仿真器
    _animator = [[UIDynamicAnimator alloc]initWithReferenceView:_backView];
    
    // 添加重力行为
    _gravityBehavior = [[UIGravityBehavior alloc]initWithItems:@[_view2]];
    
    
    //添加碰撞行为
    _collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[_view1]];
    _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [_collisionBehavior addItem:_view2];
    
    //添加吸附行为（捕捉行为），意思是让物体吸附到某一点上
    _snapBehavior = [[UISnapBehavior alloc]initWithItem:_view1 snapToPoint:CGPointMake(125, 125)];
    _snapBehavior.damping = 1.0f; // 弹力
    
    //添加附着行为，让_view2视图附着在_view1周围（两物体附着的距离取决于它们的初始位置的距离）
    _attchmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:_view1 attachedToItem:_view2];
    _attchmentBehavior.damping = 0.1; // 弹力
    _attchmentBehavior.frequency = 1.0; // 频率
    
    [_animator addBehavior:_gravityBehavior];
    [_animator addBehavior:_collisionBehavior];
    [_animator addBehavior:_snapBehavior];
    [_animator addBehavior:_attchmentBehavior];
    
    // 添加runloop便于绘制直线
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}
//此方法会在程序绘制每帧时调用一次，再调用backView的drawRect方法绘制线条
- (void)update
{
    _backView.point1 = _view1.center;
    _backView.point2 = _view2.center;
    [_backView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInView:_backView];
     //要先移除原来的吸附行为， 不然物体无法运动
    [_animator removeBehavior:_snapBehavior];
    
    _snapBehavior = [[UISnapBehavior alloc]initWithItem:_view1 snapToPoint:point];
    _snapBehavior.damping = 1.f;
    [_animator addBehavior:_snapBehavior];
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInView:_backView];
    [_animator removeBehavior:_snapBehavior];
    _snapBehavior = [[UISnapBehavior alloc]initWithItem:_view1 snapToPoint:point];
    _snapBehavior.damping = 1.0f;
    [_animator addBehavior:_snapBehavior];
}























@end
