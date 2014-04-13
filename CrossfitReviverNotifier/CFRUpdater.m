//
//  CFRUpdater.m
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/20/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "CFRUpdater.h"
#import "CFRWodDownloader.h"
#import "CFRWod.h"
#import "CFRCustomBusinessObject.h"

@implementation CFRUpdater

- (void)update {
    CFRWodDownloader *wodDownloader = [[CFRWodDownloader alloc] initWithDelegate:self];
    [wodDownloader downloadWods];
}

- (void)wodsDownloaded:(NSArray *)downloadedWods {
    BOOL newWodsDownloaded = NO;
    CFRCustomBusinessObject *coreDataHelper = [[CFRCustomBusinessObject alloc] init];
    for (id<CFRWod> aWod in downloadedWods) {
	    if (![coreDataHelper wodAlreadyExists:aWod ]) {
		    [coreDataHelper createWodEntityWithTitle:aWod.title
		                                        date:aWod.date
		                             htmlDescription:aWod.htmlDescription
		                        plainTextDescription:aWod.plainTextDescription
		                                        link:aWod.link
		                                       notes:aWod.notes
		                                 userResults:aWod.userResults
		                                      source:[NSNumber numberWithInt:aWod.wodSource]
		                                    uniqueID:aWod.uniqueID];
		    newWodsDownloaded = YES;
	    }
    }

    if (newWodsDownloaded) {
	    [coreDataHelper saveEntities];
    }
}

@end
