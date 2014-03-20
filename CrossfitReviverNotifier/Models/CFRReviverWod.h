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

@end
