//
//  ViewController.m
//  Toys
//
//  Created by linzisheng on 16/1/13.
//
//

#import "ViewController.h"
#import "MagicTextView.h"
#import "MagicTextStyle.h"


@interface ViewController() <MagicTextDelegate>
{
    IBOutlet UIView *mMagicView;
}

@end

@implementation ViewController

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
    
    style = [[MagicTextStyle alloc] initWithTag:@"word"];
    style.foregroundColor = [UIColor colorWithRed:0.401 green:0.408 blue:0.754 alpha:1.000];
    [MagicTextStyle addStyle:style];
    
    style = [[MagicTextStyle alloc] initWithTag:@"test"];
    style.font = [UIFont fontWithName:@"Avenir-Black" size:20];
    style.backgroundColor = [UIColor colorWithRed:0.751 green:0.758 blue:0.694 alpha:1.000];
    [MagicTextStyle addStyle:style];
    
    style = [[MagicTextStyle alloc] initWithTag:@"s"];
    style.font = [UIFont fontWithName:@"Avenir-Black" size:7];
    [MagicTextStyle addStyle:style];
    
    
    MagicTextView *magicTextView = [[MagicTextView alloc] initWithFrame:mMagicView.bounds];
    magicTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    magicTextView.backgroundColor = [UIColor colorWithRed:0.9 green:0.89 blue:0.84 alpha:1.000];
    magicTextView.delegate = self;
    magicTextView.text = @"<p><a>My</a><s> </s><test><s> </s><a><word>childhood</word></a> <a>was</a><s> </s></test><s> </s><a>a</a> <a>happy</a> <a>and</a> <a>innocent</a> <a>time</a> - <a>I</a> <a>was</a> <a>lucky</a></p>";
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
