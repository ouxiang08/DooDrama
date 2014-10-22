//
//  ToastViewAlert.h
//  wochacha
//
//  Created by dream liu on 11-12-21.
//  Copyright (c) 2011年 wochacha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RoundRectCategory)


- (void) roundOffFrame;


// DRAW ROUNDED RECTANGLE
+ (void) drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius;


@end

@class ToastView;
@interface ToastViewAlert : NSObject {
	NSMutableArray *_alerts;
	BOOL _active;
	ToastView *_alertView;
	CGRect _alertFrame;
    float _alertTime;
}

+ (ToastViewAlert*) defaultCenter;
- (void) setTime:(float)time;
- (void) postAlertWithMessage:(NSString*)message image:(UIImage*)image;
- (void) postAlertWithMessage:(NSString *)message;

@end
