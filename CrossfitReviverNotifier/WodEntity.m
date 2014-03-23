//
//  WodEntity.m
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/21/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "WodEntity.h"


@implementation WodEntity

@dynamic date;
@dynamic htmlDescription;
@dynamic link;
@dynamic notes;
@dynamic plainTextDescription;
@dynamic source;
@dynamic title;
@dynamic userResults;
@dynamic uniqueID;

- (NSAttributedString *)getAttributedStringDescription {
    NSData *htmlData = [self.htmlDescription dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *htmlOptions = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                 NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding)};
    NSAttributedString *attributedStringDescription = [[NSAttributedString alloc] initWithData:htmlData options:htmlOptions documentAttributes:nil error:nil];
    return attributedStringDescription;
}

@end
