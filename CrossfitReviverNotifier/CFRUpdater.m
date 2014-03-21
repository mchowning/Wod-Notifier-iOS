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
    [wodDownloader downloadWods];
}

@end
