//
//  BaseCurveView.m
//  SLChartDemo
//
//  Created by smart on 2017/5/17.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "BaseCurveView.h"
#import "SLGCDTimerTool.h"
#import "SLAccelerator.h"

@interface BaseCurveView()
{
    //死量
    float xleft;
    float xright;
    float xstep;
    NSNumber* xstepNum;

    //View的宽度
    CGFloat myW;
    CGFloat myH;
    //曲线部分的宽度和高度
    CGFloat graphW;
    CGFloat graphH;
    
    //提示点的位置
    int Remindindex;
    
    //用于存储pinch手势的坐标
    CGPoint point;
    float pointR;           //小圆点的半径
    
    //为了方便书写引入
    float ytop;
    float xlabelbottom;     //x轴的坐标距离X轴基线的高度
    float ybottom;
    float leftYAxisW;
    float rightYAxisW;
    float xlabelminstep;
    
    BOOL curved;          //新增属性，是否曲线化
    //用来添加按钮用于点击
    NSMutableArray* buttons;

    CGFloat fromX;
    CGFloat toX;
    
    CGFloat drawFromX;
    CGFloat drawToX;
    
    int drawFromIndex;
    int drawToIndex;
    int centerIndex;
    NSTimer* refreashTimer;
    
    CGFloat maxY;
    CGFloat minY;
    
    //对缩放进行设置的变量
    CGFloat xstepMax;
    CGFloat xstepMin;
    
    //充当加速器和减速器
    SLAccelerator* accelerator;
}

//曲线部分的图层
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGes;
@property (nonatomic, strong) UIPanGestureRecognizer   *panGes;
@property (nonatomic, strong) UITapGestureRecognizer   *tapGes;

//绘制Y轴基准线的数组
@property (nonatomic, strong) NSMutableArray<ChartBaseLine *>* yBaseLineArray;
@end

@implementation BaseCurveView
-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype) init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

//默认初始化部分
-(void) setup{
    xleft = 20;
    xright = 20;
    pointR = 4;
    ytop = 35;
    ybottom = 35;
    
    xstep = 2;    //默认的xstep
    xstepNum = nil;
    xlabelminstep = 1;
    fromX = 0.0;
    xlabelminstep = 60.0;
    xlabelbottom = 5.0;
    
    //最大值和最小数值
    minY = [self.datasource yMin];
    maxY = [self.datasource yMax];
    
    if (self.panGes == nil) {
        [self createPanGesture];
    }
    if (self.hightLight.enabled) {
        [self createTapGesture];
    }
    if ([self.scaleXEnabled boolValue]) {
        if (self.pinchGes == nil) {
            [self createPinchGesture];
        }
    }else{
        if (self.pinchGes) {
            [self removeGestureRecognizer:self.pinchGes];
            self.pinchGes = nil;
        }
    }
    
    if (self.visibleXRangeMaximum == nil) {
        self.visibleXRangeMinimum = @(50);
    }
    if (self.visibleXRangeMinimum == nil) {
        self.visibleXRangeMinimum = @(2);
    }
    
    //默认建立对应的X轴和Y轴
    if (_XAxis == nil) {
        _XAxis = [[ChartAxisBase alloc] init];
        _XAxis.axisType = XAxisType;
        _XAxis.enabled = NO;
    }
    if (_leftYAxis == nil) {
        _leftYAxis = [[ChartAxisBase alloc] init];
        _leftYAxis.axisType = YLeftAxisType;
        _leftYAxis.enabled = NO;
    }
    if (_rightYAxis == nil) {
        _rightYAxis = [[ChartAxisBase alloc] init];
        _rightYAxis.axisType = YrightAxisType;
        _rightYAxis.enabled = NO;
    }
    
    leftYAxisW = 0;
    rightYAxisW = 0;
    
    //初始化默认的加速器
    accelerator = [[SLAccelerator alloc] init];
    accelerator.enabled = YES;
    accelerator.decelerationEnable = YES;
    accelerator.decelerationRate = 100.0f;
    
    //默认的PageScroller是Disable
    if (self.pageScrollerEnable == nil) {
        self.pageScrollerEnable = @(NO);
    }
}

#pragma mark - 懒加载部分
-(NSMutableArray *) yBaseLineArray{
    if (_yBaseLineArray == nil) {
        _yBaseLineArray = [NSMutableArray array];
    }
    return _yBaseLineArray;
}

-(NSNumber *) dynamicYAixs{
    if (_dynamicYAixs == nil) {
        _dynamicYAixs = @(NO);
    }
    return _dynamicYAixs;
}

-(NSNumber *) scaleXEnabled{
    if (_scaleXEnabled == nil) {
        _scaleXEnabled = @(NO);
    }
    return _scaleXEnabled;
}

-(NSNumber *) baseYValueFromZero{
    if (_baseYValueFromZero == nil) {
        _baseYValueFromZero = @(NO);
    }
    return _baseYValueFromZero;
}

