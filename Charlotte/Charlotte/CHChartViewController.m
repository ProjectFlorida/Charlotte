//
//  CHChartViewController.m
//  Charlotte
//
//  Created by Ben Guo on 10/9/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "CHChartViewController.h"
#import "CHChartView.h"

@interface CHChartViewController ()

@property (strong, nonatomic) CHChartView *chartView;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation CHChartViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    _chartView = [[CHChartView alloc] initWithFrame:CGRectZero];
    _chartView.backgroundColor = [UIColor magentaColor];
    _chartView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.chartView];
    NSDictionary *views = @{@"chartView": self.chartView};
    NSArray *chartViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[chartView]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    NSArray *chartViewV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[chartView]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    [self.view addConstraints:chartViewH];
    [self.view addConstraints:chartViewV];
    [self.view setNeedsLayout];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
