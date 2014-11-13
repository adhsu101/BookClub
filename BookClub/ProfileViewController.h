//
//  FriendDetailViewController.h
//  BookClub
//
//  Created by Mobile Making on 11/12/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"
#import "AppDelegate.h"

@interface ProfileViewController : UIViewController

@property NSManagedObjectContext *moc;
@property Friend *myFriend;

@end
