//
//  PinkView.m
//  SLChartLibDemo
//
//  Created by IanChen on 2018/3/13.
//  Copyright © 2018年 Hadlinks. All rights reserved.
//

#import "PinkView.h"
#import "BaseCurveView.h"

@implementation PinkView

//327 145

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGFloat R = 50;
    CGFloat d = 20;
    
    //开始绘制对应的矩形
    CGFloat centerX = 166.35595703125;
    CGFloat centerY = 74.49843749999999;
    CGFloat x1 = centerX - R;
    CGFloat y1 = centerY - R;
    CGFloat r = 2*R;
    
    [[UIColor yellowColor] set];
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, x1, y1);
    CGContextAddLineToPoint(ctx, x1+r, y1);
    CGContextAddLineToPoint(ctx, x1+r, y1+r);
    CGContextAddLineToPoint(ctx, x1, y1+r);
    CGContextAddLineToPoint(ctx, x1, y1);
    CGContextAddLineToPoint(ctx, x1+r, y1+r);
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, x1, y1);
    CGContextAddLineToPoint(ctx, x1+r, y1+r);
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, x1+r, y1);
    CGContextAddLineToPoint(ctx, x1, y1+r);
    CGContextStrokePath(ctx);

    
  
    [[UIColor whiteColor] set];
    CGPoint center = CGPointMake(166.35595703125, 74.49843749999999);
    drawCircleRing(ctx, center, R, d);
    
//    [[UIColor redColor] set];
//    drawArc(ctx, center.x, center.y, d);
    
 
    
   
    
//    [[UIColor redColor] set];
//    CGContextAddArc(ctx, centerX, centerY, 20, 0, 2*M_PI, 0);
//    CGContextFillPath(ctx);
    
    CGContextSetLineWidth(ctx, 20);
    [[UIColor purpleColor] set];
    CGContextAddArc(ctx, centerX, centerY, 20, 0, 2*M_PI, 0);
    CGContextStrokePath(ctx);
    [[UIColor greenColor] set];
    CGContextAddArc(ctx, centerX, centerY, 20, 0, 2*M_PI, 0);
    CGContextFillPath(ctx);
//    CGContextAddArc(ctx, centerX, centerY, 20, 0, 2*M_PI, 0);
//    CGContextAddArc(ctx, centerX, centerY, 30, 0, 2*M_PI, 0);
//    CGContextAddArc(ctx, centerX, centerY, 40, 0, 2*M_PI, 0);
//    CGContextAddArc(ctx, centerX, centerY, 50, 0, 2*M_PI, 0);
//    CGContextStrokePath(ctx);
    
   
    
//    [[UIColor blueColor] set];
//    drawArc(160, 70, 49);
}




@end
