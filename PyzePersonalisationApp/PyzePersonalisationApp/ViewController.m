

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[self.viewControllers objectAtIndex:0] setTitle: @"Blog"];
    [[self.viewControllers objectAtIndex:1] setTitle: @"Travel"];
    [[self.viewControllers objectAtIndex:2] setTitle: @"E-commerce"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
