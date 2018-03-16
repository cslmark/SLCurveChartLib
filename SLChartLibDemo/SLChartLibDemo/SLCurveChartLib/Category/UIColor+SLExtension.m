//
//  UIColor+SLExtension.m
//  SLTool
//
//  Created by smart on 16/5/11.
//  Copyright © 2016年 smart. All rights reserved.
//

#import "UIColor+SLExtension.h"

@implementation UIColor (SLExtension)
UIColor* RGBA(UInt8 red, UInt8 green, UInt8 blue, UInt8 alpha) {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
}

void getColorDetail(UIColor* color, float *red, float *green, float *blue, float *alpha){
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    *red = components[0];
    *green = components[1];
    *blue = components[2];
    *alpha = components[3];
}

+ (UIColor *)setRGBWithValue:(unsigned long)rgb {
    unsigned int red = (rgb >> 16) & 0xFF;
    unsigned int green = (rgb >> 8) & 0xFF;
    unsigned int blue = (rgb >> 0) & 0xFF;
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

//形式 @"#112233"
+(UIColor *) colorWithHex:(NSString *) string{
    NSString *cleanString = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if ([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)]
                       ];
    }
    
    if ([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+(UIColor *) colorWithHex:(NSString *) string andalpha:(CGFloat) alpha{
    NSString *cleanString = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if ([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)]
                       ];
    }
    
    if ([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+(UIColor *) colorWithColor:(UIColor *) color andalpha:(CGFloat) alpha{
    CGFloat red = 0, green = 0, blue = 0, tempalpha = 0;
    [color getRed:&red green:&green blue:&blue alpha:&tempalpha];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
