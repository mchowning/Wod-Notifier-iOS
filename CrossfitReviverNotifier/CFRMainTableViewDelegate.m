//
// Created by Matt Chowning on 4/12/14.
// Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "CFRMainTableViewDelegate.h"
#import "CFRWodTableViewCell.h"
#import "CFRWod.h"
#import "CFRWodTableViewCell+configureCell.h"

@interface CFRMainTableViewDelegate()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CFRMainTableViewDelegate

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                                       tableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.fetchedResultsController = fetchedResultsController;
        self.tableView = tableView;
    }
    return self;
}

//+ (instancetype)delegateWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController tableView:(UITableView *)tableView {
//    return [[self alloc] initWithFetchedResultsController:fetchedResultsController tableView:tableView];
//}

#pragma mark - UITableViewDataSourceDelegate methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    int numRows = 0;
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:(NSUInteger)section];
    if ([sectionInfo respondsToSelector:@selector(numberOfObjects)]) {
        numRows = [sectionInfo numberOfObjects];
    }
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

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView
        heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<CFRWod> cellWod = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSAttributedString *wodDescription = [cellWod getAttributedStringDescription];
    return [CFRWodTableViewCell heightOfContent:wodDescription];
}
@end