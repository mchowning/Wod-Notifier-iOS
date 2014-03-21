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

@end

@implementation CFRWodDownloader

NSString * const UPDATE_NOTIFICATION_KEY = @"update_notification_key";
static NSString * const URL_STRING =
        @"http://www.crossfitreviver.com/index.php?format=feed&type=rss";



- (void)downloadWods {
    
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
        _inItem = YES;
    }
    
    if (_inItem) {
        if ([elementName isEqualToString:@"title"]) {
            _tagCurrentlyWithin = TITLE;
            assert(_currentWod == nil);
            _currentWod = [[CFRReviverWod alloc] init];
        } else if ([elementName isEqualToString:@"link"]) {
            _tagCurrentlyWithin = LINK;
        } else if ([elementName isEqualToString:@"description"]) {
            _tagCurrentlyWithin = DESCRIPTION;
        }
    }
}

- (void)    parser:(NSXMLParser *)parser
   foundCharacters:(NSString *)string
{
    switch (_tagCurrentlyWithin) {
        case TITLE:
            _currentWod.title = string;
            break;
        case LINK:
            _currentWod.link = string;
            break;
        case DESCRIPTION:
            _currentWod.htmlDescription = string;
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
    if (_tagCurrentlyWithin == DESCRIPTION) {
        [_downloadedWods addObject:[_currentWod copy]];
        _currentWod = nil;
    }
    _tagCurrentlyWithin = UNKNOWN;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_NOTIFICATION_KEY
                                                        object:self
                                                      userInfo:@{UPDATE_NOTIFICATION_KEY : _downloadedWods}];
}

#pragma mark - Lifecycle methods

- (id)init {
    self = [super init];
    if (self) {
        _downloadedWods = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
