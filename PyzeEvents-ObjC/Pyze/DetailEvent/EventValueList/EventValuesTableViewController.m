//
//  EventValuesTableViewController.m
//  Pyze
//
//  Created by Ramachandra Naragund on 14/10/15.
//  Copyright © 2015 Pyze Technologies Pvt Ltd. All rights reserved.
//

#import "EventValuesTableViewController.h"
#import "ALEventsTest.h"

@interface EventValuesTableViewController ()
@property (nonatomic,strong) NSArray * firstGroupItemArray;
@property (nonatomic,strong) NSDictionary * secondGroupItemArray;
@property (nonatomic,strong) NSIndexPath * indexpath;
@property (nonatomic,strong) NSString * methodName;
@end

@implementation EventValuesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post Event"
                                                                              style:UIBarButtonItemStylePlain target:self action:@selector(done:)];

}
- (IBAction)done:(id)sender {

    [ALEventsTest executeTestEventsInBackgroundWithIndexPath:self.indexpath shouldExecute:YES withCompletionHandler:^(NSArray *result) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray * ar = [self methodComponets];
    if (ar && ar.count >= 2)
        return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return self.firstGroupItemArray.count;
    return  self.secondGroupItemArray.count;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section) {
        return @"Attributes";
    }
    NSArray * ar = [self methodComponets];
    return (ar && ar.count > 2  ) ? @"Method Arguments" : self.methodName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (self.firstGroupItemArray && self.secondGroupItemArray) {
        if (indexPath.section) {
            NSString * key = [[self.secondGroupItemArray allKeys] objectAtIndex:indexPath.row];
            id value = [self.secondGroupItemArray objectForKey:key];
            if (value == [NSNull null]) value = @"0";
            if ([value isKindOfClass:[NSArray class]])
                value = [value componentsJoinedByString:@","];
            UILabel *lblName = (UILabel *)[cell viewWithTag:100];
            [lblName setText:[NSString stringWithFormat:@"%@ : %@", key, value]];
        }
        else {
            UILabel *lblName = (UILabel *)[cell viewWithTag:100];
            id object = [self.firstGroupItemArray objectAtIndex:indexPath.row];
            if (![object isKindOfClass:[NSDictionary class]] || ![object isKindOfClass:[NSArray class]]) {
                NSArray * methodCmpnts = [self methodComponets];
                if (methodCmpnts && methodCmpnts.count && methodCmpnts.count > 2 ) {
                    [lblName setText:[NSString stringWithFormat:@"%@ : %@",[methodCmpnts objectAtIndex:indexPath.row], object]];
                }
                else {
                    [lblName setText:[NSString stringWithFormat:@"%@", object]];
                }
            }
        }
    }

    return cell;
}

-(void)setModelData:(NSArray *) modelData
      forMethodName:(NSString *) methodName
      withIndexPath:(NSIndexPath *) indexPath
{
    if (modelData != nil) {
        self.firstGroupItemArray = [modelData objectAtIndex:0];
        self.secondGroupItemArray= [modelData objectAtIndex:1];
        self.indexpath = indexPath;
        self.methodName = methodName;
        [self.tableView reloadData];
    }

}

-(NSArray *) methodComponets
{
    if (self.methodName && self.methodName.length)
        return[self.methodName componentsSeparatedByString:@":"];
    return nil;
}
@end
