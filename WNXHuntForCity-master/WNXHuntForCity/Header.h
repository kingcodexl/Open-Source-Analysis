//
//  Header.h
//  WNXHuntForCity
//
//  Created by kingcode on 15/8/6.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

#ifndef WNXHuntForCity_Header_h
#define WNXHuntForCity_Header_h


#endif


 由于内容比较多,我就按功能模块来介绍给大家了
 首先是左边抽屉的效果以及点击按钮切换控制器
 这里值得注意的是根据苹果推荐的使用方法是,当一个控制器的View是另一控制器view的子控件,那么这个控制器也最好也是另一个控制器的子控制器例如:

 UIViewController *testVC = [UIViewController new];
 [self.view addSubview:testVC.view];
 [self addChildViewController:testVC];
 这里左边的view实际上相当于自己定义一个和系统UITabBarController差不多功能的控件，在最底层有一个控制器（后面称之为主控制器），将左边的按钮view添加到主控制器的view上，创建好右边有所的控制器(首页,发现，消息，设置...)并且将每个右边控制器包装一个导航控制器,将导航控制器按序添加给主控制器做子控制器，默认情况下将首页的导航控制器的view添加给主控制器的view子控件(这样就会默认显示首页),根据左边按钮的点击事件通过代理方法通知主控制器哪个按钮被选中.将旧控制器的view从父视图中移除，将新的view添加到主视图的view,并且用一个临时属性记录之前选中的控制器,这样就完成了点击按钮切换不同的控制器,具体实现代码如下

 //暂时先做没有登陆的情况的点击
 WNXNavigationController *newNC = self.childViewControllers[toIndex];

 if (toIndex == WNXleftButtonTypeIcon) {
 newNC = self.childViewControllers[fromIndex];
 }
 //移除旧的控制器view
 WNXNavigationController *oldNC = self.childViewControllers[fromIndex];
 [oldNC.view removeFromSuperview];

 //添加新的控制器view
 [self.view addSubview:newNC.view];
 newNC.view.transform = oldNC.view.transform;

 self.showViewController = newNC.childViewControllers[0];
 这样就完成了切换控制器
 抽屉的效果是通过给导航控制器的view做形变动画完成的transform的X轴的位移以及整体的缩放效果,这里由于每个导航控制器的功能一样，这里抽取了共同的特点封装了一个基类导航控制器，基类拥有点击左边的按钮完成变形和恢复的功能

 拖动手势是给主控制器添加一个UIPanGestureRecognizer手势(称为pan),当pan开始拖拽时,计算拖动的距离来按比例执行动画,根据手势的状态(pan.status ==UIGestureRecognizerStateEnded)停止时拖动的距离计算出该停留在哪里的位置,需要注意的是这里得记录下当前导航控制器是处于哪种状态,给导航控制器自定义个属性isScale来记录,这里判断很多，具体实现我在代码中每一步都有注释，参照代码即可

 首页
 首页就是一个tableView就可以搞定，tableView的headView颜色和数据服务器会给返回,给每个headView添加一个点击手势，点击push到下一个控制器,这里需要注意tableViewdelegate中headView的复用headView的复用使用方法和cell差不多,也是系统自带缓存池子,和cell一样注册一下根据identifier来拿取即可,导航条的颜色会和前一个headView的颜色一样,这里由于我之前设置了导航控制器的主题
 [UINavigationBar appearanceWhenContainedIn:self, nil]
 所以不可以直接设置导航条的颜色了 ,然后我尝试了设置navigationBar的背景色，设置navigationBar的setTintColor:
 设置navigationBar.layer的背景色 以及根据颜色画出navigationBar的背景图片4种办法都无法达到原生的效果
 最后采用将navigationBar隐藏，自己放一个View了充当了导航条来解决这个问题(需要注意当切换控制器是对导航条隐藏属性的设置)
 - (void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 //隐藏系统的导航条，由于需要自定义的动画，自定义一个view来代替导航条
 [self.navigationController setNavigationBarHidden:YES animated:YES];
 }
 发现
 这个页面是一个UICollectionView,里面有两组数据，每一组都一个一个headView,需要注意的就是cell的点击事件,注意了下官方的做法是不论点击了cell的哪个位置，都会使cell内部的button进入高亮状态,这就需要用到事件的响应链,在cell的内部拦截整个cell的点击事件都交给按钮来做，具体代码如下

 - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
 {
 /*  拦截事件响应者，不论触发了cell中的哪个控件都交给iconButton来响应 */
// 1.判断当前控件能否接收事件
if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;

// 2. 判断点在不在当前控件
if ([self pointInside:point withEvent:event] == NO) return nil;

return self.iconButton;
}
但这里需要注意这样拦截cell的点击事件，在collectionView的cell被点击后didDeselectItemAtIndexPath:就不会被触发了，我的解决方法是在点击button时通过自定义代理方法通知collectionView所在的控制器，这样外部就知道点击了那个cell,便可以拿到cell的模型push到下一个控制器,并将cell的模型赋值给下一个控制器
-(void)iconButtonClick:(UIButton *)sender
{
    //点击button通知代理
    if ([self.delegate respondsToSelector:@selector(foundCollectionViewCell:)]) {
        [self.delegate foundCollectionViewCell:self];
    }
}
登陆
登陆只用了微信登陆和新浪登陆,不涉及到注册就非常简单,好多公司都会要求要用原生的登陆,只需要去新浪和微信的官网将SDK下载下来,并且按照官方给的帮助文档操作即可,如果公司没用硬性要求的话,我一般使用友盟平台的登陆,包括崩溃统计,三方登陆,分享,用户分析等等(这里提一嘴貌似QQ原生登陆必须写在appDelegate中,别的都写在哪里都行,遇到一次这个情况,有解决办法的朋友可以告诉我)
消息
一样这里也是tabelView,这里我个人的逻辑是将所有的未读的消息存放到本地数据库,每次点击删除一条，将本地的数据删除一条，有新的消息时直接写入到数据库
当点击删除全部的时候，就清空本地的数据清空，下次接受的服务器的数据在重新写入到数据库,每次点击消息页面时去数据库查看是否有未读消息,如果有未读数据,变显示编辑按钮和cell

