//
//  UIImageView+CornerRadius.h
//
//
//  Created by fancy
//  Copyright © 2016年 fancy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView (CornerRadius)


//- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

- (void)zm_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

//- (instancetype)initWithRoundingRectImageView;

- (void)zm_cornerRadiusRoundingRect;

- (void)zm_attachBorderWidth:(CGFloat)width color:(UIColor *)color;

@end
