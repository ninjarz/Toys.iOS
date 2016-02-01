//
//  CircularRevealAnimator.h
//  Toys
//
//  Created by linzisheng on 16/1/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CircularRevealAnimator : NSObject
{
    
}

- (nullable instancetype)initWithCenter:(CGPoint)center duration:(CFTimeInterval)duration revert:(BOOL)revert completion:(nullable void (^)(void))completion;
- (nullable instancetype)initWithLayer:(nonnull CALayer*)layer center:(CGPoint)center startRadius:(CGFloat)startRadius endRadius:(CGFloat)endRadius duration:(CFTimeInterval)duration completion:(nullable void (^)(void))completion;
- (void)start;

+ (CGRect)squareWithCenter:(CGPoint)center radius:(CGFloat)radius;
+ (UIViewController* __nullable)getRootViewController;

@end