-(NSNumber *) visibleXRangeMinimum{
    if (_visibleXRangeMinimum == nil) {
        _visibleXRangeMinimum = @(3);
    }
    return _visibleXRangeMinimum;
}

-(NSNumber *) visibleXRangeMaximum{
    if (_visibleXRangeMaximum == nil) {
        _visibleXRangeMaximum = @(100);
    }
    return _visibleXRangeMaximum;
}

-(void) setScaleXEnabled:(NSNumber *)scaleXEnabled{
    _scaleXEnabled = scaleXEnabled;
    if ([self.scaleXEnabled boolValue]) {
        if (self.pinchGes == nil) {
            [self createPinchGesture];
        }
    }else{
        if (self.pinchGes) {
            [self removeGestureRecognizer:self.pinchGes];
            self.pinchGes = nil;
        }
    }
}

#pragma mark - 基准线的方法提供
-(void) addYBaseLineWith:(ChartBaseLine *) baseLine{
    [self.yBaseLineArray addObject:baseLine];
}

-(void) removeYBaseLineWith:(ChartBaseLine *) baseLine{
    [self.yBaseLineArray removeObject:baseLine];
}

#pragma mark - 当数据源发生了改变的时候，采用该方法进行调用
-(void) refreashDataSourceRestoreContext:(SLLineChartData*) datasource{
    _datasource = datasource;
    self.backgroundColor = [datasource graphColor];
    //完全重新更新
    [self setup];
    [self refreashGraph];
}

-(void) refreashDataSource:(SLLineChartData*) datasource{
    _datasource = datasource;
    [self refreashGraph];
}

-(void) setDatasource:(SLLineChartData *)datasource{
    _datasource = datasource;
    self.backgroundColor = [datasource graphColor];
    [self setup];
    [self refreashGraph];
}

#pragma mark - 定时器部分的处理
-(void) starRefreashTimer{
    if (refreashTimer == nil) {
        refreashTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(refreashGraph) userInfo:nil repeats:YES];
    }
}

-(void) refreashGraph{
//    NSLog(@"定时器进来刷新了++++++++++++++");
    //默认显示
    [self setNeedsDisplay];
}

-(void) cancelRefreashTimer{
    [refreashTimer invalidate];
    refreashTimer = nil;
}

- (void)drawRect:(CGRect)rect {
    //保存宽高
    myW = rect.size.width;
    myH = rect.size.height;
    
    //为了绘图数据实时动态更新关于坐标轴的数值定义将根据数据而发生改变
    if (self.leftYAxis.enabled) {
        leftYAxisW = MAX([self.leftYAxis getLabelSize].width, 20);
    }
    if (self.rightYAxis.enabled) {
        rightYAxisW = MAX([self.rightYAxis getLabelSize].width, 20);
    }
    if (self.XAxis.enabled) {
        CGFloat xHight = [self.rightYAxis getLabelSize].height + 5 + 10;
        ybottom = MAX(xHight, 20);      //保持一定的呼吸感觉
    }else{
        ybottom = 20;
    }
    
    //曲线区域部部分的高度和宽度
    graphW = myW - rightYAxisW - leftYAxisW;
    graphH = myH - ytop - ybottom;
    
    //设定需要展示区域
    toX = fromX + graphW;
    
//    //限制左右两边的区域来配合标杆的运动
//    xleft = KScreen_W * 0.8 - leftYAxisW;
//    xright = KScreen_W * 0.2;
    
    //更新最大和最小的xstep
    if (xstepNum == nil) {
        if (self.visibleXRangeDefaultmum == nil) {
            int defaultRange = ([self.visibleXRangeMinimum intValue] + [self.visibleXRangeMaximum intValue]) / 2.0;
            self.visibleXRangeDefaultmum = [NSNumber numberWithInt:defaultRange];
        }
        xstep = graphW / [self.visibleXRangeDefaultmum intValue];
        xstepNum = [NSNumber numberWithFloat:xstep];
    }
    
    xstepMax = graphW / [self.visibleXRangeMinimum intValue];
    xstepMin = graphW / [self.visibleXRangeMaximum intValue];
    
    //开始计算
    [self calcDraw];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    //开始绘制曲线
    if (self.datasource) {
        if ([self.pageScrollerEnable boolValue]) {
            accelerator.pageWidth = graphW;
            accelerator.pageScrollerEnable = [self.pageScrollerEnable boolValue];
        }
        
        CGContextSaveGState(ctx);
        //开始绘制对应的坐标轴
        [self drawYaxis:self.leftYAxis context:ctx];
        [self drawYaxis:self.rightYAxis context:ctx];
        CGContextRestoreGState(ctx);
        
        CGFloat ypixunit = graphH/(maxY - minY);
        CGContextSaveGState(ctx);
        CGRect clipRect = CGRectMake(leftYAxisW, 0, graphW, myH);
        CGContextClipToRect(ctx, clipRect);
        [self drawXaxis:self.XAxis context:ctx];
        
        //开始绘制基准线
        [self drawYbaseLineWithContext:ctx yPixunit:ypixunit];
        
        for (id<SLChartDataProtocol> dataSet in self.datasource.dataSets) {
            [self drawCurveWith:dataSet context:ctx yPixunit:ypixunit];
        }
        
        //开始绘制HightLight<根据当前的坐标开始绘制>
        [self drawHightLight:self.hightLight context:ctx];
    }
}

