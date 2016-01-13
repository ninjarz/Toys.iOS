//
//  CircularRevealAnimator.m
//  Toys
//
//  Created by linzisheng on 16/1/13.
//
//

#import "CircularRevealAnimator.h"

@interface CircularRevealAnimator()
{
    CALayer *mLayer;
    CAShapeLayer *mMaskLayer;
    UIView *mSnapshotView;
    CABasicAnimation *mAnimation;
    void (^mCompletion)(void);
}

@end

@implementation CircularRevealAnimator

- (instancetype __nullable)initWithCenter:(CGPoint)center duration:(CFTimeInterval)duration completion:(void (^ __nullable)(void))completion
{
    if(self = [super init])
    {
        UIViewController *rootController = [CircularRevealAnimator getRootViewController];
        mSnapshotView = [rootController.view snapshotViewAfterScreenUpdates:NO];
        [rootController.view addSubview:mSnapshotView];
        
        CGFloat x = center.x < rootController.view.frame.size.width - center.x ? rootController.view.frame.size.width - center.x : center.x;
        CGFloat y = center.y < rootController.view.frame.size.height - center.y ? rootController.view.frame.size.height - center.y : center.y;
        CGFloat endRadius = sqrt(x * x + y * y);
        
        mLayer = mSnapshotView.layer;
        mCompletion = completion;
        
        CGPathRef startPathTmp = CGPathCreateWithEllipseInRect([CircularRevealAnimator squareWithCenter:center radius:0], NULL);
        CGMutablePathRef startPath = CGPathCreateMutable();
        CGPathAddRect(startPath, nil, mLayer.bounds);
        CGPathAddPath(startPath, nil, startPathTmp);
        CGPathRef endPathTmp = CGPathCreateWithEllipseInRect([CircularRevealAnimator squareWithCenter:center radius:endRadius], NULL);
        CGMutablePathRef endPath = CGPathCreateMutable();
        CGPathAddRect(endPath, nil, mLayer.bounds);
        CGPathAddPath(endPath, nil, endPathTmp);
        
        mMaskLayer = [CAShapeLayer layer];
        mMaskLayer.path = endPath;
        mMaskLayer.fillRule = kCAFillRuleEvenOdd;
        mMaskLayer.frame = mLayer.bounds;
        mLayer.mask = mMaskLayer;
        
        mAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        mAnimation.fromValue = CFBridgingRelease(startPath);
        mAnimation.toValue = CFBridgingRelease(endPath);
        mAnimation.duration = duration;
        mAnimation.delegate = self;
    }
    
    return self;
}

- (instancetype __nullable)initWithLayer:(CALayer* __nonnull)layer center:(CGPoint)center startRadius:(CGFloat)startRadius endRadius:(CGFloat)endRadius duration:(CFTimeInterval)duration completion:(void (^ __nullable)(void))completion
{
    if(self = [super init])
    {
        mLayer = layer;
        mCompletion = completion;
        
        CGPathRef startPathTmp = CGPathCreateWithEllipseInRect([CircularRevealAnimator squareWithCenter:center radius:startRadius], NULL);
        CGMutablePathRef startPath = CGPathCreateMutable();
        CGPathAddRect(startPath, nil, mLayer.bounds);
        CGPathAddPath(startPath, nil, startPathTmp);
        CGPathRef endPathTmp = CGPathCreateWithEllipseInRect([CircularRevealAnimator squareWithCenter:center radius:endRadius], NULL);
        CGMutablePathRef endPath = CGPathCreateMutable();
        CGPathAddRect(endPath, nil, mLayer.bounds);
        CGPathAddPath(endPath, nil, endPathTmp);
        
        mMaskLayer = [CAShapeLayer layer];
        mMaskLayer.path = endPath;
        mMaskLayer.fillRule = kCAFillRuleEvenOdd;
        mMaskLayer.frame = mLayer.bounds;
        mLayer.mask = mMaskLayer;
        
        mAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        mAnimation.fromValue = CFBridgingRelease(startPath);
        mAnimation.toValue = CFBridgingRelease(endPath);
        mAnimation.duration = duration;
        mAnimation.delegate = self;
    }
    
    return self;
}

- (void)start
{
    [mMaskLayer addAnimation:mAnimation forKey:@"CircularReveal"];
}

+ (CGRect)squareWithCenter:(CGPoint)center radius:(CGFloat)radius
{
    CGRect rect = {center, CGSizeZero};
    return CGRectInset(rect, -radius, -radius);
}

+ (UIViewController* __nullable)getRootViewController
{
    UIViewController *result = nil;
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    id nextResponder = [rootView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        result = topWindow.rootViewController;
    
    return result;
    
    
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    mLayer.mask = nil;
    mAnimation.delegate = nil;
    if (mSnapshotView)
        [mSnapshotView removeFromSuperview];
    
    if (mCompletion)
        mCompletion();
}

@end
