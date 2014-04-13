//
// Created by Matt Chowning on 4/13/14.
// Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CFRXmlParserDelegate : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *downloadedWods;

@end