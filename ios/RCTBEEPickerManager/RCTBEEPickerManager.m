//
//  RCTBEEPickerManager.m
//  RCTBEEPickerManager
//
//  Created by MFHJ-DZ-001-417 on 16/9/6.
//  Copyright © 2016年 MFHJ-DZ-001-417. All rights reserved.
//

#import "RCTBEEPickerManager.h"
#import "BzwPicker.h"
#import <React/RCTEventDispatcher.h>
#import <React/RCTConvert.h>

@interface RCTBEEPickerManager()

@property(nonatomic,strong)BzwPicker *pick;
@property(nonatomic,assign)float height;
@property(nonatomic,weak)UIWindow * window;

@end

@implementation RCTBEEPickerManager

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(_init:(NSDictionary *)indic) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    });
    
    self.window = [UIApplication sharedApplication].keyWindow;
    
    NSString *pickerConfirmBtnText=indic[@"pickerConfirmBtnText"];
    NSString *pickerTitleText=indic[@"pickerTitleText"];
    
    UIColor *pickerConfirmBtnColor=[RCTConvert UIColor:indic[@"pickerConfirmBtnColor"]];
    UIColor *pickerTitleColor=[RCTConvert UIColor:indic[@"pickerTitleColor"]];
    UIColor *pickerToolBarBg=[RCTConvert UIColor:indic[@"pickerToolBarBg"]];
    UIColor *pickerBg=[RCTConvert UIColor:indic[@"pickerBg"]];
    UIColor *pickerFontColor=[RCTConvert UIColor:indic[@"pickerFontColor"]];
    
    NSArray *selectArry=[RCTConvert NSArray:indic[@"selectedValue"]];
    NSArray *weightArry=[RCTConvert NSArray:indic[@"wheelFlex"]];
    NSString *pickerToolBarFontSize=[NSString stringWithFormat:@"%@",indic[@"pickerToolBarFontSize"]];
    NSString *pickerFontSize=[NSString stringWithFormat:@"%@",indic[@"pickerFontSize"]];
    NSString *pickerRowHeight=indic[@"pickerRowHeight"];
    id pickerData=indic[@"pickerData"];
    
    NSMutableDictionary *dataDic=[[NSMutableDictionary alloc]init];
    
    dataDic[@"pickerData"]=pickerData;
    
    [self.window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[BzwPicker class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [obj removeFromSuperview];
            });
        }
        
    }];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0 ) {
        self.height=250;
    }else{
        self.height=220;
    }
    
    self.pick=[[BzwPicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.height)
                                          dic:dataDic
                                   topbgColor:pickerToolBarBg
                                bottombgColor:pickerBg
                              rightbtnbgColor:pickerConfirmBtnColor
                               centerbtnColor:pickerTitleColor
                              pickerFontColor:pickerFontColor
                                    centerStr:pickerTitleText
                                     rightStr:pickerConfirmBtnText
                              selectValueArry:selectArry
                                   weightArry:weightArry
                        pickerToolBarFontSize:pickerToolBarFontSize
                               pickerFontSize:pickerFontSize
                              pickerRowHeight: pickerRowHeight];
    
    _pick.bolock=^(NSDictionary *backinfoArry){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.bridge.eventDispatcher sendAppEventWithName:@"pickerEvent" body:backinfoArry];
        });
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window addSubview:_pick];
    });
    
}

RCT_EXPORT_METHOD(show){
    if (self.pick) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.3 animations:^{
                [_pick setFrame:CGRectMake(0, SCREEN_HEIGHT-self.height, SCREEN_WIDTH, self.height)];
            }];
        });
    }
    return;
}

RCT_EXPORT_METHOD(hide){
    if (self.pick) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.3 animations:^{
                [_pick setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.height)];
            }];
        });
    }
    return;
}

RCT_EXPORT_METHOD(select: (NSArray*)data){
    
    if (self.pick) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _pick.selectValueArry = data;
            [_pick selectRow];
        });
    }
    return;
}

RCT_EXPORT_METHOD(isPickerShow:(RCTResponseSenderBlock)getBack){
    
    if (self.pick) {
        
        CGFloat pickY=_pick.frame.origin.y;
        
        if (pickY==SCREEN_HEIGHT) {
            getBack(@[@YES]);
        }else{
            getBack(@[@NO]);
        }
    }else{
        getBack(@[@"picker不存在"]);
    }
}

@end
