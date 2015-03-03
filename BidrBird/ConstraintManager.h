//
//  ConstraintManager.h
//  BidrBird
//
//  Created by Zachary Glazer on 11/21/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#ifndef BidrBird_ConstraintManager_h
#define BidrBird_ConstraintManager_h

#import <UIKit/UIKit.h>

@interface ConstraintManager : NSObject

+ (void) setHorDistancePercent:(CGFloat)percent forView:(id)view1 inView:(id)view2 plusConstant:(int)constant;
+ (void) setVertDistancePercent:(CGFloat)percent forView:(id)view1 inView:(id)view2 plusConstant:(int)constant;
+ (void) setWidthPercent:(CGFloat)percent forView:(id)view1 inView:(id)view2 plusConstant:(int)constant;
+ (void) setHeightPercent:(CGFloat)percent forView:(id)view1 inView:(id)view2 plusConstant:(int)constant;
+ (void) setHeight:(int)constant forView:(id)view;
+ (void) setWidth:(int)constant forView:(id)view;
+ (void) setTopDistance:(int)constant forView:(id)view1 inView:(id)view2;
+ (void) setLeftDistance:(int)constant forView:(id)view1 inView:(id)view2;
+ (void) setRightDistance:(int)constant forView:(id)view1 inView:(id)view2;
+ (void) setBottomDistance:(int)constant forView:(id)view1 inView:(id)view2;
+ (void) setRightDistance:(int)constant forView:(id)view1 fromView:(id)view2 inView:(id)superView;
+ (void) setBottomDistance:(int)constant forView:(id)view1 fromView:(id)view2 inView:(id)superView;
+ (void) setLeftDistance:(int)constant forView:(id)view1 fromView:(id)view2 inView:(id)superView;
+ (void) setTopDistance:(int)constant forView:(id)view1 fromView:(id)view2 inView:(id)superView;

//+ (void) setLeadingDistance:(int)constant forView:(id)view1 inView:(id)view2;
//+ (void) setTrailingDistance:(int)constant forView:(id)view1 inView:(id)view2;

@end

#endif
