//
//  HighLightFormatter.m
//  SLChartLibDemo
//
//  Created by smart on 2017/6/15.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "HighLightFormatter.h"

@implementation HighLightFormatter
#pragma mark - ChartHighlightDelegate
-(void) chartHighlight:(ChartHighlight *) highlight context:(CGContextRef) context bounds:(CGRect) rect edageInsets:(UIEdgeInsets) edageInsets{
    CGContextSaveGState(context);
    CGFloat viewH = rect.size.height;
    CGFloat ybottom = edageInsets.bottom;
    //先绘制虚线<坐标转化>
    CGFloat modelX = highlight.drawX;
    CGFloat modelY_Star = viewH - ybottom;
    CGFloat modelY_end = highlight.drawY;
    
    [[UIColor colorWithHex:@"#FFFFFF" andalpha:0.51] set];
    CGContextSaveGState(context);
    CGFloat pattern[4] = {5,4,5,4};
    CGContextSetLineWidth(context, 1.5);
    CGContextSetLineDash(context, 0, pattern, 4);
    
    CGContextMoveToPoint(context, modelX, modelY_Star);
    CGContextAddLineToPoint(context, modelX, modelY_end);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    //开始绘制显示的数值预计圆形小球
    NSDictionary *yattrs = [self getAttributesWithfont:[UIFont systemFontOfSize:11] Color:[UIColor colorWithHex:@"#727272"]];
    NSString *Ystring = [NSString stringWithFormat:@"%0.0lf",highlight.y];
    CGSize ysize = [Ystring sizeWithAttributes:yattrs];
    CGFloat radicusW = ysize.width + 14;
    CGFloat radicusH = ysize.height+ 4;
    CGFloat radicusR = radicusH/2;
    if (radicusW < radicusH) {
        radicusW = radicusH;
    }
    if ((highlight.y < 10.00000) && (highlight.y >= 0.0000)) {
        radicusW = radicusH;
    }
    CGFloat radicusX = highlight.drawX - radicusW/2;
    CGFloat radicusY = highlight.drawY - radicusH/2;
    
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 0.51);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    UIColor* stokeColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.51];
    UIColor* fillColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    CGRect radicusrect = CGRectMake(radicusX, radicusY, radicusW, radicusH);
    [self drawRadicusRectWith:radicusrect radius:radicusR strokeColor:stokeColor fillColor:fillColor context:context linewidth:2];
    CGPoint localpointY = CGPointMake(modelX - ysize.width/2, highlight.drawY- ysize.height/2);
    [Ystring drawAtPoint:localpointY withAttributes:yattrs];
    CGContextRestoreGState(context);
}

-(void) drawRadicusRectWith:(CGRect) rect
                     radius:(CGFloat) radicus
                strokeColor:(UIColor*) strokeColor
                  fillColor:(UIColor*) fillColor
                    context:(CGContextRef) ctx
                  linewidth:(CGFloat) linewidth{
    if ((2 * radicus > rect.size.height) || (2 * radicus > rect.size.width)) {
        return;
    }
    CGContextSaveGState(ctx);
    CGContextRef context = ctx;
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    
    CGContextSetLineWidth(ctx, linewidth);
    CGContextSetStrokeColorWithColor(ctx, strokeColor.CGColor);
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    
    /*画圆角矩形*/
    float fw = rect.size.width;
    float fh = rect.size.height;
    CGFloat fr = radicus;
    CGContextMoveToPoint(context, x+fw, y+fh-fr);                // 开始坐标右边开始
    CGContextAddArcToPoint(context, x+fw, y+fh, x+fw-fr, y+fh, fr);  // 右下角角度
    CGContextAddLineToPoint(context, x+fr, y+fh);
    CGContextAddArcToPoint(context, x, y+fh, x, y+fh-fr, fr);    // 左下角角度
    CGContextAddLineToPoint(context, x, y+fr);
    CGContextAddArcToPoint(context, x, y, x+fr, y, fr);        // 左上角
    CGContextAddLineToPoint(context, x+fw-fr, y);
    CGContextAddArcToPoint(context, x+fw, y, x+fw, y+fr, fr);      // 右上角
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    CGContextRestoreGState(ctx);
}

#pragma mark - 工具类
-(NSMutableDictionary *) getAttributesWithfont:(UIFont*)font Color:(UIColor*) color{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = color;
    attrs[NSFontAttributeName] = font;
    return attrs;
}
@end
