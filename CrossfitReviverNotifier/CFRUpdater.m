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
    CFRWodDownloader *wodDownloader = [[CFRWodDownloader alloc] init];
    [wodDownloader downloadWods:self];
}

- (void)wodsDownloaded:(NSArray *)downloadedWods {
    BOOL newWodsDownloaded = NO;
    CFRCustomBusinessObject *coreDataHelper = [[CFRCustomBusinessObject alloc] init];
    for (id<CFRWod> aWod in downloadedWods) {
//	    NSString *newWodUniqueID = aWod.uniqueID;
//	    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uniqueID = %@", newWodUniqueID];
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
	    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_NOTIFICATION_KEY
	                                                        object:self
	                                                      userInfo:nil];
//        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//        localNotification.alertBody = @"Background fetch method called";
//        localNotification.fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:15];
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

@end