因为是模拟的数据，为了保障每次进来都有数据,就没有实现归档解档的操作，所以每次删除后重新进入会再次有数据

这里记录编辑按钮的状态,读取本地是否有未读消息数组的个数，如果有就显示编辑按钮，记录编辑按钮的状态，如果是选中状态就隐藏cell中箭头图片，显示删除按钮，并且将删除按钮的状态设为选中,这样就可以切换按钮的文字了,将本地的数据数组删除掉并且刷新tableView，这里用的是删除动画，需要注意删除的顺序

[self.datas removeObjectAtIndex:indexPath.row];
[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
//加入延时调用是防止删除后过快的就刷新tableView
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
});
底部的删除完全交给编辑按钮来控制,选中状态时出现,非选中状态时消失,点击删除全部,直接将数组中的模型全部移除,然后清空数据库里的数据,刷新tableView
搜索

搜索
这个也需要持久化存储来记录用户的操作由于数据量比较小直接用plist即可,每次页面弹出后,先从本地读取用户历史搜索的数据,用户每次删除或者新输入搜索框内容时也直接写入到本地的caches文件中

设置textFiled的代理,监听用户的完成输入,判断textFiled的text是否有长度,如果有的话发送给服务器响应的请求,并且将用户数据的string保存到本地的plist中

这里需要提一下关于热门按钮的布局,因为热门的文字长度不一样，但每次只有4个按钮,在xib中先将按钮的位置约束好,不过宽度的约束需要俩个,一个是>= 和<= 然后根据服务器返回的实际长度在设置按钮title时,计算出每个按钮的真实宽度，根据真实宽度算出间距是多少，重新布局一次按钮的位置

(void)setHotDatas:(NSMutableArray *)hotDatas
{
    _hotDatas = hotDatas;
    //判断是长度是否是4,开发中可以这样写 应该服务器返回几条数据就赋值多少,而不是固定的写死数据,
    //万一服务器返回的数据有错误,会造成用户直接闪退的,有
    //时在某些不是很重要的东西无法确定返回的是否正确,建议用
    //@try    @catch来处理,
    //即便返回的数据有误,也可以让用户继续别的操作，
    //而不会在无关紧要的小细节上造成闪退

    if (hotDatas.count == 4) {
        [self.hotButton1 setTitle:hotDatas[1] forState:UIControlStateNormal];
        [self.hotButton2 setTitle:hotDatas[0] forState:UIControlStateNormal];
        [self.hotButton3 setTitle:hotDatas[2] forState:UIControlStateNormal];
        [self.hotButton4 setTitle:hotDatas[3] forState:UIControlStateNormal];
    }
    [self layoutIfNeeded];

    //算出间距
    CGFloat margin = (WNXAppWidth - 40 -
                      self.hotButton1.bounds.size.width -
                      self.hotButton2.bounds.size.width -
                      self.hotButton3.bounds.size.width -
                      self.hotButton3.bounds.size.width) / 3;

    //更新约束
    [self.hotButton2 updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotButton1.right).offset(margin);
    }];

    [self.hotButton3 updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotButton2.right).offset(margin);
    }];

    [self.hotButton4 updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotButton3.right).offset(margin);
    }];
}
模糊效果

