#import "CAECommerceShoppingController.h"
#import "CADataManager.h"
#import "CAProductCell.h"
#import "CAInStoreShoppingController.h"

@interface CAECommerceShoppingController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *products;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation CAECommerceShoppingController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.products = [[CADataManager sharedInstance] getProductList];
    
    self.title = (_isInStore) ? @"Items in your cart" : @"View All";
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


#pragma mark - Utility methods

- (void) presentInStoreController {
    if (_isInStore) {
        CAInStoreShoppingController *inStoreController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CAInStoreShoppingController"];
        inStoreController.modalPresentationStyle= UIModalPresentationOverFullScreen;
        [self presentViewController:inStoreController animated:YES completion:nil];
        
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CAProduct *product = self.products[indexPath.row];
    
    CAProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CAProductCell" forIndexPath:indexPath];
    
    cell.nameLabel.text = product.name;
    cell.priceLabel.text = product.price;
    cell.thumbnailView.image = [UIImage imageNamed:product.image];
    
    return cell;
}

#pragma mark - UICollectionViewFlowDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.frame.size.width/2.0)-20.0, 305.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (IBAction)didTapBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self presentInStoreController];
}

@end
