//
//  CFRWodDownloader.m
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/20/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "CFRWodDownloader.h"
#import "AFNetworking.h"
#import "Models/CFRReviverWod.h"
#import "CFRXmlParserDelegate.h"

@interface CFRWodDownloader()
@property (nonatomic, strong) id <CFRWodDownloaderDelegate> delegate;
@end

@implementation CFRWodDownloader

static NSString * const kUrlString = @"http://www.crossfitreviver.com/index.php?format=feed&type=rss";

- (void)downloadWods {
    
    NSURL *url = [NSURL URLWithString:kUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSXMLParser *xmlParser = (NSXMLParser *)responseObject;
        [xmlParser setShouldProcessNamespaces:YES];
        CFRXmlParserDelegate *parserDelegate = [[CFRXmlParserDelegate alloc] init];
        xmlParser.delegate = parserDelegate;
        BOOL isParseCompleted = [xmlParser parse];
        if (isParseCompleted) {
            NSMutableArray *downloadedWods = parserDelegate.downloadedWods;
            [self.delegate wodsDownloaded:downloadedWods];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Wods"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    }];
    [operation start];
}

// To get older wods, the following method may be useful:
// [NSURL URLWithString:<#(NSString *)#> relativeToURL:<#(NSURL *)#>]

#pragma mark - Lifecycle methods

- (instancetype)initWithDelegate:(id <CFRWodDownloaderDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

//+ (instancetype)downloaderWithDelegate:(id <CFRWodDownloaderDelegate>)delegate {
//    return [[self alloc] initWithDelegate:delegate];
//}

@end
