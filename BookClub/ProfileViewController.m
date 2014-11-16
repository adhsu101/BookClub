//
//  FriendDetailViewController.m
//  BookClub
//
//  Created by Mobile Making on 11/12/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import "ProfileViewController.h"
#import "BookDetailViewController.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *books;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.myFriend.name;
    self.nameLabel.text = self.myFriend.name;
    self.profileImageView.image = [UIImage imageNamed:@"profile3"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    BookDetailViewController *vc = segue.destinationViewController;

    if ([segue.identifier isEqualToString:@"addBookSegue"])
    {
        vc.myFriend = self.myFriend;
    }
    else
    {
        vc.book = self.books[[self.tableView indexPathForSelectedRow].row];
    }

}


@end
