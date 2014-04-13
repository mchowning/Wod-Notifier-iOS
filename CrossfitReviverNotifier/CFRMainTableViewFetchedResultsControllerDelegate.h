//
// Created by Matt Chowning on 4/13/14.
// Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CFRMainTableViewFetchedResultsControllerDelegate : NSObject <NSFetchedResultsControllerDelegate>

- (instancetype)initWithTableView:(UITableView *)tableView;

//+ (instancetype)delegateWithTableView:(UITableView *)tableView;

@end