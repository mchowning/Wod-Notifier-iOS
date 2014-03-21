//
//  CFRUpdater.m
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/20/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "CFRUpdater.h"
#import "CFRWodDownloader.h"

@implementation CFRUpdater


- (void)update {
    CFRWodDownloader *wodDownloader = [[CFRWodDownloader alloc] init];
    [wodDownloader downloadWods:self];
}

- (void)updateReceived:(NSArray *)downloadedWods {
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_NOTIFICATION_KEY
                                                        object:self
                                                      userInfo:@{UPDATE_NOTIFICATION_KEY : downloadedWods}];
    
}

@end