#pragma mark - 绘制对应坐标轴的方法
-(void) drawXaxis:(ChartAxisBase *) axis  context:(CGContextRef) ctx{
    //如果需要绘制X轴
    CGContextSaveGState(ctx);
    if (axis.enabled) {
        if (axis.drawLabelsEnabled) {
            CGFloat labelminstep = [axis getLabelSize].width;
            int aXisJump = 1;
            if (xstep < labelminstep) {
                if (axis.axisType == XAxisType) {
                    aXisJump = (int)(labelminstep / xstep) + 1;
                }
            }
            NSDictionary *attrs = [axis getAttributes];
            for (NSInteger index = drawFromIndex; index < (drawToIndex+1); index++) {
                [axis.labelTextColor set];
                if (index % aXisJump == 0) {
                    id<SLChartDataProtocol> dataSet = [self.datasource firstReference];
                    ChartDataEntry* data = [dataSet entryForIndex:(int)index];
                    NSString *string = [axis.axisValueFormatter stringForValue:data.x axis:axis];
                    CGSize size = [string sizeWithAttributes:attrs];
                    CGFloat pointX = leftYAxisW + drawFromX + (index-drawFromIndex) * xstep;
                    CGFloat pointY = myH - (ybottom - xlabelbottom);
                    CGPoint localpoint = CGPointMake(pointX-size.width/2, pointY);
                    [string drawAtPoint:localpoint withAttributes:attrs];
                }
            }
     
        }
        if (axis.drawAxisLineEnabled) {
            [axis.axisLineColor set];
            CGFloat lineStarX = leftYAxisW + drawFromX;
            if (drawFromX < lineStarX) {
                lineStarX = 0;
            }
            CGFloat lineEndX = leftYAxisW + drawFromX + (drawToIndex - drawFromIndex)*xstep;
            CGFloat baseLineY = myH - ybottom;
            CGContextMoveToPoint(ctx, lineStarX, baseLineY);
            CGContextAddLineToPoint(ctx, lineEndX, baseLineY);
            CGContextStrokePath(ctx);
        }
        if (axis.drawGridLinesEnabled) {
            [axis.gridColor set];
            
            CGContextSaveGState(ctx);
            if (axis.GridLinesMode == dashModeLine) {
                CGFloat pattern[4] = {5,4,5,4};
                CGContextSetLineWidth(ctx, 1.5);
                CGContextSetLineDash(ctx, 0, pattern, 4);
            }
            for (NSInteger index = drawFromIndex; index < (drawToIndex+1); index++) {
                CGFloat baseLineX = leftYAxisW + drawFromX + (index-drawFromIndex) * xstep;
                CGFloat starY = ytop;
                CGFloat endY = myH - ybottom;
                CGContextMoveToPoint(ctx, baseLineX, starY);
                CGContextAddLineToPoint(ctx, baseLineX, endY);
                CGContextStrokePath(ctx);
                
            }
            CGContextRestoreGState(ctx);
        }
    }
    CGContextRestoreGState(ctx);
}

