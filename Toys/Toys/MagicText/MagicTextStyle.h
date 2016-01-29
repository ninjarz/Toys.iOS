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

@property(nonatomic, strong) NSString *tag;
@property(nonatomic, strong) NSMutableDictionary *attributes;
@property(nonatomic) BOOL isClickable;

- (instancetype)initWithTag:(NSString*)tag;

- (void)setForegroundColor:(UIColor*)color;
- (void)setBackgroundColor:(UIColor*)color;
- (void)setFont:(UIFont*)font;

+ (NSMutableDictionary*)styles;
+ (void)addStyle:(MagicTextStyle*)style;
+ (void)removeStyleByTag:(NSString*)tag;
+ (instancetype)styleWithTag:(NSString*)tag;

@end
