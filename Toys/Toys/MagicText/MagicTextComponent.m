//
//  MagicTextComponent.m
//  Toys
//
//  Created by linzisheng on 16/1/26.
//
//

#import "MagicTextComponent.h"


@interface MagicTextComponent()
{
    NSInteger mPosition;
    NSString *mTag;
    MagicTextStyle *mStyle;
    NSString *mText;
}

@end

@implementation MagicTextComponent

@synthesize position = mPosition;
@synthesize tag = mTag;
@synthesize style = mStyle;
@synthesize text = mText;

- (instancetype)initWithTag:(NSString*)tag attributes:(NSDictionary*)attributes text:(NSString*)text
{
    if (self = [super init])
    {
        self.tag = tag;
        self.style = [MagicTextStyle styleWithTag:tag];
        // Todo: deal with attributes
        self.text = text;
    }
    
    return self;
}

+ (instancetype)componentWithTag:(NSString*)tag attributes:(NSDictionary*)attributes text:(NSString*)text
{
    return [[self alloc] initWithTag:tag attributes:attributes text:text];
}

@end