-(void) drawYaxis:(ChartAxisBase *) axis  context:(CGContextRef) ctx{
    CGContextSaveGState(ctx);
    if (axis.enabled) {
        CGFloat labelminstep = [axis getLabelSize].height;
        CGFloat ypixunit = (myH - ybottom - ytop)/(maxY - minY);
        CGFloat yValueStep = [axis.axisValueFormatter yStepWithaxis:axis max:maxY Min:minY];
        CGFloat ystep = yValueStep * ypixunit;
        
        if (axis.drawLabelsEnabled) {
            int aXisJump = 1;
            if (ystep < labelminstep) {
                aXisJump = (int)(labelminstep / xstep) + 1;
            }
            NSDictionary *attrs = [axis getAttributes];
            
            int index = 0;
            for (CGFloat yValue = 0; yValue < (graphH+1); yValue += ystep) {
                if (index % aXisJump == 0) {
                    [axis.labelTextColor set];
                    NSString *string = [axis.axisValueFormatter stringForValue:(yValueStep * index) + minY axis:axis];
                    CGSize size = [string sizeWithAttributes:attrs];
                    CGFloat pointX, pointY;
                    if (axis.axisType == YLeftAxisType) {
                        pointX = leftYAxisW - size.width;
                        pointY = myH - ((yValue + ybottom) + size.height/2);
                    }else{
                        pointX = myW - rightYAxisW;
                        pointY = myH - ((yValue + ybottom) + size.height/2);
                    }
                    CGPoint localpoint = CGPointMake(pointX, pointY);
                    [string drawAtPoint:localpoint withAttributes:attrs];
                }
                index++;
            }
        }
        if (axis.drawAxisLineEnabled) {
            [axis.axisLineColor set];
            CGFloat lineStarY, lineEndY,baseLineX;
            if (axis.axisType == YLeftAxisType) {
                baseLineX = leftYAxisW;
            }else{
                baseLineX = myW - rightYAxisW;
            }
            lineStarY = myH - ybottom;
            lineEndY = ytop;
            CGContextMoveToPoint(ctx, baseLineX, lineStarY);
            CGContextAddLineToPoint(ctx, baseLineX, lineEndY);
            CGContextStrokePath(ctx);
        }
        
        if (axis.drawGridLinesEnabled) {
            CGContextSaveGState(ctx);
            [axis.gridColor set];
            if (axis.GridLinesMode == dashModeLine) {
                CGFloat pattern[4] = {5,4,5,4};
                CGContextSetLineWidth(ctx, 1.5);
                if (axis.axisType == YLeftAxisType){
                   CGContextSetLineDash(ctx, fromX, pattern, 4);
                }else{
                   id<SLChartDataProtocol> dataSet = [self.datasource firstReference];
                   CGFloat totalW = [dataSet entryCount]*xstep +  xleft + xright;
                   CGFloat phase = totalW-graphW-fromX;
                   CGContextSetLineDash(ctx, phase, pattern, 4);
                }
            }
            for (CGFloat yValue = 0; yValue < graphH+1; yValue += ystep) {
                if ((yValue == 0) && (self.XAxis.drawAxisLineEnabled) && (self.XAxis.enabled)) {
                    continue;
                }
                CGFloat baseLineY, starX, endX;
                if (axis.axisType == YLeftAxisType) {
                    baseLineY = myH - (yValue + ybottom);
                    starX = leftYAxisW;
                    endX = myW-rightYAxisW;
                }else{
                    baseLineY = myH - (yValue + ybottom);
                    starX = myW - rightYAxisW;
                    endX = leftYAxisW;
                }
                CGContextMoveToPoint(ctx, starX, baseLineY);
                CGContextAddLineToPoint(ctx, endX, baseLineY);
                CGContextStrokePath(ctx);
            }
            CGContextRestoreGState(ctx);
        }
    }
    CGContextRestoreGState(ctx);
}

//绘制hight
-(void) drawHightLight:(ChartHighlight *) hightLight context:(CGContextRef) ctx{
    CGContextSaveGState(ctx);
    CGContextClipToRect(ctx, CGRectMake(leftYAxisW, 0, graphW, myH));
    if (hightLight.enabled) {
        if ((hightLight.dataIndex >= drawFromIndex) && (hightLight.dataIndex <= drawToIndex)) {
            CGFloat ypixunit = (myH - ybottom - ytop)/(maxY - minY);
            int dataSetIndex = [self.datasource dataSetIndexForHigLight:self.hightLight];
            ChartDataEntry* data = [self.datasource entryPointForHighLight:self.hightLight];
            CGFloat pointX = leftYAxisW + drawFromX + (hightLight.dataIndex-drawFromIndex) * xstep;
            CGFloat pointY = myH - ((data.y - minY) * ypixunit)- ybottom;
            self.hightLight.drawX = pointX;
            self.hightLight.drawY = pointY;
            self.hightLight.yPx = pointY;
            self.hightLight.x = data.x;
            self.hightLight.y = data.y;
            self.hightLight.dataSetIndex = dataSetIndex;
            CGRect bounds = CGRectMake(0, 0, myW, myH);
            UIEdgeInsets insets = UIEdgeInsetsMake(ytop, leftYAxisW, ybottom, rightYAxisW);
            if ([self.hightLight.delegate respondsToSelector:@selector(chartHighlight:context:bounds:edageInsets:)]) {
                [self.hightLight.delegate chartHighlight:self.hightLight context:ctx bounds:bounds edageInsets:insets];
            }else{   //默认提供的一种提示的方法
                CGFloat remainH = 29.5;
                CGFloat remainW = 50;
                CGFloat remainX = (pointX - remainW/2);
                SLLineChartDataSet* dataSet = [self.datasource firstReference];
                CGFloat remainY = pointY-21-[dataSet circleRadius]- 2- 6;
                CGFloat tempMaxY = (myH - ybottom);
                if(remainY > tempMaxY){
                    remainY = tempMaxY;
                }
                NSString* yLabelStr = [NSString stringWithFormat:@"%0.0lf",data.y];
                CGFloat showW = 40.0;
                CGFloat showdowX = remainX + remainW/2 - showW/2;
                CGRect indexRect = CGRectMake(showdowX, remainY, showW, remainH);
                UIImage* image = [UIImage imageNamed:@"statistics_data_bg"];
                [image drawInRect:indexRect];
                
                NSDictionary* attrs = [self getAttributesWithfont:[UIFont systemFontOfSize:11.0] Color:[UIColor whiteColor]];
                CGSize size = [yLabelStr sizeWithAttributes:attrs];
                CGFloat labelX = remainX + remainW/2 - size.width/2;
                CGFloat labelY = remainY + remainH/2 - size.height/2 - 3;
                [yLabelStr drawInRect:CGRectMake(labelX, labelY, size.width, size.height) withAttributes:attrs];
            }
        }else{
        }
    }
    CGContextRestoreGState(ctx);
}

