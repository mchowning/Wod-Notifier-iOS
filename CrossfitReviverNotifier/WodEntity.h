//
//  WodEntity.h
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/21/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WodEntity : NSManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *htmlDescription;
@property (nonatomic, retain) NSString *plainTextDescription;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSString *userResults;
@property (nonatomic, retain) NSNumber *source;
@property (nonatomic, retain) NSString *uniqueID;

- (NSAttributedString *)getAttributedStringDescription;

@end
