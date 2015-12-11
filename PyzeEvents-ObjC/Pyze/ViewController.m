//
//  ViewController.m
//  Pyze
//
//  Created by Ramachandra Naragund on 01/10/15.
//  Copyright © 2015 Pyze Technologies Pvt Ltd. All rights reserved.
//

#import "ViewController.h"

#import "PyzeClassParser.h"

#import "PyzeTableViewSrc.h"

#import "ALEventsTest.h"

#import "DetailEventViewController.h"

@interface ViewController () <PyzeClassParserDelegate>
@property (strong, nonatomic) NSArray *menuItems;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    PyzeClassParser * parser = [[PyzeClassParser alloc] initWithDelegate:self];
    NSLog(@"parser %@",parser);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) didParserCompleteParsing:(NSArray *)menuItems
{
    self.menuItems = menuItems;
    [self.tableView reloadData];
}

-(NSArray *)menuItems {
    if (_menuItems == nil) {
    }
    return _menuItems;
}


-(NSString *)sectionHeaderNibName {
    return @"MenuSectionHeaderView";
}

-(NSArray *)model {
    return self.menuItems;
}

-(UITableView *)collapsableTableView {
    return self.tableView;
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
     
     DetailEventViewController * vController = [segue destinationViewController];
     
     [vController setModelData:self.menuItems withRow:[self.tableView indexPathForSelectedRow].row];
     
 // Pass the selected object to the new view controller.
 }
 

#pragma mark - UITableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    PyzeTableViewSrc * src = [self.menuItems objectAtIndex:indexPath.row];
    UILabel *lblName = (UILabel *)[cell viewWithTag:100];
    [lblName setText:src.title];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //minimum size of your cell, it should be single line of label if you are not clear min. then return UITableViewAutomaticDimension;
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self model].count;
}


@end
