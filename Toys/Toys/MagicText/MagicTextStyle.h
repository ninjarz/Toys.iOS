//
//  MagicTextStyle.h
//  Toys
//
//  Created by linzisheng on 16/1/25.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface MagicTextStyle : NSObject
{
    
}

@property(nonatomic, strong, nullable) NSString *tag;
@property(nonatomic, strong, nullable) UIColor *backgroundColor; // MEMO: NSBackgroundColor
@property(nonatomic, strong, nullable) NSMutableDictionary *attributes;
@property(nonatomic, strong, nullable) NSMutableDictionary *dynamicFont;
@property(nonatomic) BOOL isClickable;

- (nonnull instancetype)initWithTag:(nullable NSString*)tag;

- (void)setForegroundColor:(nullable UIColor*)color;
- (void)setFont:(nullable UIFont*)font;
- (void)setUnderlineStyle:(NSUnderlineStyle)style;
- (void)setUnderlineColor:(nullable UIColor*)color;
- (void)addAttributes:(nullable NSDictionary*)attributes;
- (void)addDynamicFont:(nullable NSDictionary*)dynamicFont;

+ (nonnull NSMutableDictionary*)styles;
+ (void)addStyle:(nonnull MagicTextStyle*)style;
+ (void)removeStyleByTag:(nonnull NSString*)tag;
+ (void)removeAllStyle;
+ (nonnull instancetype)styleWithTag:(nullable NSString*)tag;

@end