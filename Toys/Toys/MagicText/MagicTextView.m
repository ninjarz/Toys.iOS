//
//  MagicTextView.m
//  Toys
//
//  Created by linzisheng on 16/1/26.
//
//
//----------------------------------------------------------------------------------------------------
// <br>
//
//----------------------------------------------------------------------------------------------------

#import "MagicTextView.h"


@interface MagicTextButton : UIButton

@property NSInteger index;
@property NSString *data;

@end

@implementation MagicTextButton

@synthesize index;
@synthesize data;

@end


@interface MagicTextView()
{
    BOOL mIsTextDirty;
    NSString *mText;
    NSString *mPlainText;
    NSInteger mSelected;
    NSMutableArray *mComponents;
    NSMutableAttributedString *mAttributedText;
}

@end

@implementation MagicTextView

@synthesize textSize = mTextSize;
@synthesize delegate;

- (instancetype)init
{
    if (self =[super init])
    {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame;
{
    if (self = [super initWithFrame:frame])
    {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    mIsTextDirty = NO;
    mSelected = -1;
    mComponents = [NSMutableArray array];
}

// text -> plainText + components -> attributedText
- (void)parse
{
    [mComponents removeAllObjects];
    NSString *text = [mText stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    
    NSUInteger lastPos = 0;
    NSScanner *scanner = [NSScanner scannerWithString:text];
    while (![scanner isAtEnd])
    {
        NSString *delimiter = nil;
        [scanner scanUpToString:@"<" intoString:NULL];
        [scanner scanUpToString:@">" intoString:&delimiter];
        delimiter = [NSString stringWithFormat:@"%@>", delimiter];
        
        NSUInteger position = [text rangeOfString:delimiter].location;
        if (position != NSNotFound)
        {
            text = [text stringByReplacingOccurrencesOfString:delimiter withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(lastPos, position + delimiter.length - lastPos)];
        }
        else
        {
            break;
        }
        
        if ([delimiter rangeOfString:@"</"].location == 0)
        {
            NSString *tag = [delimiter substringWithRange:NSMakeRange(2, delimiter.length - 3)];
            for (int i = (int)[mComponents count] - 1; i >= 0; --i)
            {
                MagicTextComponent *component = [mComponents objectAtIndex:i];
                if (component.text == nil && [component.tag isEqualToString:tag])
                {
                    component.text = [text substringWithRange:NSMakeRange(component.position, position - component.position)];
                    break;
                }
            }
        }
        else // Todo: use FSA
        {
            NSArray *tagComponents = [[delimiter substringWithRange:NSMakeRange(1, delimiter.length - 2)] componentsSeparatedByString:@" "];
            NSString *tag = [tagComponents objectAtIndex:0];
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            
            for (NSUInteger i = 1; i < [tagComponents count]; ++i)
            {
                NSArray *pair = [[tagComponents objectAtIndex:i] componentsSeparatedByString:@"="];
                NSString *key = [[pair objectAtIndex:0] lowercaseString];
                
                if ([pair count] == 2)
                {
                    NSString *value = [[pair objectAtIndex:1] lowercaseString];
                    value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, 1)];
                    value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSLiteralSearch range:NSMakeRange([value length] - 1, 1)];
                    [attributes setObject:value forKey:key];
                }
                else
                {
                    [attributes setObject:key forKey:key];
                }
            }
            
            MagicTextComponent *component = [MagicTextComponent componentWithTag:tag attributes:attributes text:nil];
            component.position = position;
            [mComponents addObject:component];
        }
        
        lastPos = position;
    }
    mPlainText = text;
    
    if ([mPlainText length])
    {
        [self generateMutableAttributedString];
        CGRect rect = self.bounds;
        rect.size.width -= 10;
        mTextSize = [mAttributedText boundingRectWithSize:CGSizeMake(rect.size.width, 9999) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    }
}


- (void)generateMutableAttributedString
{
    // render text
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:mPlainText];
    for (NSInteger i = 0; i < [mComponents count]; ++i)
    {
        MagicTextComponent *component = [mComponents objectAtIndex:i];
        if ([component.text length])
        {
            [attributedString addAttributes:component.style.attributes range:NSMakeRange(component.position, component.text.length)];
            if ([component.style.dynamicFont objectForKey:@"face"] && [component.style.dynamicFont objectForKey:@"size"])
            {
                NSString *face = [component.style.dynamicFont objectForKey:@"face"];
                UIFont *font = [UIFont fontWithName:face size:[[component.style.dynamicFont objectForKey:@"size"] intValue]];
                CTFontRef customFont = CTFontCreateWithName((__bridge CFStringRef)[font fontName], [font pointSize], NULL);
                CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attributedString, CFRangeMake(component.position, component.text.length), kCTFontAttributeName, customFont);
                CFRelease(customFont);
            }
            else if ([component.style.dynamicFont objectForKey:@"size"])
            {
                CFTypeRef actualFontRef = CFAttributedStringGetAttribute((CFAttributedStringRef)attributedString, component.position, kCTFontAttributeName, nil);
                CTFontRef fontRef = CTFontCreateCopyWithSymbolicTraits(actualFontRef, [[component.style.dynamicFont objectForKey:@"size"] intValue], nil, 0, 0);
                if (fontRef)
                {
                    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attributedString, CFRangeMake(component.position, component.text.length), kCTFontAttributeName, fontRef);
                    CFRelease(fontRef);
                }
                else
                {
                    UIFont *systemFont = [UIFont systemFontOfSize:[[component.style.dynamicFont objectForKey:@"size"] intValue]];
                    fontRef = CTFontCreateWithName((__bridge CFStringRef)[systemFont fontName], [systemFont pointSize], NULL);
                    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attributedString, CFRangeMake(component.position, component.text.length), kCTFontAttributeName, fontRef);
                    CFRelease(fontRef);
                }
            }
            if ([component.style.dynamicFont objectForKey:@"bold"])
            {
                CFTypeRef actualFontRef = CFAttributedStringGetAttribute((CFAttributedStringRef)attributedString, component.position, kCTFontAttributeName, nil);
                CTFontRef boldFontRef = CTFontCreateCopyWithSymbolicTraits(actualFontRef, 0.0, nil, kCTFontBoldTrait, kCTFontBoldTrait);
                if (boldFontRef)
                {
                    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attributedString, CFRangeMake(component.position, component.text.length), kCTFontAttributeName, boldFontRef);
                    CFRelease(boldFontRef);
                }
            }
            if ([component.style.dynamicFont objectForKey:@"italic"])
            {
                CFTypeRef actualFontRef = CFAttributedStringGetAttribute((CFAttributedStringRef)attributedString, component.position, kCTFontAttributeName, nil);
                CTFontRef italicFontRef = CTFontCreateCopyWithSymbolicTraits(actualFontRef, 0.0, nil, kCTFontItalicTrait, kCTFontItalicTrait);
                if (italicFontRef)
                {
                    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attributedString, CFRangeMake(component.position, component.text.length), kCTFontAttributeName, italicFontRef);
                    CFRelease(italicFontRef);
                }
            }
        }
    }
    
    mAttributedText = attributedString;
}

