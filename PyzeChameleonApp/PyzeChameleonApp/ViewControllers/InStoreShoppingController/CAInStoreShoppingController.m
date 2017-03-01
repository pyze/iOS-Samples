
#import "CAInStoreShoppingController.h"

@interface CAInStoreShoppingController ()

@end

@implementation CAInStoreShoppingController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.contentView.layer.cornerRadius = 8.0;
    self.okButton.layer.cornerRadius = 4.0;
}

#pragma mark - Action methods

- (IBAction)didTapOK:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Gesture handler

- (void) handleTap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
