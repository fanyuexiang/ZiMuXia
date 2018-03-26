//
//  UIImageView+CornerRadius.m
//
//
//  Created by fancy on 16/3/1.
//  Copyright © 2016年 fancy. All rights reserved.
//  https://github.com/liuzhiyi1992/ZYCornerRadius

#import "UIImageView+CornerRadius.h"
#import <objc/runtime.h>

const char kProcessedImage;

@interface UIImageView ()

@property (assign, nonatomic) CGFloat wtRadius;
@property (assign, nonatomic) UIRectCorner roundingCorners;
@property (assign, nonatomic) CGFloat wtBorderWidth;
@property (strong, nonatomic) UIColor *wtBorderColor;
@property (assign, nonatomic) BOOL wtHadAddObserver;
@property (assign, nonatomic) BOOL wtIsRounding;

@end





@implementation UIImageView (CornerRadius)
/**
 * @brief init the Rounding UIImageView, no off-screen-rendered
 */
/*
- (instancetype)initWithRoundingRectImageView {
    self = [super init];
    if (self) {
        [self zm_cornerRadiusRoundingRect];
    }
    return self;
}
*/
/**
 * @brief init the UIImageView with cornerRadius, no off-screen-rendered
 */
/*
- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    self = [super init];
    if (self) {
        [self zm_cornerRadiusAdvance:cornerRadius rectCornerType:rectCornerType];
    }
    return self;
}
*/
/**
 * @brief attach border for UIImageView with width & color
 */
- (void)zm_attachBorderWidth:(CGFloat)width color:(UIColor *)color {
    self.wtBorderWidth = width;
    self.wtBorderColor = color;
}

#pragma mark - Kernel
/**
 * @brief clip the cornerRadius with image, UIImageView must be setFrame before, no off-screen-rendered
 */
- (void)zm_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    [self drawBorder:cornerPath];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (processedImage) {
        objc_setAssociatedObject(processedImage, &kProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.image = processedImage;
}

/**
 * @brief clip the cornerRadius with image, draw the backgroundColor you want, UIImageView must be setFrame before, no off-screen-rendered, no Color Blended layers
 */
- (void)zm_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType backgroundColor:(UIColor *)backgroundColor {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    UIBezierPath *backgroundRect = [UIBezierPath bezierPathWithRect:self.bounds];
    [backgroundColor setFill];
    [backgroundRect fill];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    [self drawBorder:cornerPath];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (processedImage) {
        objc_setAssociatedObject(processedImage, &kProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.image = processedImage;
}

/**
 * @brief set cornerRadius for UIImageView, no off-screen-rendered
 */
- (void)zm_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    self.wtRadius = cornerRadius;
    self.roundingCorners = rectCornerType;
    self.wtIsRounding = NO;
    if (!self.wtHadAddObserver) {
        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.wtHadAddObserver = YES;
    }
    //Xcode 8 xib 删除了控件的Frame信息，需要主动创造
    [self layoutIfNeeded];
}

/**
 * @brief become Rounding UIImageView, no off-screen-rendered
 */
- (void)zm_cornerRadiusRoundingRect {
    self.wtIsRounding = YES;
    if (!self.wtHadAddObserver) {
        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.wtHadAddObserver = YES;
    }
    //Xcode 8 xib 删除了控件的Frame信息，需要主动创造
    [self layoutIfNeeded];
}

#pragma mark - Private
- (void)drawBorder:(UIBezierPath *)path {
    if (0 != self.wtBorderWidth && nil != self.wtBorderColor) {
        [path setLineWidth:2 * self.wtBorderWidth];
        [self.wtBorderColor setStroke];
        [path stroke];
    }
}

- (void)zm_dealloc {
    if (self.wtHadAddObserver) {
        [self removeObserver:self forKeyPath:@"image"];
    }
    [self zm_dealloc];
}

- (void)validateFrame {
    if (self.frame.size.width == 0) {
        [self.class swizzleLayoutSubviews];
    }
}

+ (void)swizzleMethod:(SEL)oneSel anotherMethod:(SEL)anotherSel {
    Method oneMethod = class_getInstanceMethod(self, oneSel);
    Method anotherMethod = class_getInstanceMethod(self, anotherSel);
    method_exchangeImplementations(oneMethod, anotherMethod);
}

+ (void)swizzleDealloc {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:NSSelectorFromString(@"dealloc") anotherMethod:@selector(zm_dealloc)];
    });
}

+ (void)swizzleLayoutSubviews {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(layoutSubviews) anotherMethod:@selector(zm_LayoutSubviews)];
    });
}

- (void)zm_LayoutSubviews {
    [self zm_LayoutSubviews];
    if (self.wtIsRounding) {
        [self zm_cornerRadiusWithImage:self.image cornerRadius:self.frame.size.width/2 rectCornerType:UIRectCornerAllCorners];
    } else if (0 != self.wtRadius && 0 != self.roundingCorners && nil != self.image) {
        [self zm_cornerRadiusWithImage:self.image cornerRadius:self.wtRadius rectCornerType:self.roundingCorners];
    }
}

#pragma mark - KVO for .image
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *newImage = change[NSKeyValueChangeNewKey];
        if ([newImage isMemberOfClass:[NSNull class]]) {
            return;
        } else if ([objc_getAssociatedObject(newImage, &kProcessedImage) intValue] == 1) {
            return;
        }
        [self validateFrame];
        if (self.wtIsRounding) {
            [self zm_cornerRadiusWithImage:newImage cornerRadius:self.frame.size.width/2 rectCornerType:UIRectCornerAllCorners];
        } else if (0 != self.wtRadius && 0 != self.roundingCorners && nil != self.image) {
            [self zm_cornerRadiusWithImage:newImage cornerRadius:self.wtRadius rectCornerType:self.roundingCorners];
        }
    }
}

#pragma mark property
- (CGFloat)wtBorderWidth {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setWtBorderWidth:(CGFloat)wtBorderWidth {
    objc_setAssociatedObject(self, @selector(wtBorderWidth), @(wtBorderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)wtBorderColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWtBorderColor:(UIColor *)wtBorderColor {
    objc_setAssociatedObject(self, @selector(wtBorderColor), wtBorderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wtHadAddObserver {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setWtHadAddObserver:(BOOL)wtHadAddObserver {
    objc_setAssociatedObject(self, @selector(wtHadAddObserver), @(wtHadAddObserver), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wtIsRounding {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setWtIsRounding:(BOOL)wtIsRounding {
    objc_setAssociatedObject(self, @selector(wtIsRounding), @(wtIsRounding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIRectCorner)roundingCorners {
    return [objc_getAssociatedObject(self, _cmd) unsignedLongValue];
}

- (void)setRoundingCorners:(UIRectCorner)roundingCorners {
    objc_setAssociatedObject(self, @selector(roundingCorners), @(roundingCorners), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)wtRadius {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setWtRadius:(CGFloat)wtRadius {
    objc_setAssociatedObject(self, @selector(wtRadius), @(wtRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end

