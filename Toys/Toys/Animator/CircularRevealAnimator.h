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

- (instancetype __nullable)initWithCenter:(CGPoint)center duration:(CFTimeInterval)duration revert:(BOOL)revert completion:(void (^ __nullable)(void))completion;
- (instancetype __nullable)initWithLayer:(CALayer* __nonnull)layer center:(CGPoint)center startRadius:(CGFloat)startRadius endRadius:(CGFloat)endRadius duration:(CFTimeInterval)duration completion:(void (^ __nullable)(void))completion;
- (void)start;

+ (CGRect)squareWithCenter:(CGPoint)center radius:(CGFloat)radius;
+ (UIViewController* __nullable)getRootViewController;

@end
