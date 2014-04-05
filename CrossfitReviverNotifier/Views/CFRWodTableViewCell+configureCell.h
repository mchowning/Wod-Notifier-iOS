//
//  CFRWodTableViewCell+configureCell.h
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 4/4/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "CFRWodTableViewCell.h"
#import "CFRWod.h"

@interface CFRWodTableViewCell (configureCell)

- (void)configureCellFromWodEntity:(id<CFRWod>)wod;

@end
