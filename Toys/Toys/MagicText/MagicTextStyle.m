//
//  MagicTextStyle.m
//  Toys
//
//  Created by linzisheng on 16/1/25.
//
//

#import "MagicTextStyle.h"


@interface MagicTextStyle() <NSMutableCopying>
{
    NSString *mTag;
    NSMutableDictionary *mAttributes;
    BOOL mIsClickable;
}

@end

@implementation MagicTextStyle

@synthesize tag = mTag;
@synthesize attributes = mAttributes;
@synthesize isClickable = mIsClickable;

- (nonnull instancetype)initWithTag:(NSString*)tag;
{
    if (self = [super init])
    {
        mTag = tag;
        mAttributes = [[NSMutableDictionary alloc] init];
        mIsClickable = NO;
    }
    
    return self;
}

#pragma mark - API

- (void)setForegroundColor:(nullable UIColor*)color
{
    [mAttributes setObject:color forKey:NSForegroundColorAttributeName];
}

- (void)setBackgroundColor:(nullable UIColor*)color
{
    [mAttributes setObject:color forKey:NSBackgroundColorAttributeName];
}

- (void)setFont:(nullable UIFont*)font
{
    [mAttributes setValue:font forKey:NSFontAttributeName];
}

#pragma mark - Copying

- (id)mutableCopyWithZone:(nullable NSZone*)zone
{
    MagicTextStyle *copy = [MagicTextStyle allocWithZone:zone];
    copy->mTag = mTag;
    copy->mAttributes = [mAttributes mutableCopy];
    copy->mIsClickable = mIsClickable;
    
    return copy;
}

#pragma mark - static

+ (nonnull NSMutableDictionary*)styles
{
    static NSMutableDictionary *styles = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        styles = [[NSMutableDictionary alloc] init];
        
    });
    
    return styles;
}

+ (void)addStyle:(nonnull MagicTextStyle*)style
{
    NSMutableDictionary *styles = [self styles];
    
    [styles setObject:style forKey:style.tag];
}

+ (void)removeStyleByTag:(nonnull NSString*)tag
{
    NSMutableDictionary *styles = [self styles];
    
    [styles removeObjectForKey:tag];
}

+ (nonnull instancetype)styleWithTag:(nullable NSString*)tag
{
    NSMutableDictionary *styles = [self styles];
    
    MagicTextStyle *style = [styles objectForKey:tag];
    if (!style)
    {
        style = [[MagicTextStyle alloc] initWithTag:tag];
    }
    else
    {
        style = [style mutableCopy];
    }
    
    return style;
}

/*
#pragma mark - deprecated

- (void)addAttributes:(NSDictionary*)attributes
{
    [mAttributes addEntriesFromDictionary:attributes];
}
 */

@end
