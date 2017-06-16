//
//  ViewController.m
//  SLChartLibDemo
//
//  Created by smart on 2017/6/14.
//  Copyright © 2017年 Hadlinks. All rights reserved.
//

#import "ViewController.h"
#import "SLCurveChartLib.h"
#import "XAxisFormtter.h"
#import "YAxisFormtter.h"
#import "YRightAxisFormtter.h"
#import "HighLightFormatter.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet BaseCurveView *myView;
@property (nonatomic, strong) SLLineChartDataSet* dataset;
@property (nonatomic, strong) NSMutableArray* tempArray0;
@property (nonatomic, strong) NSMutableArray* tempArray1;
@property (nonatomic, strong) SLGCDTimer timer;
@property (nonatomic, strong) HighLightFormatter *highLightFor;

- (IBAction)enableXscaleClick:(UIButton *)sender;
- (IBAction)enableDynamicYAxisClick:(UIButton *)sender;
- (IBAction)hiddenLeftYAxisClick:(UIButton *)sender;
- (IBAction)hiddenRightAxisClick:(UIButton *)sender;
- (IBAction)hiddenXAxisClick:(UIButton *)sender;
- (IBAction) curveOrStrightClick:(UIButton *)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ChartAxisBase* xAxis = self.myView.XAxis;
    xAxis.axisValueFormatter = [[XAxisFormtter alloc] init];
    xAxis.drawLabelsEnabled = YES;
    xAxis.drawAxisLineEnabled = YES;
    xAxis.drawGridLinesEnabled = YES;
    xAxis.labelFont = [UIFont systemFontOfSize:11.0];
    xAxis.labelTextColor = [UIColor whiteColor];
    xAxis.maxLongLabelString = @"1234";
    xAxis.GridLinesMode = dashModeLine;
    xAxis.enabled = YES;
    
    ChartAxisBase* leftYAxis = self.myView.leftYAxis;
    leftYAxis.axisValueFormatter = [[YAxisFormtter alloc] init];
    leftYAxis.drawLabelsEnabled = YES;
    leftYAxis.drawAxisLineEnabled = YES;
    leftYAxis.drawGridLinesEnabled = YES;
    leftYAxis.labelFont = [UIFont systemFontOfSize:11.0];
    leftYAxis.labelTextColor = [UIColor whiteColor];
    leftYAxis.maxLongLabelString = @"100.0";
    leftYAxis.GridLinesMode = dashModeLine;
    leftYAxis.gridColor = [UIColor colorWithColor:[UIColor whiteColor] andalpha:0.25];
    leftYAxis.enabled = YES;
    
    ChartAxisBase* rightYAxis = self.myView.rightYAxis;
    rightYAxis.axisValueFormatter = [[YRightAxisFormtter alloc] init];
    rightYAxis.drawLabelsEnabled = YES;
    rightYAxis.drawAxisLineEnabled = YES;
    rightYAxis.drawGridLinesEnabled = YES;
    rightYAxis.labelFont = [UIFont systemFontOfSize:11.0];
    rightYAxis.labelTextColor = [UIColor whiteColor];
    rightYAxis.maxLongLabelString = @"100.0";
    rightYAxis.GridLinesMode = dashModeLine;
    rightYAxis.gridColor = [UIColor colorWithColor:[UIColor blueColor] andalpha:0.25];;
    rightYAxis.enabled = YES;
    
    //默认选择的highlight
    ChartHighlight* highLight = [[ChartHighlight alloc] init];
    highLight.dataIndex = 5;
    highLight.enabled = YES;
    self.highLightFor = [[HighLightFormatter alloc] init];
    highLight.delegate = self.highLightFor;
    self.myView.hightLight = highLight;
    
    _dataset = [[SLLineChartDataSet alloc] initWithValues:self.tempArray1 label:@"Default"];
    _dataset.lineWidth = 1.0;
    _dataset.mode = curveLineMode;
    _dataset.color = [UIColor greenColor];
    _dataset.circleRadius = 5.0;
    _dataset.circleHoleRadius = 3.0;
    _dataset.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
    _dataset.drawCircleHoleEnabled = YES;
    _dataset.drawCirclesEnabled = YES;
    _dataset.drawCirclesEnabled = YES;
    [self.myView setScaleXEnabled:@(YES)];
    [self.myView setDynamicYAixs:@(NO)];
    [self.myView setBaseYValueFromZero:@(YES)];
    
    //设置的时候务必保证  VisibleXRangeDefaultmum 落在 VisibleXRangeMinimum 和 VisibleXRangeMaximum 否则将导致缩放功能不可用
    [self.myView setVisibleXRangeMaximum:@(50)];
    [self.myView setVisibleXRangeMinimum:@(2)];
    [self.myView setVisibleXRangeDefaultmum:@(10)];
    //直接调用Set方法和refreashDataSourceRestoreContext 和该方法等效
    [self.myView refreashDataSourceRestoreContext:_dataset];
}

-(NSMutableArray*) tempArray0{
    if (_tempArray0 == nil) {
        _tempArray0 = [NSMutableArray arrayWithCapacity:1];
        for (int i = 0; i < 200; i++) {
            int temp = arc4random()%100 + 1;
            if (i < 20) {
                temp = arc4random()%50 + 1;
            }
            ChartDataEntry* entry = [[ChartDataEntry alloc] initWithX:i y:temp];
            [_tempArray0 addObject:entry];
        }
    }
    return _tempArray0;
}

-(NSMutableArray*) tempArray1{
    if (_tempArray1 == nil) {
        _tempArray1 = [NSMutableArray arrayWithCapacity:1];
        for (int i = 0; i < 200; i++) {
            int temp = arc4random()%100 + 1;
            if (i < 20) {
                temp = arc4random()%50 + 1;
            }
            ChartDataEntry* entry = [[ChartDataEntry alloc] initWithX:i y:temp];
            [_tempArray1 addObject:entry];
        }
    }
    return _tempArray1;
}

#pragma mark - 按键处理
- (IBAction)enableXscaleClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.myView setScaleXEnabled:@(NO)];
    }else{
        [self.myView setScaleXEnabled:@(YES)];
    }
}

- (IBAction)enableDynamicYAxisClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.myView setDynamicYAixs:@(YES)];
    }else{
        [self.myView setDynamicYAixs:@(NO)];
    }
}

- (IBAction)hiddenLeftYAxisClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.myView.leftYAxis.enabled = NO;
        [self.myView refreashDataSourceRestoreContext:self.dataset];
    }else{
        self.myView.leftYAxis.enabled = YES;
        [self.myView refreashDataSourceRestoreContext:self.dataset];
    }
}

- (IBAction)hiddenRightAxisClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.myView.rightYAxis.enabled = NO;
        [self.myView refreashDataSourceRestoreContext:self.dataset];
    }else{
        self.myView.rightYAxis.enabled = YES;
        [self.myView refreashDataSourceRestoreContext:self.dataset];
    }
}

- (IBAction)hiddenXAxisClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.myView.XAxis.enabled = NO;
        [self.myView refreashDataSourceRestoreContext:self.dataset];
    }else{
        self.myView.XAxis.enabled = YES;
        [self.myView refreashDataSourceRestoreContext:self.dataset];
    }
}

- (IBAction) curveOrStrightClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _dataset.mode = brokenLineMode;
    }else{
        _dataset.mode = curveLineMode;
    }
    [self.myView refreashGraph];
}




@end
