//
//  ViewController.m
//  DemoForHub6
//
//  Created by pzs on 2018/6/7.
//  Copyright © 2018年 boyue. All rights reserved.
//

#import "ViewController.h"
#import "RoundedImageView.h"
#import "RoundedButton.h"
#import "UIColor+Additions.h"
#import "RoundedView.h"
@interface ViewController ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutletCollection(RoundedButton) NSArray <RoundedButton *>*btns;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray <UILabel *>*labs;
@property (weak, nonatomic) IBOutlet SliderView *mainHandlerView;
@property (weak, nonatomic) IBOutlet ScrollView *scrollView;
@property (weak, nonatomic) IBOutlet RoundedImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *temp;
@property (weak, nonatomic) IBOutlet UIImageView *smallIcon;
@property (weak, nonatomic) IBOutlet UILabel *smallTitle;





@end

@implementation ViewController

#define IMAGE_NAMED(name) [UIImage imageNamed:name]
#define ToRad(deg)         ( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)        ( (180.0 * (rad)) / M_PI )
#define SQR(x)            ( (x) * (x) )
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)

static const NSUInteger BaseTag = 1000;

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak __typeof(self)weakSelf = self;
    self.mainImage.layer.shadowOffset =  CGSizeMake(0, 0);
    self.mainImage.layer.shadowColor = [UIColor grayColor].CGColor;
    self.mainImage.layer.shadowOpacity = 0.2;
    self.mainImage.layer.shadowRadius = 5;
    self.mainHandlerView.changeValue = ^(NSUInteger temp) {
        weakSelf.temp.text = @(temp).stringValue;
    };
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)didClickBtn:(UIButton *)sender {
    [self cleanBtnStyle];
    [self cleanLabStyle];
    [self handlerSmallIconWithBtnTag:sender.tag - BaseTag];
    NSString *imageOrginName = [NSString stringWithFormat:@"%@_Highlight",sender.accessibilityIdentifier];
    [sender setImage:IMAGE_NAMED(imageOrginName) forState:UIControlStateNormal];
    UILabel *targetLabel  = [self.view viewWithTag:sender.tag + BaseTag];
    [targetLabel setTextColor:[UIColor whiteColor]];
}

- (void)cleanBtnStyle {
    [self.btns enumerateObjectsUsingBlock:^(RoundedButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *imageOrginName =  obj.accessibilityIdentifier;
        [obj setImage:IMAGE_NAMED(imageOrginName) forState:UIControlStateNormal];
    }];
}

- (void)cleanLabStyle {
    [self.labs enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textColor = [UIColor colorWithHexString:@"666666"];
    }];
}

- (void)handlerSmallIconWithBtnTag:(NSInteger)tag {
    NSArray *iconName = @[@"Icon_Heat",@"Icon_Cool",@"Icon_HeatCool",@""];
    NSArray *iconTitle = @[@"Heat",@"Cool",@"HeatCool",@"Off"];
    self.smallIcon.image = IMAGE_NAMED(iconName[tag]);
    self.smallTitle.text = iconTitle[tag];
}


@end

static NSUInteger const kLineWidth = 30;//图片的半径
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    //p1是中心点
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

@interface  SliderView  ()

@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) CATextLayer *textLayer;
@property (nonatomic, strong) CALayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, assign) BOOL didDrawMask;

@end