模糊效果
这里由于图片的质量被压缩的太厉害,实际的效果还不错,这个功能是iOS8新开放的新接口,有俩个图片特效可以使用,一个是模糊blur,一个是颜色叠加(类似于PS中图片叠加的效果,不过就3种效果)
封装一个blurView,blurView的子控件有一个collectionView做用户选择用,一个imageView做模糊背景,以及一个取消按钮,将blurView添加给控制器的view做子控件,并且默认alpha值为0, 每次点击分类,地区,或者排序时,渲染当前tableView的layer的图片,并且将渲染好的图片赋值给blurView中的imageView,给imageView添加模糊效果,在配合改变blurView的alpha完成出现和消失即可
详情页

详情页展示
这个页面坑很多,需要注意的细节太多，也是我耗时最久的页面，诚然目前bug依旧不少

这个页面的层级关系很重要,需要重点注意

首先是导航条,这个咋一看好像是导航条有个渐隐渐现的动画,我的做法是在顶部放了一个高度为64的view,根据tableView的偏移量计算出view的透明度,但是透明度只是1或者0,顶部的scrollView里面装的imageView,根据服务器返回的图片地址个数，设置他的展示内容大小,并且在整一个scrollView最上面添加一个和导航条一样颜色的view,用它来做出向上推慢慢出现绿色的效果,并且根据底部scrollview的偏移计算拉伸的大小,这里拉伸的大小我算的不是很准确,感觉需要将锚点钉在最顶端,这应就可以做到只拉伸底部

