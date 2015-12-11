//
//  ViewController.m
//  PyzeViewController
//
//  Created by Ramachandra Naragund on 17/11/15.
//  Copyright © 2015 Pyze Technologies Pvt Ltd. All rights reserved.
//

#import "ViewController.h"
#import "PyzeCollectionViewController.h"
#import "SegementDemoViewController.h"
#import "SearchTableViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[@"CollectionViewController",@"SegmentControl",@"SearchBar"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UILabel *lblName = (UILabel *)[cell viewWithTag:100];
    [lblName setText:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == 0) {
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PyzeCollectionViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"collectionViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1) {
        SegementDemoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"segment"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 2) {
        SearchTableViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
