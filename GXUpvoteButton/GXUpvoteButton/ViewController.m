//
//  ViewController.m
//  GXUpvoteButton
//
//  Created by apple on 2017/12/19.
//  Copyright © 2017年 getElementByYou. All rights reserved.
//

#import "ViewController.h"
#import "GXUpvoteButton.h"
@interface ViewController ()
@property (nonatomic, strong) GXUpvoteButton *upvoteButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.upvoteButton = [GXUpvoteButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.upvoteButton];
    self.upvoteButton.frame = CGRectMake(0, 0, 50, 50);
    self.upvoteButton.center = self.view.center;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
