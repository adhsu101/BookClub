//
//  AddBookViewController.m
//  BookClub
//
//  Created by Mobile Making on 11/12/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import "BookDetailViewController.h"

@interface BookDetailViewController ()

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

@end

@implementation BookDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!self.book)
    {
        [self.titleLabel setHidden:YES];
        [self.authorLabel setHidden:YES];
        self.bottomToolbar.items = @[self.cancelButton, self.flexibleBarSpace, self.saveButton];
    }
    else
    {
        [self.titleTextField setHidden:YES];
        [self.authorTextField setHidden:YES];
        self.bottomToolbar.items = @[self.doneButton, self.flexibleBarSpace, self.addButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDoneOrCancelButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

@end
