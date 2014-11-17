//
//  ViewController.m
//  BookClub
//
//  Created by Mobile Making on 11/12/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "PeopleTableTableViewController.h"
#import "ProfileViewController.h"
#import "Friend.h"
#import "AppDelegate.h"

@interface FriendsTableViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property NSManagedObjectContext *moc;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *friends;
@property NSMutableArray *friendNames;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sortButton;
@property (strong, nonatomic) IBOutlet UIToolbar *sortToolbar;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation FriendsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.friends = [NSMutableArray array];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    [self.view addSubview:self.sortToolbar];
    [self.view addSubview:self.searchBar];

    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.sortToolbar.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height - self.sortToolbar.frame.size.height, screenWidth, self.sortToolbar.frame.size.height);
    self.sortToolbar.alpha = 0.0;
    self.searchBar.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height - self.searchBar.frame.size.height, screenWidth, self.sortToolbar.frame.size.height);
    self.searchBar.alpha = 0.0;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self loadMOC];


}

- (void)viewDidLayoutSubviews
{

}

#pragma mark - table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    Friend *myFriend = self.friends[indexPath.row];
    cell.textLabel.text = myFriend.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)myFriend.books.count];

    return cell;
}

#pragma mark - search bar methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{

    return YES;
}

#pragma mark - helper methods

- (void)loadMOC
{

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Friend class])];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortByName];

    self.friends = [[self.moc executeFetchRequest:request error:nil] mutableCopy];

//    NSSortDescriptor *sortByBookCount = [NSSortDescriptor sortDescriptorWithKey:@"books.@count" ascending:NO];
//    [self.friends sortedArrayUsingDescriptors:@[sortByBookCount]];

    [self.tableView reloadData];

}

- (void)updateFriends
{
    // adding friends
    for (NSString *friendName in self.friendNames)
    {
        // check db for the name
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Friend class])];
        request.predicate = [NSPredicate predicateWithFormat:@"%K like %@", @"name", friendName];

        NSError *error;
        NSArray *checkFriends = [self.moc executeFetchRequest:request error:&error];
        Friend *checkFriend = checkFriends.firstObject;

        // if name is not in db add it
        if (checkFriend.name == nil)
        {
            Friend *myFriend = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Friend class]) inManagedObjectContext:self.moc];
            myFriend.name = friendName;
        }

        [self.moc save:nil];
    }

    // Deleting friends
    // if name is in db but not on chosen list, then delete it
    for (Friend *myFriend in self.friends)
    {
        if (![self.friendNames containsObject:myFriend.name])
        {
            [self.moc deleteObject:myFriend];
        }

        [self.moc save:nil];

    }

    [self loadMOC];

}

- (void)showSortBars
{
    [UIView animateWithDuration:0.2 animations:^{
        self.sortToolbar.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, self.sortToolbar.frame.size.width, self.sortToolbar.frame.size.height);
        self.sortToolbar.alpha = 1.0;

        self.searchBar.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + self.sortToolbar.frame.size.height, self.sortToolbar.frame.size.width, self.sortToolbar.frame.size.height);
//        self.searchBar.showsScopeBar = YES;
//        self.searchBar.scopeButtonTitles = @[@"Name", @"Number of Books"];
        self.searchBar.alpha = 1.0;

        [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top + self.sortToolbar.frame.size.height + self.searchBar.frame.size.height, 0, 0, 0)];
    }];
}

- (void)hideSortBars
{
    [UIView animateWithDuration:0.2 animations:^{
        self.sortToolbar.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height - self.sortToolbar.frame.size.height, self.sortToolbar.frame.size.width, self.sortToolbar.frame.size.height);
        self.sortToolbar.alpha = 0.0;

        self.searchBar.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height - self.searchBar.frame.size.height, self.sortToolbar.frame.size.width, self.sortToolbar.frame.size.height);
        self.searchBar.alpha = 0.0;

        [self.tableView setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, 0, 0, 0)];
    }];
}


#pragma mark - IBActions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addFriendsSegue"])
    {
        UINavigationController *navVC = segue.destinationViewController;
        PeopleTableTableViewController *peopleVC = navVC.viewControllers.firstObject;
        peopleVC.moc = self.moc;
    }
    else
    {
        NSInteger index = [self.tableView indexPathForSelectedRow].row;
        Friend *myFriend = self.friends[index];
        ProfileViewController *vc = segue.destinationViewController;
        vc.myFriend = myFriend;
        vc.moc = self.moc;
    }
}

- (IBAction)onSortButtonPressed:(UIBarButtonItem *)sender
{
    if (self.sortToolbar.alpha == 0.0)
    {
        [self showSortBars];
    }
    else
    {
        [self hideSortBars];

    }
}

- (IBAction)onDoneChoosingFriendsToAdd:(UIStoryboardSegue *)segue
{
    PeopleTableTableViewController *vc = segue.sourceViewController;
    self.friendNames = vc.friendNames;

    [self updateFriends];
}

@end
