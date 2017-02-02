static UIWindow *content = nil;

@interface SBBacklightController : NSObject
-(void)animateBacklightToFactor:(float)arg1 duration:(double)arg2 source:(int)arg3 completion:(/*^block*/id)arg4 ;
-(void)_didIdle;
@end

%hook SBBacklightController

-(void)_didIdle {
  content = [[UIWindow alloc]initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)];
  content.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
  content.hidden = NO;
  content.windowLevel = UIWindowLevelStatusBar;
  UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
  UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
  effectView.frame = content.bounds;
  [content addSubview:effectView];
  UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPresssed)]autorelease];
  [singleTap setNumberOfTouchesRequired:1];
  [content addGestureRecognizer:singleTap];
	%orig;
}

-(void)animateBacklightToFactor:(float)arg1 duration:(double)arg2 source:(int)arg3 completion:(/*^block*/id)arg4 {
	if (arg1 <= 0.075) {
		if (arg1 == 0) {
			// to eliminate even the dim to screen off
			%orig(arg1, 0, arg3, arg4);
			// to allow the final dim to screen off
			%orig;
      content.hidden = YES;
      content = nil;
		}
		return;
	}
	%orig;
  content.hidden = YES;
  content = nil;
}

- (void)_resetIdleTimerAndUndim:(_Bool)arg1 source:(int)arg2{

	%orig;
	content.hidden = YES;
	content = nil;

}
- (void)resetIdleTimerAndUndimForBulletin{

	%orig;
	content.hidden = YES;
	content = nil;

}
- (void)resetIdleTimerAndUndim:(_Bool)arg1{

	%orig;
	content.hidden = YES;
	content = nil;

}


%new

-(void)tapPresssed{

	content.hidden = YES;
	content = nil;

}

%end
