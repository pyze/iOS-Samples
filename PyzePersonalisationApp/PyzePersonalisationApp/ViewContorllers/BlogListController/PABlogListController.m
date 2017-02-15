
#import "PABlogListController.h"
#import "PAFeedManager.h"
#import "PABlog.h"
#import "PABlogContentController.h"

@interface PABlogListController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation PABlogListController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = [NSArray array];
    [PAFeedManager fetchBlogList:^(NSArray *blogList) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataSource = blogList;
            [self.blogListTable reloadData];
        });
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PABlog *blog = self.dataSource[indexPath.row];
    
    NSString *blogCellIdentifier = @"blogItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:blogCellIdentifier];
    cell.textLabel.text = blog.title;
    cell.detailTextLabel.text = blog.subTitle;
    [cell.imageView setImage:[UIImage imageNamed:blog.imageURL]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    PABlog *blog = self.dataSource[indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PABlogContentController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PABlogContentController"];
    controller.blogItem = blog;
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
