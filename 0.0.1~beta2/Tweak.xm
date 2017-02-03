static UIWindow *content = nil;

@interface SBBacklightController : NSObject
-(void)animateBacklightToFactor:(float)arg1 duration:(double)arg2 source:(int)arg3 completion:(/*^block*/id)arg4 ;
-(void)_didIdle;
@end

static void destroyView(UIWindow *view) {
    [UIView animateWithDuration:0.75f animations:^{
        [view setAlpha:0.0f];
    } completion:^(BOOL finished) {
        content = nil;
    }];
}

%hook SBBacklightController

-(void)_didIdle {
    content = [[UIWindow alloc]initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)];
    content.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    content.hidden = NO;
    content.windowLevel = UIWindowLevelStatusBar;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = content.bounds;
    effectView.alpha = 0.0f;
    [content addSubview:effectView];
    [UIView animateWithDuration:1.0f animations:^{
        [effectView setAlpha:1.0f];
    } completion:nil];
    %orig;
}

-(void)animateBacklightToFactor:(float)arg1 duration:(double)arg2 source:(int)arg3 completion:(/*^block*/id)arg4 {
	if (arg1 <= 0.075) {
		if (arg1 == 0) {
			// to eliminate even the dim to screen off
			%orig(arg1, 0.25, arg3, arg4);
			// to allow the final dim to screen off
			%orig;
		}
		return;
	}
	%orig;
}

- (void)_resetIdleTimerAndUndim:(_Bool)arg1 source:(int)arg2{
    %orig;
    destroyView(content);
}
- (void)resetIdleTimerAndUndimForBulletin{
    %orig;
    destroyView(content);
}
- (void)resetIdleTimerAndUndim:(_Bool)arg1{
    %orig;
    destroyView(content);
}

%end
