//
//  MagicTextView.m
//  Toys
//
//  Created by linzisheng on 16/1/26.
//
//
//----------------------------------------------------------------------------------------------------
// <br>
// <a>
//----------------------------------------------------------------------------------------------------

#import "MagicTextView.h"
#import "MagicTextComponent.h"

@interface MagicTextButton : UIButton
@property NSInteger index;
@property NSString *data;
@end

@implementation MagicTextButton
@end

@interface MagicTextView()
{
    UITextView *mTextView;
    
    BOOL mIsTextDirty;
    NSString *mText;
    NSString *mPlainText;
    NSInteger mSelected;
    NSMutableArray *mComponents;
}

@end

@implementation MagicTextView

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
    
    mTextView = [[UITextView alloc] initWithFrame:self.bounds];
    [mTextView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    //[mTextView setContentInset:UIEdgeInsetsMake(-8, -5, -8, -5)];
    [mTextView setTextContainerInset:UIEdgeInsetsMake(0, -5, 0, -5)];
    [mTextView setEditable:NO];
    [mTextView setSelectable:NO];
    [mTextView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:mTextView];
    
    mIsTextDirty = NO;
    mSelected = -1;
    mComponents = [NSMutableArray array];
}

// text -> plainText + components
- (void)parse
{
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
}

- (void)drawRect:(CGRect)rect
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:mPlainText];
    
    // render text
    for (NSInteger i = 0; i < [mComponents count]; ++i)
    {
        MagicTextComponent *component = [mComponents objectAtIndex:i];
        
        [attributedString addAttributes:component.style.attributes range:NSMakeRange(component.position, component.text.length)];
        
        if (mSelected == i)
        {
            
        }
    }
    [mTextView setAttributedText:attributedString];
    
    //clear and create buttons
    if (mIsTextDirty)
    {
        for (id button in [self subviews])
        {
            if ([button isKindOfClass:[MagicTextButton class]])
            {
                [button removeFromSuperview];
            }
        }

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,self.frame.size.height);
        CGContextConcatCTM(context, flipVertical);
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, nil, mTextView.bounds);
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), path, NULL);
        
        for (NSInteger i = 0; i < [mComponents count]; ++i)
        {
            MagicTextComponent *component = [mComponents objectAtIndex:i];
            if (component.style.isClickable)
            {
                float height = 0.f;
                CFArrayRef lines = CTFrameGetLines(frame);
                for (CFIndex i = 0; i < CFArrayGetCount(lines); ++i)
                {
                    CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, i);
                    
                    CGFloat ascent = 0.f;
                    CGFloat descent = 0.f;
                    CGFloat leading = 0.f;
                    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
                    CFRange lineRange = CTLineGetStringRange(line);
                    CGPoint origin;
                    CTFrameGetLineOrigins(frame, CFRangeMake(i, 1), &origin);
                    
                    if ( (component.position < lineRange.location && component.position+component.text.length>(u_int16_t)(lineRange.location)) || (component.position>=lineRange.location && component.position<lineRange.location+lineRange.length))
                    {
                        CGFloat secondaryOffset;
                        CGFloat begin = CTLineGetOffsetForStringIndex(line, component.position, &secondaryOffset);
                        CGFloat end = CTLineGetOffsetForStringIndex(line, component.position + component.text.length, NULL);
                        CGFloat width = end - begin;
                        
                        MagicTextButton *button = [[MagicTextButton alloc] initWithFrame:CGRectMake(begin + origin.x, height, width, ascent + descent)];
                        [button setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
                        [button setIndex:i];
                        [button setData:component.text];
                        [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        [self addSubview:button];
                    }

                    height = self.frame.size.height - origin.y + descent + 3; // Todo: +3
                }
            }
        }
        
        mIsTextDirty = NO;
    }
    
    /*
    CTFrameDraw(frame, context);
    */
}

#pragma mark - setter

- (void)setText:(NSString*)text
{
    mText = text;
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

- (void)onButtonClicked:(id)sender
{
    MagicTextButton *button = (MagicTextButton*)sender;
    mSelected = button.index;
    
    // Todo: 添加回调
    NSLog(@"%@", button.data);
    
    [self setNeedsDisplay];
}

@end
