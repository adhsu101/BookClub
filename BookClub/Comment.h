//
//  Comment.h
//  BookClub
//
//  Created by Mobile Making on 11/16/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book, Friend;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Book *book;
@property (nonatomic, retain) Friend *friend;

@end
