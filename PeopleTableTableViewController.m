//
//  PeopleTableTableViewController.m
//  BookClub
//
//  Created by Mobile Making on 11/12/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import "PeopleTableTableViewController.h"
#import "Friend.h"

@interface PeopleTableTableViewController ()

@property NSMutableArray *people;
@property NSArray *friends;

@end

@implementation PeopleTableTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadJSON];
    [self loadMOC];
    [self updateArrayOfFriendNames];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.people.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    // set cell text to person name
    cell.textLabel.text = self.people[indexPath.row];
    NSString *person = self.people[indexPath.row];

    // check if person is already a friend

    if ([self.friendNames containsObject:person])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *person = self.people[indexPath.row];

    if ([self.friendNames containsObject:person])
    {
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [self.friendNames removeObject:person];
    }
    else
    {
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.friendNames addObject:person];
    }

}

#pragma mark - helper methods

- (void)loadJSON
{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"people"
                                                     ofType:@"json"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSData *data = [NSData dataWithContentsOfURL:url];

    self.people = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

}

- (void)loadMOC
{

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Friend class])];

    self.friends = [[self.moc executeFetchRequest:request error:nil] mutableCopy];

}

- (void)updateArrayOfFriendNames
{
    self.friendNames = [@[] mutableCopy];

    for (Friend *myFriend in self.friends)
    {
        [self.friendNames addObject:myFriend.name];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