-(void) drawCurveWith:(SLLineChartDataSet*) dataSet
              context:(CGContextRef) ctx
             yPixunit:(CGFloat) ypixunit{
    CGContextSaveGState(ctx);
    CGFloat lastX = 0, lastY = 0;
    CGMutablePathRef curPath = CGPathCreateMutable();
    CGMutablePathRef fillPath = CGPathCreateMutable();
    for (NSInteger index = drawFromIndex; index < (drawToIndex+1); index++) {
        ChartDataEntry* data = [dataSet entryForIndex:(int)index];
        CGFloat pointX = leftYAxisW + drawFromX + (index-drawFromIndex) * xstep;
        CGFloat pointY = myH - ((data.y - minY) * ypixunit) - ybottom;
        if (index == drawFromIndex) {
//            CGContextMoveToPoint(ctx, pointX, pointY);
            CGPathMoveToPoint(curPath, NULL, pointX, pointY);
//             CGPathMoveToPoint(fillPath, NULL, pointX, pointY);
            CGPathMoveToPoint(fillPath, NULL, pointX, myH-ybottom);
            CGPathAddLineToPoint(fillPath, NULL, pointX, pointY);
        }else{
            //绘制直线的方法
            if (dataSet.mode == brokenLineMode) {
//                CGContextAddLineToPoint(ctx, pointX, pointY);
                CGPathAddLineToPoint(curPath, NULL, pointX, pointY);
                CGPathAddLineToPoint(fillPath, NULL, pointX, pointY);
            }else{
                //绘制曲线的方法
                CGContextMoveToPoint(ctx, lastX, lastY);
                CGFloat X2 = (lastX+pointX)/2.0;
                CGFloat Y2 = lastY;
                
                CGFloat X3 = (lastX+pointX)/2.0;
                CGFloat Y3 = pointY;
//                CGContextAddCurveToPoint(ctx, X2, Y2, X3, Y3, pointX, pointY);
                CGPathAddCurveToPoint(curPath, NULL, X2, Y2, X3, Y3, pointX, pointY);
                CGPathAddCurveToPoint(fillPath, NULL, X2, Y2, X3, Y3, pointX, pointY);
//                CGContextStrokePath(ctx);
            }
            if (index == drawToIndex) {
                CGPathAddLineToPoint(fillPath, NULL, pointX, myH-ybottom);
                CGPathCloseSubpath(fillPath);
            }
        }
        lastX = pointX;
        lastY = pointY;
    }
    
    //是否绘制渐变的填充颜色
    if (dataSet.drawFilledEnabled) {
        CGContextSaveGState(ctx);
        CGContextAddPath(ctx, fillPath);
        CGContextClip(ctx);
        CGRect graphRect = CGRectMake(leftYAxisW, ytop, graphW, graphH);
        if (dataSet.lineFillMode == gradientolorFillMode) {
            if (dataSet.gradientColors.count) {
                [self drawGradientColor:ctx rect:graphRect options:kCGGradientDrawsAfterEndLocation colors:dataSet.gradientColors];
            }
        }else{
            [dataSet.fillColor set];
//            CGContextAddRect(ctx, graphRect);
            CGContextFillRect(ctx, graphRect);
//            CGContextAddEllipseInRect(ctx, graphRect);
        }
        CGContextRestoreGState(ctx);
    }

    
    //开始绘制曲线
    [[dataSet color] set];
    CGContextSetLineWidth(ctx, dataSet.lineWidth);
    CGContextAddPath(ctx, curPath);
    CGContextStrokePath(ctx);
    
    CGPathRelease(curPath);
    CGPathRelease(fillPath);
    
    //开始增加打点函数
    if (dataSet.drawCirclesEnabled) {
        if ([dataSet drawCircleHoleEnabled] == NO) {
            [[dataSet circleColor] set];
            for (NSInteger index = drawFromIndex; index < (drawToIndex+1); index++) {
                ChartDataEntry* data = [dataSet entryForIndex:(int)index];
                CGFloat pointX = leftYAxisW + drawFromX + (index-drawFromIndex) * xstep;
                CGFloat pointY = myH - ((data.y - minY) * ypixunit)- ybottom;
                drawArc(ctx ,pointX, pointY, dataSet.circleRadius);
            }
        }else{
            for (NSInteger index = drawFromIndex; index < (drawToIndex+1); index++) {
                ChartDataEntry* data = [dataSet entryForIndex:(int)index];
                CGFloat pointX = leftYAxisW + drawFromX + (index-drawFromIndex) * xstep;
                CGFloat pointY = myH - ((data.y - minY) * ypixunit)- ybottom;
                CGPoint center = CGPointMake(pointX, pointY);
                [[dataSet circleColor] set];
                drawCircleRing(ctx, center, dataSet.circleRadius, dataSet.circleHoleRadius);
                NSLog(@"当前中点的位置为:%@", NSStringFromCGPoint(center));
                BOOL clearColor = CGColorEqualToColor([dataSet circleHoleColor].CGColor, [UIColor clearColor].CGColor);
                if (clearColor) {
                    [[self.datasource graphColor] set];
                }else{
                    [[dataSet circleHoleColor] set];
                }
//                drawArc(center.x, center.y, dataSet.circleHoleRadius);
                drawArc(ctx, center.x, center.y, dataSet.circleHoleRadius);
                NSLog(@"当前中点的位置为:%@", NSStringFromCGPoint(center));
            }
        }
    }
    CGContextRestoreGState(ctx);
}

