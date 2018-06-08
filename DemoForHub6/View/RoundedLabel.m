//
//  RoundedLabel.m
//  begonia
//
//  Created by weienjie on 2017/4/10.
//  Copyright © 2017年 usmeibao. All rights reserved.
//

#import "RoundedLabel.h"
#define iPhone6Scale KScreenWidth/375.0
@implementation RoundedLabel


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self draw];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self draw];
    }
    return self;
}

- (void)setTml_cornerRadius:(CGFloat)tml_cornerRadius {
    if (_tml_cornerRadius != tml_cornerRadius) {
        _tml_cornerRadius = tml_cornerRadius;
        [self draw];
    }
}

- (void)setTml_borderColor:(UIColor *)tml_borderColor {
    if (![_tml_borderColor isEqual:tml_borderColor]) {
        _tml_borderColor = tml_borderColor;
        [self draw];
    }
}

- (void)setTml_borderWidth:(CGFloat)tml_borderWidth {
    if (_tml_borderWidth != tml_borderWidth) {
        _tml_borderWidth = tml_borderWidth;
        [self draw];
    }
}

- (void)setTml_rounded:(BOOL)tml_rounded {
    if (_tml_rounded != tml_rounded) {
        _tml_rounded = tml_rounded;
        [self draw];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.tml_rounded) {
        NSUInteger roundSize = self.frame.size.width<=self.frame.size.height?self.frame.size.width:self.frame.size.height;
        self.layer.cornerRadius = roundSize/ 2.0;
        self.tml_cornerRadius = roundSize / 2.0;
    } else {
        if (self.tml_cornerRadius > 0) {
            self.layer.cornerRadius = self.tml_cornerRadius;
        }
    }
}

- (void)draw {
    self.layer.masksToBounds = YES;
    
    if (self.tml_rounded) {
        NSUInteger roundSize = self.frame.size.width<=self.frame.size.height?self.frame.size.width:self.frame.size.height;
        self.layer.cornerRadius = roundSize/ 2.0;
        self.tml_cornerRadius = roundSize / 2.0;
    } else {
        if (self.tml_cornerRadius > 0) {
            self.layer.cornerRadius = self.tml_cornerRadius;
        }
    }
    
    if (self.tml_borderColor && self.tml_borderWidth > 0) {
        self.layer.borderColor = self.tml_borderColor.CGColor;
        self.layer.borderWidth = self.tml_borderWidth;
    }
}

@end
