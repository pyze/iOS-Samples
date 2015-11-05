//
//  DetailEventViewController.m
//  Pyze
//
//  Created by Ramachandra Naragund on 08/10/15.
//  Copyright © 2015 Pyze Technologies Pvt Ltd. All rights reserved.
//

#import "DetailEventViewController.h"
#import "PyzeTableViewSrc.h"
#import "ALEventsTest.h"

#import "EventValuesTableViewController.h"

@interface DetailEventViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray * menuItems;
@property (nonatomic,strong) EventValuesTableViewController * resultVC;
@property (assign) NSInteger section;
@end

@implementation DetailEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    PyzeTableViewSrc * src = [self.menuItems objectAtIndex:self.section];
    
    self.navigationItem.title = src.title;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setModelData:(NSArray *) modelData withRow:(NSInteger) row{
	
    if (_menuItems != modelData) {
        self.menuItems = modelData;
        self.section = row;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier compare:@"eventvalue"] == NSOrderedSame) {
        self.resultVC = [segue destinationViewController];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    PyzeTableViewSrc * src = [self.menuItems objectAtIndex:self.section];
    UILabel *lblName = (UILabel *)[cell viewWithTag:100];
    NSString * string = [src.items objectAtIndex:indexPath.row];
    NSArray * array = [string componentsSeparatedByString:@":"];
    
    string = [array componentsJoinedByString:@" :\n"];
    NSRange newLine = [string rangeOfString:@"\n" options:NSBackwardsSearch];
    
    if(newLine.location != NSNotFound) {
        string = [string stringByReplacingCharactersInRange:newLine
                                           withString: @""];
    }

    [lblName setText:string];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //minimum size of your cell, it should be single line of label if you are not clear min. then return UITableViewAutomaticDimension;
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PyzeTableViewSrc * src = [self.menuItems objectAtIndex:self.section];
    return src.items.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath * indexPathToPerform = [NSIndexPath indexPathForRow:indexPath.row inSection:self.section];
    [ALEventsTest executeTestEventsInBackgroundWithIndexPath:indexPathToPerform shouldExecute:NO withCompletionHandler:^(NSArray *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            PyzeTableViewSrc * src = [self.menuItems objectAtIndex:self.section];
            NSString * methodName = [src.items objectAtIndex:indexPath.row];
            [self.resultVC setModelData:result forMethodName:methodName withIndexPath:indexPathToPerform];
        });
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

@end