-(void) drawYbaseLineWithContext:(CGContextRef) ctx
                        yPixunit:(CGFloat) ypixunit{
    CGContextSaveGState(ctx);
    for (ChartBaseLine* baseLine in self.yBaseLineArray) {
        if (baseLine.enabled) {
            CGContextSaveGState(ctx);
            [baseLine.lineColor set];
            if (baseLine.lineMode == ChartBaseLineDashMode) {
                CGFloat pattern[4] = {5,4,5,4};
                CGContextSetLineWidth(ctx, baseLine.lineWidth);
                CGContextSetLineDash(ctx, fromX, pattern, 4);
            }
            
            CGFloat baseLineY, starX, endX;
            baseLineY = myH - ((baseLine.yValue - minY) * ypixunit)- ybottom;
            starX = leftYAxisW;
            endX = myW-rightYAxisW;
            CGContextMoveToPoint(ctx, starX, baseLineY);
            CGContextAddLineToPoint(ctx, endX, baseLineY);
            CGContextStrokePath(ctx);
            CGContextRestoreGState(ctx);
        }
    }
    CGContextRestoreGState(ctx);
}


#pragma mark - 计算部分获取最大的数值
-(void) calcDraw{
    double fromResult = (fromX - xleft)/xstep;
    drawFromIndex = (int)fromResult;
    if (fabs(fromResult-(int)fromResult) < 0.0000001) {  //如果整除
        drawFromIndex--;
    }
    if (drawFromIndex < 0) {    //如何情况，都需要把小于0的部分去掉
        drawFromIndex = 0;
    }
    double toResult = (toX - xleft)/xstep;
    drawToIndex = (int)toResult + 1;
    //设置边界条件
    if (drawToIndex >= [self.datasource entryCount]) {
        drawToIndex = (int)([self.datasource entryCount] - 1);
    }
    
    if (drawFromIndex == 0) {
        drawFromX = (drawFromIndex * xstep + xleft) - fromX;
    }else{
        drawFromX = (drawFromIndex * xstep + xleft) - fromX;
    }
    drawToX = drawFromX + (drawToIndex-drawFromIndex)*xstep;
    centerIndex = (drawFromIndex + drawToIndex)/2;
    
    if ([self.dynamicYAixs boolValue]) {
        if ([_datasource entryCount]) {
            id<SLChartDataProtocol> dataSet = [self.datasource firstReference];
            ChartDataEntry* data = [dataSet entryForIndex:drawFromIndex];
            maxY = data.y;
            minY = data.y;
            for (id<SLChartDataProtocol> dataSet in self.datasource.dataSets) {
                for (int index = drawFromIndex+1; index <= drawToIndex; index++) {
                    ChartDataEntry* data = [dataSet entryForIndex:(int)index];
                    if (data.y > maxY) {
                        maxY = data.y;
                    }
                    if (data.y < minY) {
                        minY = data.y;
                    }
                }
            }
        }
        else{
            maxY = [_datasource yMax];
            minY = [_datasource yMin];
        }
    }
    
    
    if ([self.baseYValueFromZero isEqualToNumber:@(YES)]) {
        if (minY > 0) {
            minY = 0;
        }
    }
//    NSLog(@"maxY = %lf minY = %lf", maxY, minY);
}

#pragma mark - 手势的添加
- (void)createPanGesture{
    UIPanGestureRecognizer* panGes = [[UIPanGestureRecognizer alloc] init];
    self.panGes = panGes;
    [panGes addTarget:self action:@selector(panGes:)];
    [self addGestureRecognizer:panGes];
}

