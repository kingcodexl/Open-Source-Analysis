//
//  XSportLight.m
//  XSportLight
//
//  Created by xlx on 15/8/22.
//  Copyright (c) 2015年 xlx. All rights reserved.
//

#import "XSportLight.h"

@interface XSportLight ()
/**
 *  记录当前是显示的第几个高亮
 */
@property (nonatomic, assign) int index;
/**
 *  显示的View
 */
@property (nonatomic, strong) UIView *showView;

@end


@implementation XSportLight
#pragma mark - 初始化方法
-(id)init{
    self = [super init];
    // 设置模态视图呈现的方式为全屏模式
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    return  self;
}

#pragma mark - 生命周期
-(void)viewDidLoad{
    [super viewDidLoad];
    _index = 0;
    [self show];
}

-(void)show{
    modalState = [[EMHint alloc] init];
    [modalState setHintDelegate:self];
    _showView = [modalState presentModalMessage:_messageArray[_index] where:self.view];
    [self.view addSubview:_showView];
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_showView addGestureRecognizer:tap];
}

/**
 *  点击处理
 */
- (void)tap{
    _index++;
    if ([_delegate respondsToSelector:@selector(XSportLightClicked:)]) {
        [_delegate XSportLightClicked:_index];
    }
// TODO
    if (_index >= _messageArray.count) {
        [self dismissViewControllerAnimated:false completion:^{
            
        }];
    }else{
        [_showView removeFromSuperview];
        [self show];
    }
}

/**
 *  下一
 */
-(void)doNext
{
    NSString *message = _messageArray[_index];
    [modalState presentModalMessage:message where:self.navigationController.view];
}

#pragma mark - HInt Delegate

-(NSArray*)hintStateRectsToHint:(id)hintState
{
    NSArray *rectArray = nil;
    NSValue *value = _rectArray[_index];
    CGRect rect = value.CGRectValue;
    rectArray = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:rect], nil];
    return rectArray;
}
-(void)hintStateWillClose:(id)hintState
{
    NSLog(@"i am about to close: %@",hintState);
}
-(void)hintStateDidClose:(id)hintState
{
    NSLog(@"i closed: %@",hintState);
}










@end
