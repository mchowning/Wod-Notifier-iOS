//
//  mmBusinessObject.m
//  mmiOS
//
//  Created by Kevin McNeish on 12/18/12.
//  Copyright 2013 Oak Leaf Enterprises, Inc. All rights reserved.
//

#import "mmBusinessObject.h"

@implementation mmBusinessObject

// Initialization
- (id)init
{
    if ((self = [super init])) {
		_copyDatabaseIfNotPresent = NO;
    }
    return self;
}

// Creates a new entity of the default type and adds it to the managed object context
- (NSManagedObject *)createEntity
{
	return [NSEntityDescription insertNewObjectForEntityForName:self.entityClassName inManagedObjectContext:[self managedObjectContext]];
}

// Delete the specified entity
- (void) deleteEntity:(NSManagedObject *)entity {
	[self.managedObjectContext deleteObject:entity];
}

// Gets entities for the specified request
- (NSMutableArray *)getEntities: (NSString *)entityName sortedBy:(NSSortDescriptor *)sortDescriptor matchingPredicate:(NSPredicate *)predicate
{
	NSError *error = nil;

	// Create the request object
	NSFetchRequest *request = [[NSFetchRequest alloc] init];

	// Set the entity type to be fetched
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];

	// Set the predicate if specified
	if (predicate) {
		[request setPredicate:predicate];
	}

	// Set the sort descriptor if specified
	if (sortDescriptor) {
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[request setSortDescriptors:sortDescriptors];
	}

	// Execute the fetch
	NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

	if (mutableFetchResults == nil) {
        // Handle error
	}

	return mutableFetchResults;
}

// Gets all entities of the default type
- (NSMutableArray *)getAllEntities
{
    return [self getEntities:self.entityClassName sortedBy:nil matchingPredicate:nil];
}

// Gets entities of the default type matching the predicate
- (NSMutableArray *)getEntitiesMatchingPredicate: (NSPredicate *)predicate
{
    return [self getEntities:self.entityClassName sortedBy:nil matchingPredicate:predicate];
}

// Gets entities of the default type matching the predicate string
- (NSMutableArray *)getEntitiesMatchingPredicateString: (NSString *)predicateString, ...;
{
    va_list variadicArguments;
    va_start(variadicArguments, predicateString);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString
                                                    arguments:variadicArguments];
    va_end(variadicArguments);
    return [self getEntities:self.entityClassName sortedBy:nil matchingPredicate:predicate];
}

// Get entities of the default type sorted by descriptor matching the predicate
- (NSMutableArray *)getEntitiesSortedBy: (NSSortDescriptor *) sortDescriptor
					  matchingPredicate:(NSPredicate *)predicate
{
    return [self getEntities:self.entityClassName sortedBy:sortDescriptor matchingPredicate:predicate];
}

// Gets entities of the specified type sorted by descriptor, and matching the predicate string
- (NSMutableArray *)getEntities: (NSString *)entityName
					   sortedBy:(NSSortDescriptor *)sortDescriptor
		matchingPredicateString:(NSString *)predicateString, ...;
{
    va_list variadicArguments;
    va_start(variadicArguments, predicateString);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString
                                                    arguments:variadicArguments];
    va_end(variadicArguments);
    return [self getEntities:entityName sortedBy:sortDescriptor matchingPredicate:predicate];
}

- (void) registerRelatedObject:(mmBusinessObject *)controllerObject
{
	controllerObject.managedObjectContext = self.managedObjectContext;
}

// Saves all changes (insert, update, delete) of entities
- (void)saveEntities
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
        }
    }
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {

    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {

    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.dbName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {

    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

	// If the sqlite database doesn't already exist, create it
	// by copying the sqlite database included in this project
	if (self.copyDatabaseIfNotPresent) {

		// Get the documents directory
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
															 NSUserDomainMask, YES);
		NSString *docsDir = paths[0];

		// Append the name of the database to get the full path
		NSString *dbcPath = [docsDir stringByAppendingPathComponent:
							 [self.dbName stringByAppendingString:@".sqlite"]];

		// Create database if it doesn't already exist
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if (![fileManager fileExistsAtPath:dbcPath]) {
			NSString *defaultStorePath = [[NSBundle mainBundle]
										  pathForResource:self.dbName ofType:@"sqlite"];
			if (defaultStorePath) {
				[fileManager copyItemAtPath:defaultStorePath toPath:dbcPath error:NULL];
			}
		}
	}

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:
					   [NSString stringWithFormat:@"%@%@", self.dbName, @".sqlite"]];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.

         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.

         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.


         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]

         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

         */
        if ([error code] == 134100) {
            [self performAutomaticLightweightMigration];
        }
		else
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
    }
    return _persistentStoreCoordinator;
}

- (void)performAutomaticLightweightMigration {

    NSError *error;

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", self.dbName, @".sqlite"]];

    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
												   configuration:nil
															 URL:storeURL
														 options:options
														   error:&error]){
        // Handle the error.
    }
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
