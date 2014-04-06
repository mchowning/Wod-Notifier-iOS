//
//  CFRWodTableViewCell.h
//  CrossfitReviverNotifier
//
//  Created by Matt Chowning on 3/21/14.
//  Copyright (c) 2014 Matt Chowning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFRWodTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

+ (CGFloat)heightOfContent:(NSAttributedString *)descriptionText;

extern CGFloat const TOP_VIEW_HEIGHT;

@end
