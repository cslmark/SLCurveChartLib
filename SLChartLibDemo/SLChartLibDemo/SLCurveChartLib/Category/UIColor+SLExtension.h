//
//  UIColor+SLExtension.h
//  SLTool
//
//  Created by smart on 16/5/11.
//  Copyright © 2016年 smart. All rights reserved.
//

#import <UIKit/UIKit.h>

//为了快速构造RGBA<获取RGB的详细分量>
UIColor* RGBA(UInt8 red, UInt8 green, UInt8 blue, UInt8 alpha);
void getColorDetail(UIColor* color, float *red, float *green, float *blue, float *alpha);

@interface UIColor (SLExtension)
+ (UIColor *)setRGBWithValue:(unsigned long)rgb;
+(UIColor *) colorWithHex:(NSString *) string;
+(UIColor *) colorWithHex:(NSString *) string andalpha:(CGFloat) alpha;
+(UIColor *) colorWithColor:(UIColor *) color andalpha:(CGFloat) alpha;
@end
