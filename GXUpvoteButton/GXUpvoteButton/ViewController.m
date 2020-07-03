//
//  ViewController.m
//  GXUpvoteButton
//
//  Created by apple on 2017/12/19.
//  Copyright © 2017年 getElementByYou. All rights reserved.
//

#import "ViewController.h"
#import "GXUpvoteButton.h"

@interface GXUpvoteTableViewCell : UITableViewCell<GXUpvoteButtonDelegate>

@property (nonatomic,strong) GXUpvoteButton *upvoteButton;

@end

@implementation GXUpvoteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.upvoteButton = [GXUpvoteButton buttonWithType:UIButtonTypeCustom];
        self.upvoteButton.delegate = self;
        [self.contentView addSubview:self.upvoteButton];
        self.upvoteButton.frame = CGRectMake(0, 0, 50, 50);
    }
    return self;
}

- (void)upvoteBtnTouchUpInsideAction:(UIButton *)sender {
    [self.superview bringSubviewToFront:self];
}

- (void)upvoteBtnLongPressStateBeganAction:(UIButton *)sender {
    [self.superview bringSubviewToFront:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.upvoteButton.center = self.contentView.center;
}

@end


@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) GXUpvoteButton *upvoteButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
//    self.upvoteButton = [GXUpvoteButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:self.upvoteButton];
//    self.upvoteButton.frame = CGRectMake(0, 0, 50, 50);
//    self.upvoteButton.center = self.view.center;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXUpvoteTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[GXUpvoteTableViewCell class] forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
