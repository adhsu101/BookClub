//
//  FriendDetailViewController.m
//  BookClub
//
//  Created by Mobile Making on 11/12/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import "ProfileViewController.h"
#import "BookDetailViewController.h"
#import "Book.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *recommendedBooks;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.myFriend.name;
    self.nameLabel.text = self.myFriend.name;
    self.profileImageView.image = [UIImage imageNamed:@"profile3"];

}

- (void)viewWillAppear:(BOOL)animated
{

    NSArray *array = [self.myFriend.books allObjects];
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    self.recommendedBooks = [array sortedArrayUsingDescriptors:descriptors];
    [self.tableView reloadData];

}

#pragma mark - table view delegate methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Recommended books";
    }
    else
    {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recommendedBooks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.recommendedBooks[indexPath.row] title];
    cell.detailTextLabel.text = [self.recommendedBooks[indexPath.row] author];

    return cell;

}

#pragma mark - navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    BookDetailViewController *vc = segue.destinationViewController;

    if ([segue.identifier isEqualToString:@"commentSegue"])
    {
        vc.book = self.recommendedBooks[[self.tableView indexPathForSelectedRow].row];
    }

    vc.myFriend = self.myFriend;

}


@end