- (void)createPinchGesture
{
    UIPinchGestureRecognizer *pinchGes = [[UIPinchGestureRecognizer alloc] init];
    self.pinchGes = pinchGes;
    [pinchGes addTarget:self action:@selector(pinchGes:)];
    [self addGestureRecognizer:pinchGes];
}

-(void) createTapGesture{
    UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc] init];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    self.tapGes = tapGes;
    [tapGes addTarget:self action:@selector(tapGes:)];
    [self addGestureRecognizer:tapGes];
}


-(void) panGes:(UIPanGestureRecognizer *) panGes{
//    NSLog(@"panGes = jdlsjalfjlsdajlfjas");
    if(panGes.state == UIGestureRecognizerStateBegan){
        CGPoint velocity = [panGes velocityInView:panGes.view];
        CGPoint translation = [panGes translationInView:self];
        if (accelerator && accelerator.enabled) {
            [accelerator panGesStarWithVelocity:velocity translation:translation];
        }
    }
    if(panGes.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [panGes translationInView:self];
        double distance = translation.x;
        if (accelerator && accelerator.enabled) {
            CGPoint velocity = [panGes velocityInView:panGes.view];
            distance = [accelerator panGesStateChangeWithVelocity:velocity translation:translation];
        }
        fromX -= distance;
        //限制条件
        if (fromX > ((([self.datasource entryCount]-1)*xstep +  xleft + xright) - graphW)) {
            fromX = (([self.datasource entryCount]-1)*xstep +   xleft + xright) - graphW;
        }
        if (fromX < 0) {
            fromX = 0;
        }
        [self starRefreashTimer];
        //[self setNeedsDisplay];
        //每次移动后，将本次移动的距离置零
        //下一次再移动时，记录的距离就是最后两点间的距离
        //而不是距离第一个点的距离
        [panGes setTranslation:CGPointZero inView:self];
    }
    if(panGes.state == UIGestureRecognizerStateEnded){
        CGPoint translation = [panGes translationInView:self];
        double distance = translation.x;
        if (accelerator && accelerator.enabled) {
            CGPoint velocity = [panGes velocityInView:panGes.view];
            __weak typeof(self) weakSelf = self;
            distance = [accelerator panGesStateEndWithVelocity:velocity translation:translation decelerationBlock:^(double moveDistance) {
                __strong typeof(self) strongSelf = weakSelf;
                fromX -= moveDistance;
                //限制条件
                if (fromX > ((([self.datasource entryCount]-1)*xstep + xleft + xright) - graphW)) {
                    fromX = (([self.datasource entryCount]-1)*xstep + xleft  + xright) - graphW;
                }
                if (fromX < 0) {
                    fromX = 0;
                }
                [strongSelf setNeedsDisplay];
            }];
        }
        fromX -= distance;
        //限制条件
        if (fromX > ((([self.datasource entryCount]-1)*xstep + xleft + xright) - graphW)) {
            fromX = (([self.datasource entryCount]-1)*xstep + xleft  + xright) - graphW;
        }
        if (fromX < 0) {
            fromX = 0;
        }
        [self cancelRefreashTimer];
        [self setNeedsDisplay];
        //每次移动后，将本次移动的距离置零
        //下一次再移动时，记录的距离就是最后两点间的距离
        //而不是距离第一个点的距离
        [panGes setTranslation:CGPointZero inView:self];
    }
    
    NSLog(@"fromX = %lf", fromX);
}

- (void)pinchGes:(UIPinchGestureRecognizer *)ges
{
    if (accelerator && accelerator.enabled) {
        [accelerator stopTracking];
    }
    //取到缩放手势中，当前的缩放比例 获取当前手势的位置
    CGFloat scale = ges.scale;
    if (ges.state == UIGestureRecognizerStateBegan) {
        point =  [ges locationInView:self];
    }
    if(ges.state == UIGestureRecognizerStateChanged){
        if ((xstep*scale > xstepMin) && (xstep*scale < xstepMax)) {
            xstep *= scale;
            fromX = centerIndex*xstep+xleft - graphW/2;
            [self refreashGraph];
        }
        //    每次缩放后都应该将scale设为1，让缩放手势和缩放比例根据当前缩放后的位置去计算
        ges.scale = 1;
    }
    if (ges.state == UIGestureRecognizerStateEnded) {
        if ((xstep*scale > xstepMin) && (xstep*scale < xstepMax)) {
            xstep *= scale;
            fromX = centerIndex*xstep+xleft - graphW/2;
            [self refreashGraph];
//            [self drawXLabelS];
        }
        //    每次缩放后都应该将scale设为1，让缩放手势和缩放比例根据当前缩放后的位置去计算
        ges.scale = 1;
    }
}

