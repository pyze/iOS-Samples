
#import "PABlogContentController.h"
#import "PAFeedManager.h"

@interface PABlogContentController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;


@end

@implementation PABlogContentController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchBlogContent];
}


#pragma mark - Private methods

- (void) fetchBlogContent {
    
    [PAFeedManager fetchBlogContentForId:self.blogItem.blogId
                                 handler:^(NSString *blogList) {

                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         self.contentTextView.text = blogList;
                                         self.imageView.image = [UIImage imageNamed:self.blogItem.imageURL];
                                     });
    }];
    
}
- (IBAction)didTapBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
