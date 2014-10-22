//
//  MokaIndicatorView.m
//  mote
//
//  Created by sean on 11/27/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "MokaIndicatorView.h"

#define MOKA_VIEW_BG_COLOR_BLUE [UIColor colorWithRed:227.0/255.0 green:230.0/255.0 blue:237.0/255.0 alpha:1.0]

#define MOKA_WAITTING_VIEW_BG_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]

#define MOKA_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height-20

@implementation MokaIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = MOKA_WAITTING_VIEW_BG_COLOR;
        self.viewIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.viewIndicator setFrame:CGRectMake(110, 220, 20, 20)];
        [self addSubview:self.viewIndicator];
        
        self.labelHint = [[UILabel alloc] initWithFrame:CGRectMake(140, 220, 150, 20)];
        self.labelHint.text = @"正在加载...";
        self.labelHint.textColor = [UIColor whiteColor];
        self.labelHint.font = [UIFont systemFontOfSize:15.0f];
        self.labelHint.backgroundColor = [UIColor clearColor];
        [self addSubview:self.labelHint];
    }
    return self;
}

-(void)start{
    [self.viewIndicator startAnimating];
}

-(void)stop{
    [self removeFromSuperview];
    [self.viewIndicator stopAnimating];
}


@end
