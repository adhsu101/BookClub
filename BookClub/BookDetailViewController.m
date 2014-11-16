//
//  AddBookViewController.m
//  BookClub
//
//  Created by Mobile Making on 11/12/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import "BookDetailViewController.h"
#import "AppDelegate.h"

@interface BookDetailViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *authorTextField;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomToolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *flexibleBarSpace;
@property (strong, nonatomic) IBOutlet UILabel *addABookLabel;
@property NSArray *books;

@end

@implementation BookDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!self.book)
    {
        self.moc = self.myFriend.managedObjectContext;
        [self loadMOC];
        [self.titleLabel setHidden:YES];
        [self.authorLabel setHidden:YES];
        self.bottomToolbar.items = @[self.cancelButton, self.flexibleBarSpace, self.saveButton];
    }
    else
    {
        self.moc = self.book.managedObjectContext;
        [self.titleTextField setHidden:YES];
        [self.authorTextField setHidden:YES];
        [self.addABookLabel setHidden:YES];
        self.bottomToolbar.items = @[self.doneButton, self.flexibleBarSpace, self.addButton];
    }


}

#pragma mark - table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.books[indexPath.row] title];
    cell.detailTextLabel.text = [self.books[indexPath.row] author];

    return cell;

}

#pragma mark - text field delegate methods



#pragma mark - IBActions


- (IBAction)onTitleFinishedEditing:(UITextField *)sender
{
    [self.authorTextField isEditing];
}

- (IBAction)onAuthorFinishedEditing:(UITextField *)sender
{
    [sender resignFirstResponder];
}

- (IBAction)onDoneOrCancelButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

- (IBAction)onSaveButtonPressed:(UIBarButtonItem *)sender
{
    if (![self.titleTextField.text isEqualToString:@""])
    {
        self.titleTextField.text = @"";
        Book *book = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Book class]) inManagedObjectContext:self.moc];
        book.title = self.titleTextField.text;
        book.author = self.authorTextField.text;

        [self loadMOC];
    }
}

#pragma mark - helper methods

- (void)loadMOC
{

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Book class])];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    request.sortDescriptors = @[sortByName];

    self.books = [[self.moc executeFetchRequest:request error:nil] mutableCopy];

    [self.tableView reloadData];

}


@end
