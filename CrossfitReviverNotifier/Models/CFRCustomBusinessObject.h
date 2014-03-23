//
//  CFRCustomBusinessObject.h
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/21/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "mmBusinessObject.h"
#import "WodEntity.h"
#import "CFRWod.h"

@interface CFRCustomBusinessObject : mmBusinessObject

- (WodEntity *)createWodEntityWithTitle:(NSString *)title
                          date:(NSDate *)date
               htmlDescription:(NSString *)htmlDescription
          plainTextDescription:(NSString *)plaintTextDescription
                          link:(NSString *)link
                         notes:(NSString *)notes
                   userResults:(NSString *)userResults
                        source:(NSNumber *)source
                      uniqueID:(NSString *)uniqueID;

- (BOOL)wodAlreadyExists:(id<CFRWod>)newWod;
- (NSMutableArray *)getEntitiesSortedBy:(NSSortDescriptor *)sortDescriptor;

@end