然后是中间切换tableView的view（后面就叫它选择view）,要实现能像headView一样,卡在导航条下面的效果,这里因为没有导航条,并且在切换tableView时候不会带走选择view,所以只能将他放到和顶部的view在同一个层级中，同样根据底部scrollView的contentOffset.y计算他的位置,当偏移量超过顶部的64时，就停留在那,不超过时就回到顶部view的下面,这里的计算我加了很多的注释,怕计算的朋友也会看的懂的，大概是这样

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.rmdTableView || scrollView == self.infoTableView) {//说明是tableView在滚动

        //记录当前展示的是那个tableView
        self.showingTableView = (UITableView *)scrollView;

        //记录出上一次滑动的距离，因为是在tableView的contentInset中偏移的ScrollHeadViewHeight，所以都得加回来
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat seleOffsetY = offsetY - self.scrollY;
        self.scrollY = offsetY;

        //修改顶部的scrollHeadView位置 并且通知scrollHeadView内的控件也修改位置
        CGRect headRect = self.topView.frame;
        headRect.origin.y -= seleOffsetY;
        self.topView.frame = headRect;


        //根据偏移量算出alpha的值,渐隐,当偏移量大于-180开始计算消失的值
        CGFloat startF = -180;
        //初始的偏移量Y值为 顶部俩个控件的高度
        CGFloat initY = SelectViewHeight + ScrollHeadViewHeight;
        //缺少的那一段渐变Y值
        CGFloat lackY = initY + startF;
        //自定义导航条高度
        CGFloat naviH = 64;

        //渐隐alpha值
        CGFloat alphaScaleHide = 1 - (offsetY + initY- lackY) / (initY- naviH - SelectViewHeight - lackY);
        //渐现alph值
        CGFloat alphaScaleShow = (offsetY + initY - lackY) /  (initY - naviH - SelectViewHeight - lackY) ;

        if (alphaScaleShow >= 0.98) {
            //显示导航条
            [UIView animateWithDuration:0.04 animations:^{
                self.naviView.alpha = 1;
            }];
        } else {
            self.naviView.alpha = 0;
        }
        self.topScrollView.naviView.alpha = alphaScaleShow;
        self.subTitleLabel.alpha = alphaScaleHide;
        self.smallImageView.alpha = alphaScaleHide;

        /* 这段代码很有深意啊。。最开始是直接用偏移量算的，但是回来的时候速度比较快时偏移量会偏度很大
         然后就悲剧了。换了好多方法。。最后才开窍T——T,这一段我会在blog里面详细描述我用的各种错误的方法
         用了KVO监听偏移量的值,切换了selectView的父控件，切换tableview的headView。。。
         */
        if (offsetY >= -(naviH + SelectViewHeight)) {
            self.selectView.frame = CGRectMake(0, naviH, WNXAppWidth, SelectViewHeight);
        } else {
            self.selectView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), WNXAppWidth, SelectViewHeight);
        }

        CGFloat scaleTopView = 1 - (offsetY + SelectViewHeight + ScrollHeadViewHeight) / 100;
        scaleTopView = scaleTopView > 1 ? scaleTopView : 1;

        //算出头部的变形 这里的动画不是很准确，好的动画是一点一点试出来了  这里可能还需要配合锚点来进行动画,关于这种动画我会在以后单开一个项目配合blog来讲解的 这里这就不细调了
        CGAffineTransform transform = CGAffineTransformMakeScale(scaleTopView, scaleTopView );
        CGFloat ty = (scaleTopView - 1) * ScrollHeadViewHeight;
        self.topView.transform = CGAffineTransformTranslate(transform, 0, -ty * 0.2);

        //记录selectViewY轴的偏移量,这个是用来计算每次切换tableView，让新出来的tableView总是在头部用的，
        //现在脑子有点迷糊 算不出来了。。凌晨2.57分~
        CGFloat selectViewOffsetY = self.selectView.frame.origin.y - ScrollHeadViewHeight;

        if (selectViewOffsetY != -ScrollHeadViewHeight && selectViewOffsetY <= 0) {

            if (scrollView == self.rmdTableView) {

                self.infoTableView.contentOffset = CGPointMake(0, -245 - selectViewOffsetY);

            } else {

                self.rmdTableView.contentOffset = CGPointMake(0, -245 - selectViewOffsetY);

            }
        }

    } else {
        //说明是backgroundScrollView在滚动

        CGFloat selectViewOffsetY = self.selectView.frame.origin.y - ScrollHeadViewHeight;
        //让新出来的tableView的contentOffset正好卡在selectView的头上,还是有bug
        if (selectViewOffsetY != -ScrollHeadViewHeight && selectViewOffsetY <= 0) {

            if (self.showingTableView == self.rmdTableView) {

                self.infoTableView.contentOffset = CGPointMake(0, -245 - selectViewOffsetY);

            } else {

                self.rmdTableView.contentOffset = CGPointMake(0, -245 - selectViewOffsetY);

            }
        }

        CGFloat offsetX = self.backgroundScrollView.contentOffset.x;
        NSInteger index = offsetX / WNXAppWidth;

        CGFloat seleOffsetX = offsetX - self.scrollX;
        self.scrollX = offsetX;

        //根据scrollViewX偏移量算出顶部selectViewline的位置
        if (seleOffsetX > 0 && offsetX / WNXAppWidth >= (0.5 + index)) {
            [self.selectView lineToIndex:index + 1];
        } else if (seleOffsetX < 0 && offsetX / WNXAppWidth <= (0.5 + index)) {
            [self.selectView lineToIndex:index];
        }
    }
}
下面是一个scrollView上添加了3个tabelView,根据服务器返回的数据判断显示多少个,这里就只显示了俩个tableView演示一下,如果有第三个的话直接添加到底部的scrollView即可,我的代码中因为只是演示两个tableView就将两个tableView交给了一个控制器管理,如果多个tableView最好将每个tableView交给独立的一个控制器来管理,各司其职,这样逻辑会清晰很多
这些就是这个项目的大体思路,当然还有很多很多的细节都在代码中,感觉自己有很多想要表达的但是没法说出来,所以我在代码中加的很详细的注释,第一次尝试将思路写出来,感觉有很多不足,本应该每完成一个功能就总结一下,而我是在发布的晚上回头总结的,有很多当时的思路不是很清晰了...以后我会改善的,大家有什么意见可以直接留言,我看到会一一回复的!
注意下载完工程请直接打开
 */