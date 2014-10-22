//
//  MokaIndicatorView.h
//  mote
//
//  Created by sean on 11/27/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MokaIndicatorView : UIView

@property(nonatomic, strong)  UIActivityIndicatorView *viewIndicator;
@property(nonatomic, strong) UILabel *labelHint;

-(void)start;
-(void)stop;

@end
