//
//  MagicTextComponent.h
//  Toys
//
//  Created by linzisheng on 16/1/26.
//
//

#import <Foundation/Foundation.h>
#import "MagicTextStyle.h"


@interface MagicTextComponent : NSObject

@property NSInteger position;
@property(copy) NSString *tag;
@property MagicTextStyle *style;
@property(copy) NSString *text;

- (instancetype)initWithTag:(NSString*)tag attributes:(NSDictionary*)attributes text:(NSString*)text;

+ (instancetype)componentWithTag:(NSString*)tag attributes:(NSDictionary*)attributes text:(NSString*)text;

@end
