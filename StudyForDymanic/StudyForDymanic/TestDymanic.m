//
//  TestDymanic.m
//  StudyForDymanic
//
//  Created by ss-iOS-LLY on 16/9/7.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "TestDymanic.h"
#import "UIView+Dymanic.h"
#import <CoreMotion/CoreMotion.h>

#define SCREEN_WIDTH   (int)[UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  (int)[UIScreen mainScreen].bounds.size.height

@interface TestDymanic ()<UICollisionBehaviorDelegate,UIAccelerometerDelegate>
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) NSMutableArray <UISnapBehavior *>*snaps;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) CMMotionManager *motionManager;
@end

@implementation TestDymanic

- (void)viewDidLoad {
    [super viewDidLoad];
    self.views=[NSMutableArray array];
    self.snaps=[NSMutableArray array];
    self.imgV=[[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.imgV];
 
    for (int i = 0; i<30; i++) {
        UILabel *view = [[UILabel alloc]initWithFrame:CGRectMake(arc4random()%(SCREEN_WIDTH-30),arc4random()%(SCREEN_HEIGHT-30), 30, 30)];
        view.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
        view.text=[NSString stringWithFormat:@"%d",i];
        view.layer.cornerRadius = 15;
        view.textAlignment = NSTextAlignmentCenter;
        view.font = [UIFont systemFontOfSize:22];
        [view setClipsToBounds:YES];
        UISnapBehavior *snap = [[UISnapBehavior alloc]initWithItem:view snapToPoint:CGPointMake(160, 280)];
        [self.snaps addObject:snap];
        [self.views addObject:view];
        [self.view addSubview:view];
    }
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    UICollisionBehavior *clb =[[UICollisionBehavior alloc]initWithItems:self.views];
    UIDynamicItemBehavior * itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.views];
    itemBehavior.elasticity = 0.8;//弹性密度
    [_animator addBehavior:itemBehavior];
    [clb addBoundaryWithIdentifier:@"boundTop" fromPoint:CGPointMake(0, 64) toPoint:CGPointMake(SCREEN_WIDTH, 64)];
    [clb addBoundaryWithIdentifier:@"line"fromPoint:CGPointMake(0, 164) toPoint:CGPointMake(SCREEN_WIDTH-100, 164)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH-100, 2)];
    lineView.backgroundColor = [UIColor redColor];
    [self.view addSubview:lineView];
    [clb addBoundaryWithIdentifier:@"boundLeft" fromPoint:CGPointMake(0, 64) toPoint:CGPointMake(0, SCREEN_HEIGHT-64)];
    [clb addBoundaryWithIdentifier:@"boundBottom" fromPoint:CGPointMake(0, SCREEN_HEIGHT - 49) toPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT -49)];
    [clb addBoundaryWithIdentifier:@"boundRight" fromPoint:CGPointMake(SCREEN_WIDTH, 0) toPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    clb.collisionDelegate = self;
    UIGravityBehavior *grb = [[UIGravityBehavior alloc]initWithItems:self.views];
    grb.magnitude = 1;
    [self.animator addBehavior:grb];
    self.gravityBehavior=grb;
    [self.animator addBehavior:clb];
    
    self.motionManager = [[CMMotionManager alloc]init];
    self.motionManager.accelerometerUpdateInterval = 1 / 30.f; //表示通知频率，表示间隔多少秒通知一次
[self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
    // fabs取正值
    double size = 1 - fabs(accelerometerData.acceleration.z);
    self.gravityBehavior.magnitude = 9.8 *size;
    // atan2(double y,double x) 返回的是原点至点(x,y)的方位角，即与 x 轴的夹角
    // θ = ATan2(y, x)求出的θ取值范围是[-PI, PI]。
    double angle = atan2(-1 *accelerometerData.acceleration.y, accelerometerData.acceleration.x);
    self.gravityBehavior.angle = angle;
}];
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    int i = (int)[self.views indexOfObject:item1];
    int j = (int)[self.views indexOfObject:item2];
    if ([self.animator.behaviors containsObject:self.snaps[i]]) {
        [self.animator removeBehavior:self.snaps[i]];
    }
    if ([self.animator.behaviors containsObject:self.snaps[j]]) {
        [self.animator removeBehavior:self.snaps[i]];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (int i = 0; i < self.snaps.count; i++) {
        if ([self.animator.behaviors containsObject:self.snaps[i]]) {
            [self.animator removeBehavior:self.snaps[i]];
        }
        self.snaps[i] = [[UISnapBehavior alloc]initWithItem:self.views[i] snapToPoint:CGPointMake(arc4random()%(SCREEN_WIDTH-30), arc4random()%(SCREEN_HEIGHT-30))];
        [self.animator addBehavior:self.snaps[i]];

    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.snaps enumerateObjectsUsingBlock:^(UISnapBehavior * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.animator removeBehavior:obj];
    }];
}

















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
