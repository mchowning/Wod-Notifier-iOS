//
//  CFRMainTableViewController.m
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/20/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "CFRMainTableViewController.h"
#import "CFRWodDownloader.h"
#import "Models/CFRWod.h"
#import "Views/CFRWodTableViewCell.h"
#import "Views/CFRWodTableViewCell+configureCell.h"
#import "CFRCustomBusinessObject.h"

@interface CFRMainTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) CFRCustomBusinessObject *helper;

@end

@implementation CFRMainTableViewController

static NSString * const FETCHED_RESULTS_CACHE = @"main_table_cache";

#pragma mark - Notification method

- (void)wodsWereUpdated:(NSNotification *)notification {
    /* Getting a new fetchedResultsController and fetching the entries because otherwise the
     first download of entries is missed by the controller.  I do not think that this code is
     neccessary for any of the subsequent downloads, and it would not be necessary if the delegate
     methods were properly called on the first download.  I think it may be a problem related to
     the fact that there is nothing in the table on the initial fetch, but I don't really know for
     sure.  This is pretty hacky and should be cleaned up if possible. */
    
    [self getNewFetchedResultsController];
    self.fetchedResultsController.delegate = self;
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        //exit(-1); // Fail
    }

    [self.tableView reloadData];  // No idea why this is necessary to get initially downloaded
                                  // entries, fetchResultsControllerDelegate methods should be
                                  // being called.
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

#pragma mark - Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.helper = [[CFRCustomBusinessObject alloc] init];
    
    [self getNewFetchedResultsController];
    
    
    
    [self.tableView setHidden:YES]; // Avoids empty tableView showing on first load before
                                    // entries are downloaded.
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        //exit(-1); // Fail
    }
    
    [[[CFRUpdater alloc] init] update];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wodsWereUpdated:)
                                                 name:UPDATE_NOTIFICATION_KEY
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
           numberOfRowsInSection:(NSInteger)section
{
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    int numRows = [sectionInfo numberOfObjects];
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView setHidden:NO];
    CFRWodTableViewCell *cell = [self getTableViewCell:tableView];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CFRWodTableViewCell *)getTableViewCell:(UITableView *)tableView {
    NSString *cellReuseIdentifier = @"reuse_identifier";
    CFRWodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CFRWodTableViewCell" owner:self options:nil];
        if ([topLevelObjects[0] isKindOfClass:[CFRWodTableViewCell class]]) {
            cell = [topLevelObjects firstObject];
        } else {
            [NSException raise:@"Incorrect class" format:@"Improper class received from Nib"];
        }
    }
    return cell;
}

- (void)configureCell:(CFRWodTableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
    id<CFRWod> wod = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureCellFromWodEntity:wod];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<CFRWod> cellWod = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSAttributedString *wodDescription = [cellWod getAttributedStringDescription];
    return [CFRWodTableViewCell heightOfContent:wodDescription];
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
