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
    newWod.title = [_title copyWithZone:zone];
    newWod.link = [_link copyWithZone:zone];
    newWod.htmlDescription = [_htmlDescription copyWithZone:zone];
    return newWod;
}

@end
