//
//  CFRReviverWod.m
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/20/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "CFRReviverWod.h"

@interface CFRReviverWod()

@property (nonatomic, strong) NSDate *date;

@end

@implementation CFRReviverWod

- (NSAttributedString *)getAttributedStringDescription {
    NSData *htmlData = [self.htmlDescription dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *htmlOptions = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                 NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding)};
    NSAttributedString *attributedStringDescription = [[NSAttributedString alloc] initWithData:htmlData options:htmlOptions documentAttributes:nil error:nil];
    return attributedStringDescription;
}

- (NSString *)getPlainTextDescription {
    return [self getAttributedStringDescription].string;
}

- (void)assignDate:(NSString *)dateString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yy"];
    NSDate *aDate = [df dateFromString:dateString];
    self.date = aDate;
}

#pragma mark - Setter and Getter methods

- (void)setTitle:(NSString *)title {
    _title = title;
    [self assignDate:title];
}

- (WodSource)wodSource {
    return CrossfitReviverWebsite;
}

@end
