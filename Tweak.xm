#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <rootless.h>

@interface UIResponder (lookinLoader)
- (UIViewController *)_viewController;
@end

%group UIDebug
%hook UIResponder
%new
- (UIViewController *)_viewController {
    UIResponder *responder = self;
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        UIAlertController*ac=[UIAlertController alertControllerWithTitle:@"Lookin UIDebug" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"2D Inspection" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_2D" object:nil];
        }];
        UIAlertAction *action2=[UIAlertAction actionWithTitle:@"3D Inspection" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_3D" object:nil];
        }];
        UIAlertAction *action3=[UIAlertAction actionWithTitle:@"Export" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_Export" object:nil];
            });
        }];
        UIAlertAction *action4=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [ac addAction:action1];
        [ac addAction:action2];
        [ac addAction:action3];
        [ac addAction:action4];
        [[self _viewController] presentViewController:ac animated:YES completion:nil];
    }
}
%end
%end

%ctor {
    NSString *framewokPath = ROOT_PATH_NS(@"/Library/Frameworks/LookinServer.framework/LookinServer");
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:ROOT_PATH_NS(@"/var/mobile/Library/Preferences/com.masterking.lookinloader2.plist")];
    NSArray *selectedApplications = [dict objectForKey:@"selectedApplications"];
    if ([selectedApplications containsObject:[[NSBundle mainBundle] bundleIdentifier]]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:framewokPath]) {
            void *handle = dlopen([framewokPath UTF8String], RTLD_NOW);
            if (!handle) {
                char* err = dlerror();
                NSLog(@"[+] LookinLoader load failed:%s",err);
            }else {
                NSLog(@"[+] LookinLoader loaded!");
                %init(UIDebug);
            }
        }
    } else {
        //NSLog(@"当前 app 没有被选中注入 LookinServer... 请在设置中打开");
    }
}