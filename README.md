# StudyForDymanic
Dynamic Dome 学习
转载地址:  http://blog.csdn.net/gmfxch/article/details/46758157</br>
UIDynamic（NS_CLASS_AVAILABLE_IOS(7_0)）动力学框架 类似 Box2d之类的物理引擎，模拟现实生活中的运动，它是通过添加行为的方式让动力学元素参与运动。</br>
iOS7.0提供的动力学行为 ：</br>
UIGravityBehavior     重力行为</br>
UICollisionBehavior   碰撞行为</br>
UIAttachmentBehavior  附着行为</br>
UISnapBehavior        吸附行为</br>
UIPushBehavior        推行为</br>
UIDynamicBehavior     动力学元素行为</br>

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



















