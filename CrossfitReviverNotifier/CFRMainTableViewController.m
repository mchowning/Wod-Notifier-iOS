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
#import "CFRCustomBusinessObject.h"

@interface CFRMainTableViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) CFRCustomBusinessObject *helper;

@end

@implementation CFRMainTableViewController

static NSString * const FETCHED_RESULTS_CACHE = @"main_table_cache";

#pragma mark - Notification method

- (void)wodsWereUpdated:(NSNotification *)notification {
//    NSDictionary *userInfo = notification.userInfo;
//    self.wodList = userInfo[UPDATE_NOTIFICATION_KEY];
    [self.tableView reloadData];
//    self.tableView.hidden = NO;
    
#warning take note
    // Here do I need to reload a new fetchedResultsController in order to get a proper reload?
}

#pragma mark - Getter and Setter methods

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"eeee, MMMM dd, yyyy";
    }
    return _dateFormatter;
}

- (CFRCustomBusinessObject *)helper {
    if (!_helper) {
        _helper = [[CFRCustomBusinessObject alloc] init];
    }
    return _helper;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        _fetchedResultsController =
                    [self.helper getFetchedResultsControllerWithSortDescriptors:@[sortDescriptor]
                                                                      cacheName:FETCHED_RESULTS_CACHE];
#warning Use any fetchedResultsController delegate methods to force update on new data???
    }
    return _fetchedResultsController;
}

#pragma mark - Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        //exit(-1); // Fail
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wodsWereUpdated:)
                                                 name:UPDATE_NOTIFICATION_KEY
                                               object:nil];
//    self.tableView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

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
    CFRWodTableViewCell *cell = [self getTableViewCell:tableView];
    id<CFRWod> cellWod = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell fromWod:cellWod];
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
            @throw([NSException exceptionWithName:@"Incorrect class" reason:@"Improper class received from Nib" userInfo:nil]);
        }
    }
    return cell;
}

- (void)configureCell:(CFRWodTableViewCell *)cell
              fromWod:(id<CFRWod>)wod
{
	cell.titleLabel.text = wod.title;
	NSString *dateString = [self.dateFormatter stringFromDate:wod.date];
	cell.dateLabel.text = dateString;
	NSAttributedString *wodDescriptionText = [wod getAttributedStringDescription];
	cell.descriptionLabel.attributedText= wodDescriptionText;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<CFRWod> cellWod = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSAttributedString *wodDescription = [cellWod getAttributedStringDescription];
    return [CFRWodTableViewCell heightOfContent:wodDescription];
}

@end
