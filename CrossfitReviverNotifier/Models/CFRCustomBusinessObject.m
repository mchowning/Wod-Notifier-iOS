//
//  CFRCustomBusinessObject.m
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/21/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "CFRCustomBusinessObject.h"

@implementation CFRCustomBusinessObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dbName = @"WodCoreDataModel";
        self.entityClassName = @"WodEntity";
    }
    return self;
}

- (WodEntity *)createWodEntityWithTitle:(NSString *)title
                          date:(NSDate *)date
               htmlDescription:(NSString *)htmlDescription
          plainTextDescription:(NSString *)plaintTextDescription
                          link:(NSString *)link
                         notes:(NSString *)notes
                   userResults:(NSString *)userResults
                        source:(NSNumber *)source
                      uniqueID:(NSString *)uniqueID
{
	WodEntity *entity = (WodEntity *)[self createEntity];
	entity.title = title;
	entity.date = date;
	entity.htmlDescription = htmlDescription;
	entity.plainTextDescription = plaintTextDescription;
	entity.link = link;
	entity.notes = notes;
	entity.userResults = userResults;
	entity.source = source;
    entity.uniqueID = uniqueID;
	return entity;
}

// Look for match using title, date, and source???
// If it is a CFRWod the best matching criterion is probably the link

- (BOOL)wodAlreadyExists:(id<CFRWod>)newWod {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uniqueID = %@", newWod.uniqueID];
    NSArray *matchingEntities = [self getEntitiesMatchingPredicate:predicate];
    return ([matchingEntities count] > 0);
}

- (NSMutableArray *)getEntitiesSortedBy:(NSSortDescriptor *)sortDescriptor {
    return [self getEntities:self.entityClassName sortedBy:sortDescriptor matchingPredicate:nil];
}

- (NSFetchedResultsController *)getFetchedResultsControllerWithSortDescriptors:(NSArray *)
        sortDescriptors                                              cacheName:(NSString *)cacheName
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity =
	        [NSEntityDescription entityForName:self.entityClassName inManagedObjectContext:[self
	                                                                                        managedObjectContext
	         ]];
	[fetchRequest setEntity:entity];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[fetchRequest setFetchBatchSize:20];
	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
	                                           managedObjectContext:[self managedObjectContext]
	                                             sectionNameKeyPath:nil cacheName:cacheName];
}

@end
