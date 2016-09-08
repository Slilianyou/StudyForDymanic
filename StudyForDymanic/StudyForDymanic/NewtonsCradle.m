//
//  NewtonsCradle.m
//  StudyForDymanic
//
//  Created by ss-iOS-LLY on 16/9/8.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "NewtonsCradle.h"
#import "QiuView.h"

@interface NewtonsCradle ()
{
    NSUInteger _ballCount;
    NSArray * _balls;
    NSArray * _anchors;
    UIDynamicAnimator *_animator;
    UIPushBehavior *_userDragBehavior;
    
}
@end

@implementation NewtonsCradle
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _ballCount = 5;
        [self createBallsAndAnchors];
        [self applyDynamicBehaviors];
    }
    return self;
}

- (void)createBallsAndAnchors
{
    NSMutableArray *ballsArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *anchorsArray = [NSMutableArray arrayWithCapacity:0];
    CGFloat ballsize = CGRectGetWidth(self.bounds)/ 3.f / (_ballCount);
    for (int i = 0; i < _ballCount; i++) {
        QiuView *ballView = [[QiuView alloc]initWithFrame:CGRectMake(0, 0, ballsize -1, ballsize - 1)];
        CGFloat x = CGRectGetWidth(self.bounds)/ 3.f + i * ballsize;
        CGFloat y= CGRectGetHeight(self.bounds) / 1.5f;
        ballView.center = CGPointMake(x, y);
        //为球添加UIPushBehavior,支持用户拖动
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [ballView addGestureRecognizer:panGes];
        
        //为球添加Oberser，当球的center属性发生改变时，会通知UIView的方法，刷新view，这儿主要是为了在球移动的时候保持锚点和球之间的连接线。
        [ballView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
        [ballsArray addObject:ballView];
        [self addSubview:ballView];
        
        UIView *blueBox =  [self creatAnchorForBall:ballView];
        [anchorsArray addObject:blueBox];
        [self addSubview:blueBox];
    }
    _balls = ballsArray;
    _anchors = anchorsArray;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
     // Observer方法，当ball的center属性发生变化时，刷新整个view
    if ([keyPath isEqualToString:@"center"]) {
        
        [self setNeedsDisplay];
    }
}
- (UIView *)creatAnchorForBall:(QiuView *)ballView
{
    CGPoint anchor = ballView.center;
    anchor.y -= CGRectGetHeight(self.bounds)/4.f;
    UIView *blueBox = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    blueBox.backgroundColor = [UIColor blueColor];
    blueBox.center = anchor;
    return blueBox;
}
- (void)handlePan:(UIPanGestureRecognizer *)panGes
{
    //用户开始拖动时创建一个新的UIPushBehavior,并添加到animator中
    if (panGes.state == UIGestureRecognizerStateBegan) {
        if (_userDragBehavior) {
            [_animator removeBehavior:_userDragBehavior];
        }
        _userDragBehavior = [[UIPushBehavior alloc]initWithItems:@[panGes.view] mode:UIPushBehaviorModeContinuous];
        [_animator addBehavior:_userDragBehavior];
    }
    CGPoint postion =[panGes translationInView:self];
    _userDragBehavior.pushDirection = CGVectorMake((postion.x / 20.f), 0);
    if (panGes.state == UIGestureRecognizerStateEnded) {
        [_animator removeBehavior:_userDragBehavior];
        _userDragBehavior = nil;
    }
    
}
- (void)applyDynamicBehaviors
{
    //添加UIDynamic的动力行为，同时把多个动力行为组合为一个复杂的动力行为。
    UIDynamicBehavior *behavior = [[UIDynamicBehavior alloc]init];
    [self applyAttachBehaviorForBalls:behavior];
    [behavior addChildBehavior:[self createGravityBehaviorForObjects:_balls]];
    [behavior addChildBehavior:[self createCollisionBehaviorForObjects:_balls]];
    [behavior addChildBehavior:[self createItemBehavior]];
    _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
    [_animator addBehavior:behavior];
    
}
- (UIDynamicBehavior *)createItemBehavior
{
    //    为所有的球的动力行为做一个公有配置，像空气阻力，摩擦力，弹性密度等
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc]initWithItems:_balls];
    itemBehavior.elasticity = 1.0;
    itemBehavior.allowsRotation =YES;
    itemBehavior.resistance = 0.5f;
    return itemBehavior;
}
- (UIDynamicBehavior *)createCollisionBehaviorForObjects:(NSArray *)objects
{
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc]initWithItems:objects];
    return collisionBehavior;
}
- (UIDynamicBehavior *)createGravityBehaviorForObjects:(NSArray *)objects
{
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc]initWithItems:objects];
    gravityBehavior.magnitude = 10;
    return gravityBehavior;
}
- (void)applyAttachBehaviorForBalls:(UIDynamicBehavior *)behavior
{
    for (int i = 0; i < _ballCount; i++) {
        UIDynamicBehavior *attachmentBehavior = [self createAttachmentBehaviorForBallBearing:[_balls objectAtIndex:i] toAnchor:[_anchors objectAtIndex:i]];
        [behavior addChildBehavior:attachmentBehavior];
    }
}
- (UIDynamicBehavior *)createAttachmentBehaviorForBallBearing:(id <UIDynamicItem>)ballBearing toAnchor:(id<UIDynamicItem>)anchor
{
    UIAttachmentBehavior *behavior = [[UIAttachmentBehavior alloc]initWithItem:ballBearing attachedToAnchor:[anchor center]];
    return behavior;
}

//覆盖父类的方法，主要是为了在锚点和球之间画一条线
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (id<UIDynamicItem> ballBearing in _balls) {
        CGPoint anchorCenter = [[_anchors objectAtIndex:[_balls indexOfObject:ballBearing]]center];
        CGPoint ballCenter = [ballBearing center];
        CGContextMoveToPoint(context, anchorCenter.x, anchorCenter.y);
        CGContextAddLineToPoint(context, ballCenter.x, ballCenter.y);
        CGContextSetLineWidth(context, 1.0f);
        [[UIColor blackColor]set];
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    [self setBackgroundColor:[UIColor whiteColor]];
}
//添加了Observer必须释放，不然会造成内存泄露。
-(void)dealloc
{
    for (QiuView *view in _balls) {
        [view removeObserver:self forKeyPath:@"center"];
    }
}


























@end
