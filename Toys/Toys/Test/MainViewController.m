//
//  MainViewController.m
//  Toys
//
//  Created by linzisheng on 16/7/25.
//
//

#import "MainViewController.h"
#import "MagicTextViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)magicTextButtonClicked:(id)sender
{
    MagicTextViewController *viewManager = [[MagicTextViewController alloc] init];
    [self.navigationController pushViewController:viewManager animated:YES];
}

@end
