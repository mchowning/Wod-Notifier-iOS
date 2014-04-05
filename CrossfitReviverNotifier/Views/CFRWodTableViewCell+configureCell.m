//
//  CFRWodTableViewCell+configureCell.m
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 4/4/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "CFRWodTableViewCell+configureCell.h"

@implementation CFRWodTableViewCell (configureCell)


- (void)configureCellFromWodEntity:(id<CFRWod>)wod {
    
	self.titleLabel.text = wod.title;
    
	NSAttributedString *wodDescriptionText = [wod getAttributedStringDescription];
	self.descriptionLabel.attributedText= wodDescriptionText;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"eeee, MMMM dd, yyyy";
	NSString *dateString = [dateFormatter stringFromDate:wod.date];
	self.dateLabel.text = dateString;
}

@end
