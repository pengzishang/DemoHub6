//
//  ViewController.h
//  DemoForHub6
//
//  Created by pzs on 2018/6/7.
//  Copyright © 2018年 boyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end

@interface  SliderView : UIControl

@property (nonatomic, copy) void (^changeValue)(NSUInteger temp);

@end

@interface   ScrollView: UIScrollView

@end


