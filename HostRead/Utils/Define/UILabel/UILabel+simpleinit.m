//
//  UILabel+simpleinit.m
//  ebook
//
//  Created by lj on 14-6-12.
//  Copyright (c) 2014年 cczone. All rights reserved.
//

#import "UILabel+simpleinit.h"

@implementation UILabel (simpleinit)

-(id)initWithFrame:(CGRect)frame Font:(UIFont *)font TextColor:(UIColor *)textColor Text:(NSString *)text
{
    self = [self initWithFrame:frame];
    self.font = font;
    self.textColor = textColor;
    self.text = text;
    return self;
}


-(id)initAttributeWithFrame:(CGRect)frame Font:(UIFont *)font TextColor:(UIColor *)textColor Text:(NSString *)text
{
    self = [self initWithFrame:frame];
    NSMutableAttributedString *mattr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName:textColor,NSFontAttributeName:font}];
    self.attributedText = mattr;
    return self;
}

-(id)initWithFont:(UIFont *)font TextColor:(UIColor *)textColor Text:(NSString *)text{
    self = [self init];
    self.font = font;
    self.textColor = textColor;
    self.text = text;
    return self;
}


+ (void) alignLabelWithTop:(UILabel *)label {
    CGSize maxSize = CGSizeMake(label.frame.size.width, 999);
    label.adjustsFontSizeToFitWidth = NO;
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    // get actual height
    CGSize actualSize = [label.text sizeWithFont:label.font constrainedToSize:maxSize lineBreakMode:label.lineBreakMode];
//    CGSize actualSize = [label.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    CGRect rect = label.frame;
    rect.size.height = actualSize.height;
    label.frame = rect;
}

@end
