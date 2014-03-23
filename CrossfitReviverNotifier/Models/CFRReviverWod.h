//
//  CFRReviverWod.h
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/20/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "CFRWod.h"
#import <Foundation/Foundation.h>

@interface CFRReviverWod : NSObject <CFRWod>

@property (strong, nonatomic) NSString *title;
@property (strong, readonly, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *htmlDescription;
@property (strong, nonatomic) NSString *plainTextDescription;
@property (readonly, nonatomic) WodSource wodSource;
@property (readonly, nonatomic) NSString *uniqueID;

// Unused by this object, but part of CFRWod
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSString *userResults;

@end
