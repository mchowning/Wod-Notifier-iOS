//
//  CFRWodDownloader.h
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/20/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CFRWodDownloaderDelegate;

@interface CFRWodDownloader : NSObject <NSXMLParserDelegate>

- (instancetype)initWithDelegate:(id <CFRWodDownloaderDelegate>)delegate;
//+ (instancetype)downloaderWithDelegate:(id <CFRWodDownloaderDelegate>)delegate;
- (void)downloadWods;

@end

@protocol CFRWodDownloaderDelegate <NSObject>

- (void)wodsDownloaded:(NSArray *)downloadedWods;

@end

