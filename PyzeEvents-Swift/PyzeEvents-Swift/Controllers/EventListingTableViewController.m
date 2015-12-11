//
//  EventListingTableViewController.m
//  PyzeEvents-Swift
//
//  Created by Ramachandra Naragund on 11/12/15.
//  Copyright © 2015 Pyze. All rights reserved.
//

#import "EventListingTableViewController.h"
#import "ALEventsTest.h"

@interface EventListingTableViewController ()
@property (nonatomic,strong) NSArray * firstGroupItemArray;
@property (nonatomic,strong) NSDictionary * secondGroupItemArray;
//@property (nonatomic,strong) NSIndexPath * indexpath;
//@property (nonatomic,strong) NSString * methodName;
@end

@implementation EventListingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstGroupItemArray = [self.modelData objectAtIndex:0];
    self.secondGroupItemArray= [self.modelData objectAtIndex:1];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post Event"
                                                                              style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)done:(id)sender {
    
    [ALEventsTest executeTestEventsInBackgroundWithIndexPath:self.indexpath shouldExecute:YES withCompletionHandler:^(NSArray *result) {
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
                if (methodCmpnts && methodCmpnts.count) {
                    [lblName setText:[NSString stringWithFormat:@"%@ : %@",[methodCmpnts objectAtIndex:indexPath.row], object]];
                }
            }
        }
    }
    
    return cell;
}


-(instancetype)initWithModelData:(NSArray *) modelData
      forMethodName:(NSString *) methodName
      withIndexPath:(NSIndexPath *) indexPath
{
    if (modelData != nil) {
        self.indexpath = indexPath;
        self.methodName = methodName;
        [self.tableView reloadData];
    }
    return self;
}

-(NSArray *) methodComponets
{
    if (self.methodName && self.methodName.length)
        return[self.methodName componentsSeparatedByString:@":"];
    return nil;
}
@end
