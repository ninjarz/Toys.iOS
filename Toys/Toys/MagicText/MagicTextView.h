//
//  MagicTextView.h
//  Toys
//
//  Created by linzisheng on 16/1/26.
//
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "MagicTextComponent.h"

@protocol MagicTextDelegate <NSObject>
@optional

- (void)componentDidTouchDown:(nullable MagicTextComponent*)component;
- (void)componentDidTouchUpInside:(nullable MagicTextComponent*)component;
- (void)componentDidTouchUpOutside:(nullable MagicTextComponent*)component;

@end


@interface MagicTextView : UIView

@property(nonatomic, nullable) NSString *text;
@property(nonatomic) CGSize textSize;
@property(assign, nullable) id<MagicTextDelegate> delegate;

- (nonnull instancetype)initWithFrame:(CGRect)frame;
- (void)parse;

@end

