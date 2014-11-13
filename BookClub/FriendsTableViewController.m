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

@interface FriendsTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSManagedObjectContext *moc;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *friends;
@property NSMutableArray *friendNames;

@end

@implementation FriendsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.friends = [NSMutableArray array];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self loadMOC];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    Friend *myFriend = self.friends[indexPath.row];
    cell.textLabel.text = myFriend.name;

    return cell;
}

#pragma mark - helper methods

- (void)loadMOC
{

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Friend class])];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortByName];

    self.friends = [[self.moc executeFetchRequest:request error:nil] mutableCopy];
    
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
        [self loadMOC];

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
        [self loadMOC];

    }

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

- (IBAction)onDoneChoosingFriendsToAdd:(UIStoryboardSegue *)segue
{
    PeopleTableTableViewController *vc = segue.sourceViewController;
    self.friendNames = vc.friendNames;

    [self updateFriends];
}

@end
