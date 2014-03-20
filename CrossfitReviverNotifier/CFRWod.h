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
@property (strong, readonly, nonatomic) NSDate *date;

@end
