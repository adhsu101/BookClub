//
//  AddBookViewController.m
//  BookClub
//
//  Created by Mobile Making on 11/12/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import "BookDetailViewController.h"
#import "Comment.h"
#import "CommentTableViewCell.h"

@interface BookDetailViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *authorTextField;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomToolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *flexibleBarSpace;
@property (strong, nonatomic) IBOutlet UILabel *addABookLabel;
@property NSArray *books;
@property NSMutableArray *commentsForFriend;

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
        self.bottomToolbar.items = @[self.doneButton, self.flexibleBarSpace, self.saveButton];
        self.saveButton.enabled = NO;
    }
    else
    {
        self.moc = self.book.managedObjectContext;
        [self updateCommentModel];
        [self.titleTextField setHidden:YES];
        [self.authorTextField setHidden:YES];
        [self.addABookLabel setHidden:YES];
        self.titleLabel.text = self.book.title;
        self.authorLabel.text = self.book.author;
        self.bottomToolbar.items = @[self.flexibleBarSpace, self.addButton];
    }


}

#pragma mark - table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.book)
    {
        return self.books.count;
    }
    else
    {
        return self.commentsForFriend.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (!self.book)
    {

        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell = [tableView dequeueReusableCellWithIdentifier:@"bookCell" forIndexPath:indexPath];
        cell.textLabel.text = [self.books[indexPath.row] title];
        cell.detailTextLabel.text = [self.books[indexPath.row] author];

        if ([self.myFriend.books containsObject:self.books[indexPath.row]])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

        return cell;

    }
    else
    {

        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
        Comment *comment = self.commentsForFriend[indexPath.row];
        cell.commentTextLabel.text = comment.text;

        return cell;

    }


}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (!self.book)
    {
        return @"Or choose from existing";
    }
    else
    {
        return @"Comments";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (!self.book)
    {
        Book *book = self.books[indexPath.row];

        if ([self.myFriend.books containsObject:book])
        {
            [self.myFriend removeBooksObject:book];
        }
        else
        {
            [self.myFriend addBooksObject:book];
        }

        [self.moc save:nil];
        [self.tableView reloadData];

    }


}

#pragma mark - text field delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.saveButton.enabled = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.titleTextField.text isEqualToString:@""] && [self.authorTextField.text isEqualToString:@""])
    {
        self.saveButton.enabled = NO;
    }
}



#pragma mark - IBActions


- (IBAction)onTitleFinishedEditing:(UITextField *)sender
{
    [self.authorTextField isEditing];
}

- (IBAction)onAuthorFinishedEditing:(UITextField *)sender
{
    [sender resignFirstResponder];
}

- (IBAction)onDoneButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSaveButtonPressed:(UIBarButtonItem *)sender
{

    if (![self.titleTextField.text isEqualToString:@""])
    {
        Book *book = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Book class]) inManagedObjectContext:self.moc];
        book.title = self.titleTextField.text;
        book.author = self.authorTextField.text;

        [self.myFriend addBooksObject:book];
//        self.book = book;
        [self.moc save:nil];
        [self loadMOC];
    }

    self.titleTextField.text = @"";
    self.authorTextField.text = @"";

    self.saveButton.enabled = NO;
}

- (IBAction)onAddCommentPressed:(UIBarButtonItem *)sender
{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add a comment" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alert addTextFieldWithConfigurationHandler:nil];

    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                           Comment *comment = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Comment class]) inManagedObjectContext:self.moc];

                                                           UITextField *textfield = alert.textFields.firstObject;
                                                           comment.text = textfield.text;
                                                           [self.book addCommentsObject:comment];
                                                           [self.myFriend addCommentsObject:comment];
                                                           [self.moc save:nil];

                                                           [self updateCommentModel];
                                                           [self.tableView reloadData];
    }];

    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:cancelButton];
    [alert addAction:okButton];

    [self presentViewController:alert animated:YES completion:nil];
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

- (void)updateCommentModel
{

    self.commentsForFriend = [@[]mutableCopy];
    NSArray *allCommentsForBook = [self.book.comments allObjects];
    NSArray *allFriendComments = [self.myFriend.comments allObjects];
    for (Comment *comment in allCommentsForBook)
    {
        if ([allFriendComments containsObject:comment])
        {
            [self.commentsForFriend addObject:comment];
        }

    }

}
@end
