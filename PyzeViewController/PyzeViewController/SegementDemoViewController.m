//
//  SegementDemoViewController.m
//  PyzeViewController
//
//  Created by Ramachandra Naragund on 03/12/15.
//  Copyright © 2015 Pyze Technologies Pvt Ltd. All rights reserved.
//

#import "SegementDemoViewController.h"

@interface SegementDemoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation SegementDemoViewController

- (IBAction)didTapSegment:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    if (UISegmentedControlNoSegment != index){
        self.label.text = [NSString stringWithFormat:@"Segment Click %@", [sender titleForSegmentAtIndex:index]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.text =[NSString stringWithFormat:@"Segment Click %@", [self.segmentControl titleForSegmentAtIndex:0]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
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
