//
//  CFRWodTableViewCell_configureCellSpec.m
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 4/4/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CFRWodTableViewCell+configureCell.h"
#import "CFRReviverWod.h"

SPEC_BEGIN(CFRWodTableViewCell_configureCellSpec)

describe(@"CFRWodTableViewCell+configureCell", ^{
		
    __block CFRWodTableViewCell *cell;
    __block CFRReviverWod *wod;
    
    beforeEach(^{
        cell = [[CFRWodTableViewCell alloc] init];
        wod = [CFRReviverWod nullMock];
    });
    
    it(@"is properly assigned a title", ^{
        NSString *wodTitle = @"The wod's title";
        cell.titleLabel = [UILabel nullMock];
        [[cell.titleLabel should] receive:@selector(setText:) withArguments:wodTitle];
        [wod stub:@selector(title) andReturn:wodTitle];
        
        [cell configureCellFromWodEntity:wod];
    });
    
    it(@"is properly assigned a date", ^{
        
        NSDate *aDate = [NSDate dateWithTimeIntervalSince1970:0];
        [wod stub:@selector(date) andReturn:aDate];
        
        cell.dateLabel = [UILabel nullMock];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"eeee, MMMM dd, yyyy";
        NSString *dateString = [dateFormatter stringFromDate:aDate];
        [[cell.dateLabel should] receive:@selector(setText:) withArguments:dateString];
        
        [cell configureCellFromWodEntity:wod];
    });
    
    it(@"is properly assigned a description", ^{
        
        NSAttributedString *description = [[NSAttributedString alloc] initWithString:@"test string"];
        [wod stub:@selector(getAttributedStringDescription) andReturn:description];
        
        cell.descriptionLabel = [UILabel nullMock];
        [[cell.descriptionLabel should] receive:@selector(setAttributedText:) withArguments:description];
        
        [cell configureCellFromWodEntity:wod];
    });
});
	
SPEC_END
