
#import "ViewController.h"
#import "CAECommerceShoppingController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *optionView;
@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.optionView.layer.cornerRadius = 5.0;
}

#pragma mark - Action methods

- (IBAction)didTapECommerceShopping:(id)sender {
    CAECommerceShoppingController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CAECommerceShoppingController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)didTapInStoreShopping:(id)sender {
    CAECommerceShoppingController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CAECommerceShoppingController"];
    controller.isInStore = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
