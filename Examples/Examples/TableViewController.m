//
//  TableViewController.m
//  Examples
//
//  Created by Ben Guo on 11/11/14.
//  Copyright (c) 2014 Project Florida. All rights reserved.
//

#import "TableViewController.h"
#import "BarChartViewController.h"
#import "LineChartViewController.h"
#import "ScatterChartViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Charts";
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"CHBarChartView";
            break;
        case 1:
            cell.textLabel.text = @"CHLineChartView";
            break;
        case 2:
            cell.textLabel.text = @"CHScatterChartView";
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            BarChartViewController *vc = [[BarChartViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            LineChartViewController *vc = [[LineChartViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: {
            ScatterChartViewController *vc = [[ScatterChartViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
