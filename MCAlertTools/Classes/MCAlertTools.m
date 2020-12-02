//
//  MCAlertTools.m
//  MCAlertTools
//
//  Created by M了个C on 2017/6/30.
//  Copyright © 2017年 M了个C. All rights reserved.
//

#import "MCAlertTools.h"
#import <objc/runtime.h>

#pragma mark - UIAlertView类别
//  扩充类别属性
@interface UIAlertView (MCAlertTools)
@property (copy, nonatomic) CallBackBlock clickBlock;
@end
@implementation UIAlertView (MCAlertTools)

- (void)setClickBlock:(CallBackBlock)clickBlock{
    objc_setAssociatedObject(self, @selector(clickBlock), clickBlock, OBJC_ASSOCIATION_COPY);
}
- (CallBackBlock)clickBlock{
    return objc_getAssociatedObject(self, @selector(clickBlock));
}
@end
#pragma mark - UIActionSheet类别扩展

@interface UIActionSheet (MCAlertTools)
@property (copy, nonatomic) CallBackBlock clickBlock;
@end
@implementation UIActionSheet (MCAlertTools)

- (void)setClickBlock:(CallBackBlock)clickBlock{
    objc_setAssociatedObject(self, @selector(clickBlock), clickBlock, OBJC_ASSOCIATION_COPY);
}
- (CallBackBlock)clickBlock{
    return objc_getAssociatedObject(self, @selector(clickBlock));
}

@end

@interface MCAlertTools ()<UIAlertViewDelegate, UIActionSheetDelegate>

@end
@implementation MCAlertTools


#pragma mark - 简易（最多支持单一按钮,按钮无执行响应）alert定义 兼容适配 -
+ (void)showTipAlertViewWith:(UIViewController *)viewController
                       title:(NSString *)title
                     message:(NSString *)message
                 buttonTitle:(NSString *)btnTitle
                 buttonStyle:(MCAlertActionStyle)btnStyle{
    viewController = [self checkViewController:viewController];
    if (iOS_Version >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        //  添加按钮
        if (btnTitle) {
            UIAlertAction *singleAction = nil;
            switch (btnStyle) {
                case MCAlertActionStyleCancel:
                    singleAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertController addAction:singleAction];
                    break;
                case MCAlertActionStyleDefault:
                    singleAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertController addAction:singleAction];
                    break;
                case MCAlertActionStyleDestructive:
                    singleAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertController addAction:singleAction];
                    break;
                default:
                    singleAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertController addAction:singleAction];
                    break;
            }
        }
        
        [viewController presentViewController:alertController animated:YES completion:nil];
        //  如果没有按钮, 自动延迟消失
        if (!btnTitle) {
            //  此时self指本身
            //TODO: performSelector
            [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:AlertViewShowTime];
        }
    }else{
        UIAlertView *alert = nil;
        if (btnTitle) {
            switch (btnStyle) {
                case MCAlertActionStyleDefault:
                    alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:btnTitle, nil];
                    break;
                case MCAlertActionStyleCancel:
                    alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:btnTitle otherButtonTitles:nil, nil];
                    break;

                default://  默认
                    alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:btnTitle, nil];
                    break;
            }
        }else{
            alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        }
        [alert show];
        //  如果没有按钮, 自动延迟消失
        if (!btnTitle) {
            [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:AlertViewShowTime];
        }
    }
}

#pragma mark - actionSheet实现 底部简易提示窗 无按钮 -
+ (void)showBottomTipViewWith:(UIViewController *)viewController
                        title:(NSString *)title
                      message:(NSString *)message{
    viewController = [self checkViewController:viewController];
    if (iOS_Version >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        [viewController presentViewController:alertController animated:YES completion:nil];
        //  如果没有按钮, 自动延迟消失
        [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:AlertViewShowTime];
    }else{
        UIActionSheet  *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        //  如果没有按钮, 自动延迟消失
        [self performSelector:@selector(dismissActionSheet:) withObject:actionSheet afterDelay:AlertViewShowTime];
    }
}

#pragma mark - 普通alert定义 兼容适配alertView和alertController -
+ (void)showAlertWith:(UIViewController *)viewController
                title:(NSString *)title
              message:(NSString *)message
        callbackBlock:(CallBackBlock)block
    cancelButtonTitle:(NSString *)cancelBtnTitle
