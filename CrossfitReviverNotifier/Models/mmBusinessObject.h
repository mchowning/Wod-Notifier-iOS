//
//  mmBusinessObject.h
//  mmiOS
//
//  Created by Kevin McNeish on 12/18/12.
//  Copyright 2013 Oak Leaf Enterprises, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface mmBusinessObject : NSObject {

	NSManagedObjectContext *_managedObjectContext;
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

@property (nonatomic, copy) NSString* dbName;
@property (nonatomic, copy) NSString* entityClassName;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (readonly, nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (readonly, nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, assign) BOOL copyDatabaseIfNotPresent;

- (NSURL *)applicationDocumentsDirectory;

// Create a new entity of the default type
- (NSManagedObject *)createEntity;

// Mark the specified entity for deletion
- (void) deleteEntity:(NSManagedObject *)entity;

// Gets all entities of the default type
- (NSMutableArray *)getAllEntities;

// Gets entities of the default type matching the predicate
- (NSMutableArray *)getEntitiesMatchingPredicate: (NSPredicate *)predicate;

// Gets entities of the default type matching the predicate string
- (NSMutableArray *)getEntitiesMatchingPredicateString: (NSString *)predicateString, ...;

// Get entities of the default type sorted by descriptor matching the predicate
- (NSMutableArray *)getEntitiesSortedBy: (NSSortDescriptor *) sortDescriptor
					  matchingPredicate:(NSPredicate *)predicate;

// Get entities of the specified type sorted by descriptor matching the predicate
- (NSMutableArray *)getEntities: (NSString *)entityName sortedBy:
	(NSSortDescriptor *)sortDescriptor matchingPredicate:(NSPredicate *)predicate;

// Get entities of the specified type sorted by descriptor matching the predicate string
- (NSMutableArray *)getEntities: (NSString *)entityName sortedBy:
	(NSSortDescriptor *)sortDescriptor matchingPredicateString:(NSString *)predicateString, ...;

// Saves changes to all entities managed by the object context
- (void)saveEntities;

// Register a related business controller object
// This causes them to use the same object context
- (void)registerRelatedObject:(mmBusinessObject *)controllerObject;

- (void)performAutomaticLightweightMigration;


@end