@implementation  SliderView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.radius = self.frame.size.width/2 - kLineWidth;
        self.angle = 0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
        CGPoint point = [self pointFromAngle:self.angle];

    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.radius startAngle:0 endAngle:ToRad(self.angle) clockwise:YES];
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.frame = self.bounds;
    self.progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    self.progressLayer.strokeColor  = [[UIColor greenColor] CGColor];
    self.progressLayer.lineCap = kCALineCapSquare;
    self.progressLayer.lineWidth = kLineWidth - 15;
    self.progressLayer.path = [path CGPath];
    
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = [CALayer layer];
    self.didDrawMask = YES;
    //黄色到红色
    CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
    [gradientLayer2 setLocations:@[@0.1,@1]];
    gradientLayer2.frame = CGRectMake(0, 0,self.frame.size.width, self.frame.size.height/2);
    [gradientLayer2 setColors:@[(id)[[UIColor yellowColor] CGColor],(id)[[UIColor redColor] CGColor]]];
    [gradientLayer2 setStartPoint:CGPointMake(0, 0)];
    [gradientLayer2 setEndPoint:CGPointMake(1, 0)];
    [self.gradientLayer addSublayer:gradientLayer2];
    
    
    //蓝色 到 黄色
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, self.frame.size.height/2- kLineWidth/2, self.frame.size.width, self.frame.size.height/2+kLineWidth/2);
    [gradientLayer1 setColors:@[(id)[[UIColor yellowColor] CGColor],(id)[[UIColor blueColor] CGColor]]];
    [gradientLayer1 setLocations:@[@0.1,@1]];
    [gradientLayer1 setStartPoint:CGPointMake(0, 0)];
    [gradientLayer1 setEndPoint:CGPointMake(1, 0)];
    [self.gradientLayer addSublayer:gradientLayer1];
    
    


    [self.gradientLayer setMask:_progressLayer];
    [self.layer addSublayer:self.gradientLayer];

    
    NSString *tempStr = @(16 + (NSUInteger)(16*self.angle/360)).stringValue;
    !self.changeValue?:self.changeValue(16 + (NSUInteger)(16*self.angle/360));
    
    UIFont *font = [UIFont systemFontOfSize:14];
    
    NSMutableDictionary *attributesDic = [NSMutableDictionary dictionary];
    attributesDic[NSForegroundColorAttributeName] = [UIColor redColor];
    attributesDic[NSFontAttributeName] = font;
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect tempRect =  [tempStr boundingRectWithSize:CGSizeMake(KScreenWidth, MAXFLOAT) options:options attributes:attributesDic context:nil];
    [tempStr drawAtPoint:CGPointMake(point.x + tempRect.size.width/2, point.y + tempRect.size.height/2 - 1.5) withAttributes:attributesDic];
    

    
    [self.imageLayer removeFromSuperlayer];
    self.imageLayer = [CALayer layer];
    self.imageLayer.frame = CGRectMake(point.x, point.y, kLineWidth, kLineWidth);
    self.imageLayer.contents = (id)IMAGE_NAMED(@"Drag").CGImage;
    self.imageLayer.shadowOffset =  CGSizeMake(0, 0);
    self.imageLayer.shadowColor = [UIColor grayColor].CGColor;
    self.imageLayer.shadowOpacity = 0.8;
    self.imageLayer.shadowRadius = 10;
    self.imageLayer.opacity = 0.9f;
    [self.layer addSublayer:self.imageLayer];
    
    [self.textLayer removeFromSuperlayer];
    self.textLayer = [CATextLayer layer];
    self.textLayer.foregroundColor = [UIColor blackColor].CGColor;
    
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    self.textLayer.font = fontRef;
    self.textLayer.contentsScale = 2;
    self.textLayer.fontSize = font.pointSize;
    self.textLayer.frame = CGRectMake(point.x + tempRect.size.width/2, point.y + tempRect.size.height/2 - 1.5, 20, 20);
    self.textLayer.string = tempStr;
    [self.layer addSublayer:self.textLayer];
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    return YES;
}


-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    //获取触摸点
    CGPoint lastPoint = [touch locationInView:self];
    //使用触摸点来移动小块
    [self movehandle:lastPoint];
    //发送值改变事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

-(CGPoint)pointFromAngle:(int)angleInt{
    //中心点
    CGPoint centerPoint = self.center;
    //根据角度得到圆环上的坐标
    CGPoint result;
    result.y = round(centerPoint.y + self.radius * sin(ToRad(angleInt))-kLineWidth/2);
    result.x = round(centerPoint.x + self.radius * cos(ToRad(angleInt))-kLineWidth/2);
    return result;
}

-(void)movehandle:(CGPoint)lastPoint{
    //获得中心点
    CGPoint centerPoint = self.center;
    //计算中心点到任意点的角度
    float currentAngle = AngleFromNorth(centerPoint,lastPoint, NO);
    int angleInt = floor(currentAngle);
    //保存新角度
    self.angle = angleInt;
    
    //重新绘制
    [self setNeedsDisplay];
}


@end


@interface  ScrollView  ()

@end

@implementation  ScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:[self viewWithTag:10000]];
    return !CGRectContainsPoint([self viewWithTag:10000].frame,point);
}


@end
