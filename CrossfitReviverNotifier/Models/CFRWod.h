//
//  CFRWod.h
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/20/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CFRWod <NSObject>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *htmlDescription;
@property (strong, readonly, nonatomic) NSDate *date;
@property (strong, readonly, nonatomic) NSString *uniqueID;

- (NSAttributedString *)getAttributedStringDescription;

@end
