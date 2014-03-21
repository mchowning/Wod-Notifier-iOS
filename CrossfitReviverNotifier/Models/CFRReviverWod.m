//
//  CFRReviverWod.m
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/20/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "CFRReviverWod.h"

@implementation CFRReviverWod

#pragma mark - NSCopying protocol methods

- (id)copyWithZone:(NSZone *)zone {
    CFRReviverWod *newWod = [[self class] allocWithZone:zone];
    newWod.title = [self.title copyWithZone:zone];
    newWod.link = [self.link copyWithZone:zone];
    newWod.htmlDescription = [self.htmlDescription copyWithZone:zone];
    return newWod;
}

@end
