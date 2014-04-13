//
//  CFRMainTableViewController.m
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/20/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "CFRMainTableViewController.h"
#import "CFRWodDownloader.h"
#import "CFRCustomBusinessObject.h"
#import "CFRMainTableViewDelegate.h"

@interface CFRMainTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) CFRCustomBusinessObject *helper;
@property (nonatomic, strong) CFRMainTableViewDelegate *tableViewDelegate;

@end

@implementation CFRMainTableViewController

static NSString * const FETCHED_RESULTS_CACHE = @"main_table_cache";

#pragma mark - Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.helper = [[CFRCustomBusinessObject alloc] init];
    
    [self getNewFetchedResultsController];

    self.tableViewDelegate = [[CFRMainTableViewDelegate alloc] initWithFetchedResultsController:self.fetchedResultsController
                                                                                      tableView:self.tableView];
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
    
    [self.tableView setHidden:YES]; // Avoids empty tableView showing on first load before
                                    // entries are downloaded.
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        //exit(-1); // Fail
    }
    
    [[[CFRUpdater alloc] init] update];
}

#pragma mark - Getter and Setter methods

- (NSFetchedResultsController *)getNewFetchedResultsController {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    self.fetchedResultsController =
            [self.helper getFetchedResultsControllerWithSortDescriptors:@[sortDescriptor]
                                                              cacheName:FETCHED_RESULTS_CACHE];
    self.fetchedResultsController.delegate = self;
    return self.fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"delegate notified that content will change");
    
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    NSLog(@"delegate notified that object changed");
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"delegate notified that content changed");
    [self.tableView endUpdates];
}

@end
