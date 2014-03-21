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

@interface CFRMainTableViewController ()

@property (nonatomic, strong) NSMutableArray *wodList;

@end

@implementation CFRMainTableViewController

#pragma mark - Notification method

- (void)wodsWereUpdated:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    self.wodList = userInfo[UPDATE_NOTIFICATION_KEY];
    [self.tableView reloadData];
}

#pragma mark - Getter and Setter methods

- (NSMutableArray *)wodList {
    if (!_wodList) {
        _wodList = [[NSMutableArray alloc] init];
    }
    return _wodList;
}

#pragma mark - Lifecycle methods

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
           numberOfRowsInSection:(NSInteger)section
{
    return [self.wodList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellReuseIdentifier = @"reuse_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    id <CFRWod> wod = self.wodList[indexPath.row];  // TODO Why no pointer here?
    cell.textLabel.text = wod.title;
    cell.detailTextLabel.text = wod.htmlDescription;
    return cell;
}


#pragma mark - TableView delegate

/*
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
