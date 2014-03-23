//
//  CFRWod.h
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/20/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Unknown,
    CrossfitReviverWebsite,
    UserInput
} WodSource;

@protocol CFRWod <NSObject>

@property (strong, nonatomic) NSString *title;
@property (strong, readonly, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *htmlDescription;
@property (strong, nonatomic) NSString *plainTextDescription;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSString *userResults;
@property (readonly, nonatomic) WodSource wodSource;
@property (readonly, nonatomic) NSString *uniqueID;

- (NSAttributedString *)getAttributedStringDescription;

@end
