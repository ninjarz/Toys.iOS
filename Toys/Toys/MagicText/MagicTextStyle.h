//
//  MagicTextStyle.h
//  Toys
//
//  Created by linzisheng on 16/1/25.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MagicTextStyle : NSObject
{
    
}

@property(nonatomic, strong, nullable) NSString *tag;
@property(nonatomic, strong, nullable) NSMutableDictionary *attributes;
@property(nonatomic) BOOL isClickable;

- (nonnull instancetype)initWithTag:(nullable NSString*)tag;

- (void)setForegroundColor:(nullable UIColor*)color;
- (void)setBackgroundColor:(nullable UIColor*)color;
- (void)setFont:(nullable UIFont*)font;

+ (nonnull NSMutableDictionary*)styles;
+ (void)addStyle:(nonnull MagicTextStyle*)style;
+ (void)removeStyleByTag:(nonnull NSString*)tag;
+ (nonnull instancetype)styleWithTag:(nullable NSString*)tag;

@end