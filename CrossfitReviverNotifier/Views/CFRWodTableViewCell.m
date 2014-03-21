//
//  CFRWodTableViewCell.m
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/21/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import "CFRWodTableViewCell.h"

@interface CFRWodTableViewCell()

@property (strong, nonatomic) IBOutlet UIView *topView;

@end

@implementation CFRWodTableViewCell

CGFloat const TOP_VIEW_HEIGHT = 90;

#pragma mark - Class methods

+ (CGFloat)heightOfContent:(NSAttributedString *)descriptionText {
    CGFloat screenWidth = [[UIScreen mainScreen] applicationFrame].size.width;
    CGSize maxDimensions = (CGSize){screenWidth, CGFLOAT_MAX};
    CGRect textBoundingRect = [descriptionText boundingRectWithSize:maxDimensions options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    CGFloat textHeight = ceil(textBoundingRect.size.height);
    return textHeight + TOP_VIEW_HEIGHT;
}

#pragma mark - Lifecycle methods

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
