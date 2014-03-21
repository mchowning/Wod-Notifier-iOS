//
//  CFRWodDownloader.h
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/20/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFRWodDownloader : NSObject <NSXMLParserDelegate>

- (void)downloadWods;

@end
