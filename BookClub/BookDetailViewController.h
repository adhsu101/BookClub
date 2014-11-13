//
//  AddBookViewController.h
//  BookClub
//
//  Created by Mobile Making on 11/12/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "AppDelegate.h"

@interface BookDetailViewController : UIViewController

@property NSManagedObjectContext *moc;
@property Book *book;

@end
