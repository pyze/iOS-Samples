//
//  ViewController.m
//  NSURLSessionExample
//
//  Created by Ramachandra Naragund on 07/08/15.
//  Copyright (c) 2015 Robosoft Technologies Pvt Ltd. All rights reserved.
//

#import "ViewController.h"
#import "TopAppsManager.h"
#import "AppStoreDataModel.h"

#import "AppStatusCell.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * appsArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 66, 0);
    TopAppsManager * manager = [TopAppsManager sharedAppsManager];
    [manager getTopPaidAppsFromiTunesWithCompletionBlock:^(NSError *error, NSArray *dataRecords) {
        if (!error) {
            self.appsArray = dataRecords;
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    self.tableView.tableFooterView = [UIView new];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.appsArray = nil;
}


#pragma mark - TableView data source and delegate methods.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.appsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    AppStatusCell *appCell = [tableView dequeueReusableCellWithIdentifier:@"appName"];
    [appCell constructAppStoreDetails:self.appsArray[indexPath.row]];
    cell = appCell;
    return cell;
}


@end
