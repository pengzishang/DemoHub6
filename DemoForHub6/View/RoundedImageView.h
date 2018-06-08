//
//  RoundedImageView.h
//  begonia
//
//  Created by weienjie on 2017/4/1.
//  Copyright © 2017年 usmeibao. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface RoundedImageView : UIImageView

@property (nonatomic) IBInspectable CGFloat tml_cornerRadius;
@property (nonatomic) IBInspectable UIColor *tml_borderColor;
@property (nonatomic) IBInspectable CGFloat tml_borderWidth;

@property (nonatomic) IBInspectable BOOL tml_rounded;

@property (nonatomic) IBInspectable BOOL isShadowed;

@end
