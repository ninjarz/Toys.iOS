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

- (instancetype)initWithTag:(NSString*)tag;
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

- (void)setForegroundColor:(UIColor*)color
{
    [mAttributes setObject:color forKey:NSForegroundColorAttributeName];
}

- (void)setBackgroundColor:(UIColor*)color
{
    [mAttributes setObject:color forKey:NSBackgroundColorAttributeName];
}

- (void)setFont:(UIFont*)font
{
    [mAttributes setValue:font forKey:NSFontAttributeName];
}

- (void)setClickable:(BOOL)clickable onClicked:(void (^ __nullable)(void))onClicked
{
    
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

+ (NSMutableDictionary*)styles
{
    static NSMutableDictionary *styles = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        styles = [[NSMutableDictionary alloc] init];
        
    });
    
    return styles;
}

+ (void)addStyle:(MagicTextStyle*)style
{
    NSMutableDictionary *styles = [self styles];
    
    [styles setObject:style forKey:style.tag];
}

+ (void)removeStyleByTag:(NSString*)tag
{
    NSMutableDictionary *styles = [self styles];
    
    [styles removeObjectForKey:tag];
}

+ (instancetype)styleWithTag:(NSString*)tag
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