- (void)drawRect:(CGRect)rect
{
    if (!mAttributedText)
    {
        return;
    }
    
    // clear and create buttons
    if (mIsTextDirty)
    {
        for (id button in [self subviews])
        {
            if ([button isKindOfClass:[MagicTextButton class]])
            {
                [button removeFromSuperview];
            }
        }
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mAttributedText);
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect realRect = self.bounds;
    realRect.size.width -= 10;
    CGPathAddRect(path, nil, realRect);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil);
    
    for (NSInteger i = 0; i < [mComponents count]; ++i)
    {
        MagicTextComponent *component = [mComponents objectAtIndex:i];
        if ((mIsTextDirty && component.style.isClickable) || component.style.backgroundColor)
        {
            float height = 0.f;
            CFArrayRef lines = CTFrameGetLines(frame);
            for (CFIndex j = 0; j < CFArrayGetCount(lines); ++j)
            {
                CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, j);
                
                CGFloat ascent = 0.f;
                CGFloat descent = 0.f;
                CGFloat leading = 0.f;
                CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
                CFRange lineRange = CTLineGetStringRange(line);
                CGPoint origin;
                CTFrameGetLineOrigins(frame, CFRangeMake(j, 1), &origin);
                
                if ((component.position < lineRange.location && component.position+component.text.length>(u_int16_t)(lineRange.location)) || (component.position>=lineRange.location && component.position<lineRange.location+lineRange.length))
                {
                    CGFloat secondaryOffset;
                    CGFloat begin = CTLineGetOffsetForStringIndex(line, component.position, &secondaryOffset);
                    CGFloat end = CTLineGetOffsetForStringIndex(line, component.position + component.text.length, NULL);
                    CGFloat width = end - begin;
                    
                    if (mIsTextDirty && component.style.isClickable)
                    {
                        MagicTextButton *button = [[MagicTextButton alloc] initWithFrame:CGRectMake(begin + origin.x + 5, height + 8, width, ascent + descent)]; // Todo: 添加button的关联性
                        [button setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
                        [button setIndex:i];
                        [button setData:component.text];
                        [button addTarget:self action:@selector(onButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
                        [button addTarget:self action:@selector(onButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
                        [button addTarget:self action:@selector(onButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
                        [button addTarget:self action:@selector(onButtonTouchDrag:withEvent:) forControlEvents:UIControlEventTouchDragInside];
                        [button addTarget:self action:@selector(onButtonTouchDrag:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
                        [self addSubview:button];
                    }
                    if (component.style.backgroundColor)
                    {
                        CGRect rectangle = CGRectMake(begin + origin.x + 5, height + 8, width, ascent + descent);
                        CGContextSetFillColorWithColor(context, component.style.backgroundColor.CGColor);
                        CGContextFillRect(context , rectangle);
                    }
                }
                
                height = self.frame.size.height - origin.y + descent;
            }
        }
        if (mSelected == i)
        {
            //[mAttributedText addAttributes:@{NSBackgroundColorAttributeName : [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:0.4]} range:NSMakeRange(component.position, component.text.length)];
        }
    }
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, self.frame.size.height);
    CGContextConcatCTM(context, flipVertical);
    CGContextTranslateCTM(context, 5, -8);
    CTFrameDraw(frame, context);
    CFRelease(path);
    CFRelease(framesetter);
    CFRelease(frame);
    mIsTextDirty = NO;
}

#pragma mark - setter

- (void)setText:(NSString*)text
{
    mText = text;
    mSelected = -1;
    mIsTextDirty = YES;
    [self parse];
    [self setNeedsDisplay];
}

#pragma mark - getter

- (NSString*)text
{
    return mText;
}

#pragma mark - click

- (void)onButtonTouchDown:(id)sender
{
    MagicTextButton *button = (MagicTextButton*)sender;
    [button setBackgroundColor:[UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:0.4]];
    mSelected = button.index;
    
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(componentDidTouchDown:)])
        {
            [self.delegate componentDidTouchDown:[mComponents objectAtIndex:button.index]];
        }
    }
    
    //NSLog(@"%s:%@", __FUNCTION__, button.data);
    [self setNeedsDisplay];
}

- (void)onButtonTouchUpInside:(id)sender
{
    MagicTextButton *button = (MagicTextButton*)sender;
    [button setBackgroundColor:[UIColor clearColor]];
    mSelected = -1;
    
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(componentDidTouchUpInside:)])
        {
            [self.delegate componentDidTouchUpInside:[mComponents objectAtIndex:button.index]];
        }
    }
    
    //NSLog(@"%s:%@", __FUNCTION__, button.data);
    [self setNeedsDisplay];
}

- (void)onButtonTouchUpOutside:(id)sender
{
    MagicTextButton *button = (MagicTextButton*)sender;
    [button setBackgroundColor:[UIColor clearColor]];
    mSelected = -1;
    
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(componentDidTouchUpOutside:)])
        {
            [self.delegate componentDidTouchUpOutside:[mComponents objectAtIndex:button.index]];
        }
    }
    
    //NSLog(@"%s:%@", __FUNCTION__, button.data);
    [self setNeedsDisplay];
}

- (void)onButtonTouchDrag:(UIButton*)sender withEvent:(UIEvent *)event // Todo: delegate
{
    UITouch *touch = [[event allTouches] anyObject];
    CGFloat boundsExtension = 5.0f;
    CGRect outerBounds = CGRectInset(sender.bounds, -1 * boundsExtension, -1 * boundsExtension);
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:sender]);
    if (touchOutside)
    {
        // Outside
        MagicTextButton *button = (MagicTextButton*)sender;
        [button setBackgroundColor:[UIColor clearColor]];
        mSelected = -1;
        
        //NSLog(@"%s:%@", __FUNCTION__, button.data);
        [self setNeedsDisplay];
    }
    else
    {
        // Inside
    }
}

@end
