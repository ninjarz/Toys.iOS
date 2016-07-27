//
//  MagicTextViewController.m
//  Toys
//
//  Created by linzisheng on 16/7/25.
//
//

#import "MagicTextViewController.h"
#import "MagicTextView.h"
#import "MagicTextStyle.h"


@interface MagicTextViewController() <MagicTextDelegate>
{
    IBOutlet UIView *mMagicView;
    
    MagicTextView *magicTextView;
}

@end

@interface MagicTextViewController ()

@end

@implementation MagicTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // global setting
    MagicTextStyle *style;
    
    style = [[MagicTextStyle alloc] initWithTag:@"a"];
    style.isClickable = YES;
    [MagicTextStyle addStyle:style];
    
    style = [[MagicTextStyle alloc] initWithTag:@"p"];
    style.font = [UIFont fontWithName:@"Avenir-Black" size:14];
    style.foregroundColor = [UIColor colorWithRed:0.51 green:0.58 blue:0.54 alpha:1.000];
    [MagicTextStyle addStyle:style];
    
    style = [[MagicTextStyle alloc] initWithTag:@"text_review"];
    style.foregroundColor = [UIColor colorWithRed:0.401 green:0.408 blue:0.754 alpha:1.000];
    [MagicTextStyle addStyle:style];
    
    style = [[MagicTextStyle alloc] initWithTag:@"test"];
    style.font = [UIFont fontWithName:@"Avenir-Black" size:20];
    style.backgroundColor = [UIColor colorWithRed:0.751 green:0.758 blue:0.694 alpha:1.000];
    [MagicTextStyle addStyle:style];
    
    style = [[MagicTextStyle alloc] initWithTag:@"center"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [style addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    [MagicTextStyle addStyle:style];
    
    style = [[MagicTextStyle alloc] initWithTag:@"right"];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setAlignment:NSTextAlignmentRight];
    [style addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle1}];
    [MagicTextStyle addStyle:style];
    
    style = [[MagicTextStyle alloc] initWithTag:@"s"];
    style.font =  [UIFont fontWithName:@"Avenir-Black" size:13.0];
    [MagicTextStyle addStyle:style];
    
    // Test!
    style = [[MagicTextStyle alloc] initWithTag:@"z"];
    style.font = [UIFont fontWithName:@"Avenir-Black" size:13.0];
    [style setBackgroundColor:[UIColor colorWithRed:0.3 green:0.2 blue:0.25 alpha:0.400]];
    [MagicTextStyle addStyle:style];
    
    style = [[MagicTextStyle alloc] initWithTag:@"x"];
    [style addDynamicFont:@{@"italic": @1}];
    [MagicTextStyle addStyle:style];
    
    magicTextView = [[MagicTextView alloc] initWithFrame:mMagicView.bounds];
    magicTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    magicTextView.backgroundColor = [UIColor colorWithRed:0.9 green:0.89 blue:0.84 alpha:1.000];
    magicTextView.delegate = self;
    //magicTextView.text = @"<p><a>My</a><s> </s><test><s> </s><a><word>childhood</word></a> <a>was</a><s> </s></test><s> </s><a>a</a> <a>happy</a> <a>and</a> <a>innocent</a> <a>time</a> - <a>I</a> <a>was</a> <a>lucky</a></p>";
    
    //magicTextView.text = @"<a><z>You should regist__ on this <x>page first, </x>then you can use </z>\n<z>this APP</z></a>";
    magicTextView.text = @"<a><z>You should regist__ on this <x>page first, </x>then you can use this APP</z></a>";
    [mMagicView addSubview:magicTextView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - MagicTextDelegate

- (void)componentDidTouchDown:(nullable MagicTextComponent*)component
{
    sleep(0);
}

- (void)componentDidTouchUpInside:(nullable MagicTextComponent*)component
{
    sleep(0);
}

- (void)componentDidTouchUpOutside:(nullable MagicTextComponent*)component
{
    sleep(0);
}

@end
