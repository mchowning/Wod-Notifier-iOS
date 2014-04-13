//
//  CFRMainTableViewController.m
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/20/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "CFRMainTableViewController.h"
#import "CFRUpdater.h"
#import "CFRCustomBusinessObject.h"
#import "CFRMainTableViewDelegate.h"
#import "CFRMainTableViewFetchedResultsControllerDelegate.h"

@interface CFRMainTableViewController ()
@property (nonatomic, strong) CFRCustomBusinessObject *helper;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) CFRMainTableViewFetchedResultsControllerDelegate *fetchedResultsControllerDelegate;
@property (nonatomic, strong) CFRMainTableViewDelegate *tableViewDelegate;
@end

@implementation CFRMainTableViewController

static NSString * const FETCHED_RESULTS_CACHE = @"main_table_cache";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.helper = [[CFRCustomBusinessObject alloc] init];
    
    [self getNewFetchedResultsController];

    self.tableViewDelegate = [[CFRMainTableViewDelegate alloc] initWithFetchedResultsController:self.fetchedResultsController
                                                                                      tableView:self.tableView];
    [self.tableView setDelegate:self.tableViewDelegate];
    [self.tableView setDataSource:self.tableViewDelegate];
    
    [self.tableView setHidden:YES]; // Avoids empty tableView showing on first load before
                                    // entries are downloaded.
    [self checkForUpdates];
}

- (NSFetchedResultsController *)getNewFetchedResultsController {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    self.fetchedResultsController =
            [self.helper getFetchedResultsControllerWithSortDescriptors:@[sortDescriptor]
                                                              cacheName:FETCHED_RESULTS_CACHE];
    self.fetchedResultsControllerDelegate =
            [[CFRMainTableViewFetchedResultsControllerDelegate alloc] initWithTableView:self.tableView];
    [self.fetchedResultsController setDelegate:self.fetchedResultsControllerDelegate];
    [self fetchResults];
    return self.fetchedResultsController;
}

- (void)fetchResults {
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        //exit(-1); // Fail
    }
}

- (void)checkForUpdates {
    [[[CFRUpdater alloc] init] update];
}

@end