-(void) tapGes:(UITapGestureRecognizer *) tapGes{
    if (accelerator && accelerator.enabled) {
        [accelerator stopTracking];
    }
    if (self.hightLight.enabled) {
        CGPoint startPos = [tapGes locationInView:tapGes.view];
        CGFloat x = startPos.x;
        if ((x > leftYAxisW) && ( x < myW - rightYAxisW)) {
            self.hightLight.xPx = (startPos.x - leftYAxisW) + fromX;
            self.hightLight.yPx = (myH - startPos.y) - ybottom;
            CGFloat ypixunit = graphH/(maxY - minY);
            self.hightLight.touchYValue = self.hightLight.yPx/ypixunit + minY;
            int localx = self.hightLight.xPx - xleft;
            int index = ((localx+0.5*xstep)/ xstep);
            if (index < [_datasource entryCount]) {
                self.hightLight.dataIndex = index;
                [self refreashGraph];
            }
        }
    }
}

#pragma mark - 用来标杆上是否存在着对应的数值
/**
 该方法仅仅用于滑动最后的坐标调整，一般不调用
 */
-(void) calacFormodel{
    CGFloat modelX = myW * 0.8;
    CGFloat currentX = fromX+modelX;
    int currntModelIndex = ((fromX+modelX)-xleft)/xstep;
    CGFloat preDistance = fabs(currentX - (currntModelIndex*xstep+xleft));
    CGFloat nextDistance = fabs(currentX - ((currntModelIndex+1)*xstep+xleft));
    if (preDistance < nextDistance) {
        fromX -= preDistance;
    }else{
        fromX += nextDistance;
    }
}

#pragma mark - 工具类
-(NSMutableDictionary *) getAttributesWithfont:(UIFont*)font Color:(UIColor*) color{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = color;
    attrs[NSFontAttributeName] = font;
    return attrs;
}

void drawArc(CGContextRef ctx, CGFloat x, CGFloat y, CGFloat r)
{
    CGContextSaveGState(ctx);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddArc(ctx, x, y, r, 0, 2*M_PI, 0);
    CGContextFillPath(ctx);
    CGContextRestoreGState(ctx);
}

void drawCircleRing(CGContextRef ctx, CGPoint center, CGFloat outRadius, CGFloat inRadius){
    CGContextSaveGState(ctx);
    CGFloat ringWidth = outRadius - inRadius;
    CGContextSetLineWidth(ctx, ringWidth);
    CGContextAddArc(ctx, center.x, center.y, outRadius-ringWidth/2, 0, 2*M_PI, 0);
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);
}



//- (void)drawXLabelS{
//    //隐藏X轴的坐标，滑动结束在显示对应的坐标
//    int xjump = 1;
//    //如果很密
//    if (xstep < xlabelminstep) {
//        xjump = (int)(xlabelminstep / xstep) + 1;
//    }
//    NSDictionary *attrs = [self getAttributesWithfont:[UIFont systemFontOfSize:11] Color:[UIColor whiteColor]];
//    for (NSInteger index = drawFromIndex; index < (drawToIndex+1); index++) {
//        if ((index % xjump) == 0) {
//            ChartDataEntry* data = [self.datasource entryForIndex:(int)index];
//            NSString *string = [NSString stringWithFormat:@"%lf",data.x];
//            CGSize size = [string sizeWithAttributes:attrs];
//            CGFloat pointX = drawFromX + (index-drawFromIndex) * xstep;
//            CGPoint localpoint = CGPointMake(pointX - size.width/2, myH - (ybottom - xlabelbottom));
//            [string drawAtPoint:localpoint withAttributes:attrs];
//        }
//    }
//}

#pragma mark - 增加绘制渐变色的方法
- (void) drawGradientColor:(CGContextRef)p_context
                      rect:(CGRect)p_clipRect
                   options:(CGGradientDrawingOptions)p_options
                    colors:(NSArray *)p_colors {
    CGContextSaveGState(p_context);// 保持住现在的context
    CGContextClipToRect(p_context, p_clipRect);// 截取对应的context
    int colorCount = (int)p_colors.count;
    int numOfComponents = 4;
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colorComponents[colorCount * numOfComponents];
    for (int i = 0; i < colorCount; i++) {
        UIColor *color = p_colors[i];
        CGColorRef temcolorRef = color.CGColor;
        const CGFloat *components = CGColorGetComponents(temcolorRef);
        for (int j = 0; j < numOfComponents; ++j) {
            colorComponents[i * numOfComponents + j] = components[j];
        }
    }
    CGGradientRef gradient =  CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, colorCount);
    CGColorSpaceRelease(rgb);
    CGPoint startPoint = p_clipRect.origin;
    CGPoint endPoint = CGPointMake(CGRectGetMinX(p_clipRect), CGRectGetMaxY(p_clipRect));
    CGContextDrawLinearGradient(p_context, gradient, startPoint, endPoint, p_options);
    CGGradientRelease(gradient);
    CGContextRestoreGState(p_context);// 恢复到之前的context
}






@end