destructiveButtonTitle:(NSString *)destructiveBtnTitle
    otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    viewController = [self checkViewController:viewController];
    if (iOS_Version >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        //  添加按钮
        if (cancelBtnTitle) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                block(0);
            }];
            [alertController addAction:cancelAction];
        }
        if (destructiveBtnTitle) {
            UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveBtnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                if (cancelBtnTitle) {
                    block(1);
                }else { block(0); }
            }];
            [alertController addAction:destructiveAction];
        }
        if (otherButtonTitles) {
            UIAlertAction *otherActions = [UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (!cancelBtnTitle && !destructiveBtnTitle) {
                    block(0);
                }else if ((cancelBtnTitle && !destructiveBtnTitle) || (!cancelBtnTitle && destructiveBtnTitle)){
                    block(1);
                }else if (cancelBtnTitle && destructiveBtnTitle){
                    block(2);
                }
            }];
            [alertController addAction:otherActions];
            //TODO: 
            va_list args;// 定义一个指向个数可变的参数列表指针
            va_start(args, otherButtonTitles);// 得到第一个可变参数地址
            NSString *title = nil;
            
            int count = 2;
            if (!cancelBtnTitle && !destructiveBtnTitle) {
                count = 0;
            }else if ((cancelBtnTitle && !destructiveBtnTitle) || (!cancelBtnTitle && destructiveBtnTitle)){
                count = 1;
            }else if (cancelBtnTitle && destructiveBtnTitle){
                count = 2;
            }
            while ((title = va_arg(args, NSString *)))// 指向下一个参数地址
            {
                count++;
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    block(count);
                }];
                [alertController addAction:otherAction];
            }
            va_end(args);// 置空指针
        }
        [viewController presentViewController:alertController animated:YES completion:nil];
        
        //  如果没有按钮, 自动延迟消失
        if (!cancelBtnTitle && !destructiveBtnTitle && !otherButtonTitles) {
            [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:AlertViewShowTime];
        }
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:(id<UIAlertViewDelegate>)self cancelButtonTitle:cancelBtnTitle otherButtonTitles:nil];
        alert.clickBlock = block;
        if (otherButtonTitles) {
            [alert addButtonWithTitle:otherButtonTitles];
            va_list args;// 定义指针
            va_start(args, otherButtonTitles);// 得到第一个按钮的地址
            NSString *title = nil;
            while ((title = va_arg(args, NSString *)))// 指向下一个按钮标题的地址
            {
                [alert addButtonWithTitle:title];
            }
            va_end(args);// 置空指针
        }
        [alert show];
        //  如果没有按钮, 自动延迟消失
        if (!cancelBtnTitle && !otherButtonTitles) {
            [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:AlertViewShowTime];
        }
    }
}

#pragma mark - 普通 actionSheet 兼容适配 -
+ (void)showActionSheetWith:(UIViewController *)viewController
                      title:(NSString *)title
                    message:(NSString *)message
              callbackBlock:(CallBackBlock)block
     destructiveButtonTitle:(NSString *)destructiveBtnTitle
          cancelButtonTitle:(NSString *)cancelBtnTitle
          otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION{
    viewController = [self checkViewController:viewController];
    if (iOS_Version >= 8.0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        //  添加按钮
        if (destructiveBtnTitle){
            UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveBtnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                block(0);
            }];
            [alertController addAction:destructiveAction];
        }
        if (cancelBtnTitle){
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (destructiveBtnTitle){
                    block(1);
                }else{block(0);}
            }];
            [alertController addAction:cancelAction];
        }
        if (otherButtonTitles){
            UIAlertAction *otherActions = [UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (!cancelBtnTitle || !destructiveBtnTitle){
                    block(0);
                }else if ((!cancelBtnTitle && destructiveBtnTitle) || (cancelBtnTitle && !destructiveBtnTitle)){
                    block(1);
                }else if (cancelBtnTitle && destructiveBtnTitle){
                    block(2);
                }
            }];
            [alertController addAction:otherActions];
            va_list args;// 定义一个指向个数可变的参数列表的指针
            va_start(args, otherButtonTitles);// 得到第一个title的地址
            NSString *title = nil;
            int count = 2;
            if (!cancelBtnTitle || !destructiveBtnTitle){
                count = 0;
            }else if ((!cancelBtnTitle && destructiveBtnTitle) || (cancelBtnTitle && !destructiveBtnTitle)){
                count = 1;
            }else if (cancelBtnTitle && destructiveBtnTitle){
                count = 2;
            }
            while ((title = va_arg(args, NSString *)))// 指向下一个参数地址
            {
                count++;
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    block(count);
                }];
                [alertController addAction:otherAction];
            }
            va_end(args);// 置空指针
        }
        [viewController presentViewController:alertController animated:YES completion:nil];
        //  如果没有按钮, 自动延迟消失
        if (!cancelBtnTitle && !destructiveBtnTitle && !otherButtonTitles){
            [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:AlertViewShowTime];
        }
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:cancelBtnTitle destructiveButtonTitle:destructiveBtnTitle otherButtonTitles: nil];
        actionSheet.clickBlock = block;
        if (otherButtonTitles){
            [actionSheet addButtonWithTitle:otherButtonTitles];
            va_list args;// 定义指针
            va_start(args, otherButtonTitles);//
            NSString *title = nil;
            while ((title = va_arg(args, NSString *)))
            {
                [actionSheet addButtonWithTitle:title];
            }
            va_end(args);// 置空指针
        }
        [actionSheet showInView:viewController.view];
        //  如果没有按钮, 自动延迟消失
        if (cancelBtnTitle == nil && otherButtonTitles == nil){
            [self performSelector:@selector(dismissActionSheet:) withObject:actionSheet afterDelay:AlertViewShowTime];
        }
    }
    
}

