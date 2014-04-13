//
// Created by Matt Chowning on 4/12/14.
// Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CFRMainTableViewDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>
- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                                       tableView:(UITableView *)tableView;

//+ (instancetype)delegateWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
//                                           tableView:(UITableView *)tableView;

@end