# StudyForDymanic
Dynamic Dome 学习
转载地址:  http://blog.csdn.net/gmfxch/article/details/46758157</br>
UIDynamic（NS_CLASS_AVAILABLE_IOS(7_0)）动力学框架 类似 Box2d之类的物理引擎，模拟现实生活中的运动，它是通过添加行为的方式让动力学元素参与运动。</br>
iOS7.0提供的动力学行为 ：</br>
UIGravityBehavior     重力行为</br>
{</br>
这是UIGravityBehavior的四个属性，</br>
items是模拟重力行为的模拟对象数组；</br>
angle重力矢量方向与坐标轴x的夹角，例如垂直向下：π/2；</br>
magnitude是重力加速度的倍数；​</br>
vector看结构就是一个点，从坐标原点向这个点连线就是一个矢量，也就是重力的方向，默认是(0.0, 1.0)。</br>这个属性的数据量很丰富，由这个点向X轴和Y轴分别做垂线构成了一个矩形，对角线与X轴夹角就是重力加速度的方向，即angle，对角线的长度就是重力加速度的值，即magnitude。</br>也就是说我们完全可以用gravityDirection变量确定angle和magnitude的值，反之用angle和magnitude也可以确定gravityDirection的值。</br>
}</br>
UICollisionBehavior   碰撞行为</br>
UIAttachmentBehavior  附着行为</br>
UISnapBehavior        吸附行为</br>
UIPushBehavior        推行为</br>
UIDynamicItemBehavior     动力学元素行为</br>
｛</br>
   itemBehavior.resistance = 1.f;  摩擦阻力</br>
   itemBehavior.elasticity = 1.0;  弹性阻力</br>
   itemBehavior.allowsRotation = NO;  
｝</br>

一、重力行为和碰撞行为</br>
UIDynamicAnimator 物理仿真器</br>
UIVIew *_view 模拟运动的视图对象</br>
1.  先初始化要模拟运动的视图对象（只有遵循了UIDynamicItem协议的对象才能参与仿真模拟，而UIView正遵循了此协议，因此所有视图控件都能参与仿真运动）</br>
   _view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];</br>
   _view.backgroundColor = [UIColor blueColor];</br>
  [self.view addSubview:_view];</br>

2. 初始化物理仿真器（相当于box2d引擎中的物理世界，凡是要参与运动的对象必须添加到此容器中）</br>
_animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];</br>
*这里是通过一个视图来初始化的，代表着整个控制器视图范围内就是一个物理仿真器</br>

3. 添加重力行为</br>
_gravity = [[UIGravityBehavior alloc]initWithItems:@[_view]];    //让_view对象参与重力行为运动</br>
[_animator addBehavior:_gravity];         //所有行为必须添加到仿真器中才能生效</br>
到这里我们就可以运行一下程序了，可以看到视图确实可以受到重力影响而下落了，不过会掉出屏幕，为了让物体保留在屏幕内我们要为物体加上碰撞行为。</br>

4 添加碰撞行为</br>
_collision = [[UICollisionBehavior alloc] initWithItems:@[_view]];</br>
_collision.translatesReferenceBoundsIntoBoundary = YES;         //边界检测</br>
[_animator addBehavior:_collision];</br>

再次运行程序，物体在下落后就不会掉出屏幕了，为了让碰撞行为更为直观，我们可以添加更多的物体参与进来，比如点击一下屏幕就产生一个物体。</br>
代码如dome</br>

二、吸附行为UISnapBehavior 和附着行为 UIAttachmentBehavior</br>
代码如dome</br>

三、加速计
四、陀螺仪









//</br>
locationInView和translationInView的区别</br>
1  translationInView是UIPanGestureRecognizer下面的一个属性</br>
locationInView则是UIGestureRecognizer下面的属性</br>
2  translationInView 在指定的坐标系中移动</br>
locationInView 通常是指单点位置的手势 得到当前点击下在指定视图中位置的坐标</br>




