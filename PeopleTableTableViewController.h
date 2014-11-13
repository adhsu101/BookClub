//
//  PeopleTableTableViewController.h
//  BookClub
//
//  Created by Mobile Making on 11/12/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PeopleTableTableViewController : UITableViewController

@property NSMutableArray *friendNames;
@property NSManagedObjectContext *moc;

@end
