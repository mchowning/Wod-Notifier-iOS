//
//  CFRWodTableViewCellSpec.m
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 4/5/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CFRWodTableViewCell.h"

SPEC_BEGIN(CFRWodTableViewCellSpec)

describe(@"CFRWodTableViewCell", ^{
    
    NSString *htmlString = @"<p><strong>For Time, in teams of 3 (35min time cap):</strong></p><p><strong>3k Row<br />150 Push Ups<br />150 Squats<br />150 Russian Twists<br />150 Box Jumps</strong></p><p><strong><em><span style=\"color: #888888;\">Notes: One person works at a time..partition reps however you want.</span></em></strong></p><p><strong><br /></strong></p><p><strong><span style=\"color: #333399;\">Competitor's Program</span></strong></p><p><strong><span style=\"color: #333399;\">For Time:</span></strong></p><p><strong><span style=\"color: #333399;\">3 Rounds:<br />15 Calories on Rower<br />12 Lateral Burpees over Rower<br />+<br />10 Power Snatches 115</span></strong></p><p><strong><span style=\"color: #333399;\">Rest 10mins, repeat</span></strong></p><p><strong><em><span style=\"color: #808080;\">Notes:  Imagine this being a 3 score event...1 score for first time through, 1 score for second time through and 1 score for total time.</span></em></strong></p><p> </p><p><strong style=\"margin: 0px; padding: 0px; border: 0px; outline: 0px; color: #222222; font-family: Helvetica, Arial, FreeSans, sans-serif; line-height: 20px;\"><span style=\"margin: 0px; padding: 0px; border: 0px; outline: 0px; background-color: transparent; color: #ff0000;\">The Rauner's have been so kind to invite all of us over to their home tomorrow night (Sat) starting at 7pm for a Post-Open celebration.  Everyone is invited, even if you didn't participate in the Open this year.  They live at 1636 Blushing Dr, Rochester Hills...BYOB!</span></strong></p>";
    
    CGFloat htmlStringHeightOnScreenAsAttributedText = 644 + TOP_VIEW_HEIGHT;
        /*  CGFloat screenWidth = [[UIScreen mainScreen] applicationFrame].size.width;
            CGSize maxDimensions = (CGSize){screenWidth, CGFLOAT_MAX};
            CGRect textBoundingRect = [attributedString boundingRectWithSize:maxDimensions options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
            CGFloat textHeight = ceil(textBoundingRect.size.height);
         */
    
    NSAttributedString* (^convertHtmlToAttributedString)(NSString*) = ^NSAttributedString*(NSString *htmlString) {
        
        NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *htmlOptions = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                 NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding)};
        
        return [[NSAttributedString alloc] initWithData:htmlData
                                               options:htmlOptions
                                    documentAttributes:nil
                                                 error:nil];
    };
    
    it(@"turns off cell selection", ^{
        CFRWodTableViewCell *cell = [[CFRWodTableViewCell alloc] init];
        [cell awakeFromNib];
        [[theValue(cell.selectionStyle) should] equal:theValue(UITableViewCellSelectionStyleNone)];
    });
    
    it(@"accurately calculates content height when there are no images", ^{
        
        NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *htmlOptions = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                 NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding)};
		NSAttributedString *attributedString =
                                            [[NSAttributedString alloc] initWithData:htmlData
                                                                               options:htmlOptions
                                                                    documentAttributes:nil
                                                                                 error:nil];
       
        
        CGFloat calculatedTextHeight = [CFRWodTableViewCell heightOfContent:attributedString];
        
        [[theValue(calculatedTextHeight) should] equal:theValue(htmlStringHeightOnScreenAsAttributedText)];
    });
    
    pending(@"accurately calculates content height when the html includes image link", ^{
        
        NSString *imageHtml = @"<p><a href=\"/images/stories/happy-st-patricks-day-banner.jpg\" class=\"highslide\"  onclick=\"return hs.expand(this)\"><img 	border=\"0\" style=\"Array\" src=\"/images/stories/thumbs/L2hvbWUzL212ZWxhcmRvL3B1YmxpY19odG1sL2ltYWdlcy9zdG9yaWVzL2hhcHB5LXN0LXBhdHJpY2tzLWRheS1iYW5uZXIuanBn.jpg\"/></a><div id=\"closebutton\" class=\"highslide-overlay closebutton\" onclick=\"return hs.close(this)\" title=\"Closekk\"></div></p>";
        NSString *htmlStringWithImage = [htmlString stringByAppendingString:imageHtml];
		NSAttributedString *attributedString = convertHtmlToAttributedString(htmlStringWithImage);
        
        CGFloat calculatedTextHeight = [CFRWodTableViewCell heightOfContent:attributedString];
        [[theValue(calculatedTextHeight) should] equal:theValue(htmlStringHeightOnScreenAsAttributedText)];
    });
		
    pending(@"accurately calculates content height when the html INCLUDES youtube link", ^{
        
        NSString *youTubeHtml = @"<p><strong><em><span style=\"text-decoration: underline;\"><object width=\"425\" height=\"350\" data=\"http://www.youtube.com/v/4e47lyAbj6I\" type=\"application/x-shockwave-flash\"><param name=\"src\" value=\"http://www.youtube.com/v/4e47lyAbj6I\" /></object></span></em></strong></p>";
        NSString *htmlStringWithImage = [htmlString stringByAppendingString:youTubeHtml];
		NSAttributedString *attributedString = convertHtmlToAttributedString(htmlStringWithImage);
        
        CGFloat calculatedTextHeight = [CFRWodTableViewCell heightOfContent:attributedString];
        [[theValue(calculatedTextHeight) should] equal:theValue(htmlStringHeightOnScreenAsAttributedText)];
        
    });
    
});
	
SPEC_END
