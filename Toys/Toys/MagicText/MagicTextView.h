//
//  MagicTextView.h
//  Toys
//
//  Created by linzisheng on 16/1/26.
//
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface MagicTextView : UIView

@property(nonatomic) NSString *text;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)parse;

@end
