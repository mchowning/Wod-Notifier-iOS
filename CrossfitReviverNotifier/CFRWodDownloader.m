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

typedef enum RSSTag {
    UNKNOWN,
    TITLE,
    LINK,
    DESCRIPTION
} RSSTag;

@interface CFRWodDownloader()

@property (nonatomic) BOOL inItem;
@property (nonatomic) RSSTag tagCurrentlyWithin;
@property (nonatomic, strong) CFRReviverWod *currentWod;
@property (nonatomic, strong) NSMutableArray *downloadedWods;
@property (nonatomic, strong) CFRUpdater *updaterForCallback;

@end

@implementation CFRWodDownloader

NSString * const UPDATE_NOTIFICATION_KEY = @"update_notification_key";
static NSString * const URL_STRING =
        @"http://www.crossfitreviver.com/index.php?format=feed&type=rss";



- (void)downloadWods:(CFRUpdater *)updater {
    
    self.updaterForCallback = updater;
    
    NSURL *url = [NSURL URLWithString:URL_STRING];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSXMLParser *xmlParser = (NSXMLParser *)responseObject;
        [xmlParser setShouldProcessNamespaces:YES];
        xmlParser.delegate = self;
        [xmlParser parse];
    }failure:^(AFHTTPRequestOperation *opertion, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Wods"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    }];
    [operation start];
}

// Use this method to get older wods:
// [NSURL URLWithString:<#(NSString *)#> relativeToURL:<#(NSURL *)#>]

#pragma mark - NSXMLParserDelegate methods

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    // Avoids picking up the "title" and "link" tags that precede the first Wod entry
    if ([elementName isEqualToString:@"item"]) {
        self.inItem = YES;
    }
    
    if (self.inItem) {
        if ([elementName isEqualToString:@"title"]) {
            self.tagCurrentlyWithin = TITLE;
            assert(self.currentWod == nil);
            self.currentWod = [[CFRReviverWod alloc] init];
        } else if ([elementName isEqualToString:@"link"]) {
            self.tagCurrentlyWithin = LINK;
        } else if ([elementName isEqualToString:@"description"]) {
            self.tagCurrentlyWithin = DESCRIPTION;
        }
    }
}

- (void)    parser:(NSXMLParser *)parser
   foundCharacters:(NSString *)string
{
    switch (self.tagCurrentlyWithin) {
        case TITLE:
            self.currentWod.title = string;
            break;
        case LINK:
            self.currentWod.link = string;
            break;
        case DESCRIPTION:
            self.currentWod.htmlDescription = string;
            break;
        default:
            break;
    }
}

- (void)    parser:(NSXMLParser *)parser
     didEndElement:(NSString *)elementName
      namespaceURI:(NSString *)namespaceURI
     qualifiedName:(NSString *)qName
{
    if (self.tagCurrentlyWithin == DESCRIPTION) {
        [self.downloadedWods addObject:[self.currentWod copy]];
        self.currentWod = nil;
    }
    self.tagCurrentlyWithin = UNKNOWN;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self.updaterForCallback updateReceived:self.downloadedWods];
}

#pragma mark - Lifecycle methods

- (id)init {
    self = [super init];
    if (self) {
        self.downloadedWods = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
