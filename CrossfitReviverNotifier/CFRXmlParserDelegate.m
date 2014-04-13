//
// Created by Matt Chowning on 4/13/14.
// Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "CFRXmlParserDelegate.h"
#import "CFRReviverWod.h"

typedef enum {
    RSSTagUnknown,
    RSSTagTitle,
    RSSTagLink,
    RSSTagDescription
} RSSTag;

@interface CFRXmlParserDelegate ()
@property (nonatomic) BOOL inItem;
@property (nonatomic) RSSTag tagCurrentlyWithin;
@property (nonatomic, strong) CFRReviverWod *currentWod;
@end

@implementation CFRXmlParserDelegate

- (id)init {
    self = [super init];
    if (self) {
        self.downloadedWods = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - NSXMLParserDelegate methods

-(void)parser:(NSXMLParser *)parser
        didStartElement:(NSString *)elementName
        namespaceURI:(NSString *)namespaceURI
        qualifiedName:(NSString *)qName
        attributes:(NSDictionary *)attributeDict
{
    // Avoids picking up the "title" and "link" tags that precede the first Wod entry
    if ([elementName isEqualToString:@"item"]) {
        self.inItem = YES;
    }

    if (self.inItem) {
        if ([elementName isEqualToString:@"title"]) {
            self.tagCurrentlyWithin = RSSTagTitle;
            assert(self.currentWod == nil);
            self.currentWod = [[CFRReviverWod alloc] init];
        } else if ([elementName isEqualToString:@"link"]) {
            self.tagCurrentlyWithin = RSSTagLink;
        } else if ([elementName isEqualToString:@"description"]) {
            self.tagCurrentlyWithin = RSSTagDescription;
        }
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    switch (self.tagCurrentlyWithin) {
        case RSSTagTitle:
            self.currentWod.title = string;
            break;
        case RSSTagLink:
            self.currentWod.link = string;
            break;
        case RSSTagDescription:
            self.currentWod.htmlDescription = string;
            break;
        default:
            break;
    }
}

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
{
    if (self.tagCurrentlyWithin == RSSTagDescription) {
        [self.downloadedWods addObject:self.currentWod];
        self.currentWod = nil;
    }
    self.tagCurrentlyWithin = RSSTagUnknown;
}

//- (void)parserDidEndDocument:(NSXMLParser *)parser {
//    [self.delegate wodsDownloaded:self.downloadedWods];
//}
@end