#pragma mark - 多按钮列表数组排布alert初始化 兼容适配 -
+ (void)showArrayAlertWith:(UIViewController *)viewController
                     title:(NSString *)title
                   message:(NSString *)message
             callbackBlock:(CallBackBlock)block
         cancelButtonTitle:(NSString *)cancelBtnTitle
     otherButtonTitleArray:(NSArray *)otherBtnTitleArray
     otherButtonStyleArray:(NSArray *)otherBtnStyleArray{
    viewController = [self checkViewController:viewController];
    if (iOS_Version >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        //  添加按钮
        if (cancelBtnTitle) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                block(0);
            }];
            [alertController addAction:cancelAction];
        }
        if (otherBtnTitleArray && otherBtnTitleArray.count) {
            int count = 0;
            if (cancelBtnTitle) {
                count = 1;
            }else{count = 0;}
            for (int i = 0; i < otherBtnTitleArray.count; i++) {
                NSNumber *styleNum = otherBtnStyleArray[i];
                UIAlertActionStyle actionStyle = styleNum.integerValue;
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherBtnTitleArray[i] style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
                    block(count);
                }];
                [alertController addAction:otherAction];
                count++;
            }
        }
        [viewController presentViewController:alertController animated:YES completion:nil];
        //
        if (!cancelBtnTitle && (otherBtnTitleArray == nil || otherBtnTitleArray.count == 0)) {
            //
            [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:AlertViewShowTime];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:(id<UIAlertViewDelegate>) self cancelButtonTitle:cancelBtnTitle otherButtonTitles: nil];
        alertView.clickBlock = block;
        if (otherBtnTitleArray && otherBtnTitleArray.count) {
            for (NSString *title in otherBtnTitleArray) {
                [alertView addButtonWithTitle:title];
            }
        }
        [alertView show];
        //
        if (!cancelBtnTitle && (otherBtnTitleArray == nil || otherBtnTitleArray.count == 0)) {
            [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:AlertViewShowTime];
        }
    }
}

#pragma mark - 多按钮列表数组排布actionSheet初始化 兼容适配 -
+ (void)showArrayActionSheetWith:(UIViewController *)viewController
                           title:(NSString *)title
                         message:(NSString *)message
                   callbackBlock:(CallBackBlock)block
               cancelButtonTitle:(NSString *)cancelBtnTitle
          destructiveButtonTitle:(NSString *)destructiveBtnTitle
           otherButtonTitleArray:(NSArray *)otherBtnTitleArray
           otherButtonStyleArray:(NSArray *)otherBtnStyleArray{
    viewController = [self checkViewController:viewController];
    if (iOS_Version >= 8.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        //  添加按钮
        if (cancelBtnTitle) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                block(0);
            }];
            [alert addAction:cancelAction];
        }
        if (otherBtnTitleArray && otherBtnTitleArray.count) {
            int count = 0;
            if (cancelBtnTitle) {
                count = 0;
            }else{count = 1;}
            for (int i = 0; i < otherBtnTitleArray.count; i++) {
                NSNumber * styleNum = otherBtnStyleArray[i];
                UIAlertActionStyle actionStyle =  styleNum.integerValue;
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherBtnTitleArray[i] style:actionStyle handler:^(UIAlertAction *action) {
                    block(count);
                }];
                [alert addAction:otherAction];
                
                count ++;
            }
        }
        [viewController presentViewController:alert animated:YES completion:nil];
        //如果没有按钮，自动延迟消失
        if (cancelBtnTitle == nil && (otherBtnStyleArray == nil || otherBtnStyleArray.count == 0)) {
            //此时self指本类
            [self performSelector:@selector(dismissAlertController:) withObject:alert afterDelay:AlertViewShowTime];
        }
    }else{
        //关联代理强制类型，不能用对象否则代理无效
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:cancelBtnTitle destructiveButtonTitle:destructiveBtnTitle otherButtonTitles:nil];
        actionSheet.clickBlock = block;
        
        if (otherBtnTitleArray && otherBtnTitleArray.count)
        {
            for (NSString * title in otherBtnTitleArray) {
                [actionSheet addButtonWithTitle:title];
            }
        }
        
        [actionSheet showInView:viewController.view];
        
        //如果没有按钮，自动延迟消失
        if (cancelBtnTitle == nil && (otherBtnStyleArray == nil || otherBtnStyleArray.count == 0)) {
            [self performSelector:@selector(dismissActionSheet:) withObject:actionSheet afterDelay:AlertViewShowTime];
        }
    }
}
#pragma mark - 无按钮弹窗自动消失 类方法 否则会崩溃 -
+ (void)dismissAlertController:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
}
+ (void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
+ (void)dismissActionSheet:(UIActionSheet *)actionSheet{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

/** 验证传入的 ViewController 是否存在, 若不存在, 默认为当前 window 的根控制器 */
+ (UIViewController *)checkViewController:(UIViewController *)viewController {
    if (viewController) {
        return viewController;
    }
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

@end

