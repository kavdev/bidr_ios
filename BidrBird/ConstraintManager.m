//
//  ConstraintManager.m
//  BidrBird
//
//  Created by Zachary Glazer on 11/21/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "ConstraintManager.h"

@implementation ConstraintManager 

+ (void) setHorDistancePercent:(CGFloat)percent forView:(id)view1 inView:(id)view2 plusConstant:(int)constant {
   NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeCenterX multiplier:2.0 * percent constant:constant];
   [view2 addConstraint:xConstraint];
}

+ (void) setVertDistancePercent:(CGFloat)percent forView:(id)view1 inView:(id)view2 plusConstant:(int)constant {
   NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeCenterY multiplier:2.0 * percent constant:constant];
   [view2 addConstraint:yConstraint];
}

+ (void) setWidthPercent:(CGFloat)percent forView:(id)view1 inView:(id)view2 plusConstant:(int)constant{
   NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeWidth multiplier:percent constant:constant];
   
   [view2 addConstraint:width];
}

+ (void) setHeightPercent:(CGFloat)percent forView:(id)view1 inView:(id)view2 plusConstant:(int)constant{
   NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeHeight multiplier:percent constant:constant];
   
   [view2 addConstraint:height];
}

+ (void) setHeight:(int)constant forView:(id)view {
   NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:constant];
   
   [view addConstraint:height];
}

+ (void) setWidth:(int)constant forView:(id)view {
   NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:constant];
   
   [view addConstraint:width];
}

+ (void) setTopDistance:(int)constant forView:(id)view1 inView:(id)view2 {
   NSLayoutConstraint *topDistance = [NSLayoutConstraint constraintWithItem:view1
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view2
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:0
                                                                   constant:constant];
   [view2 addConstraint:topDistance];
}

+ (void) setLeftDistance:(int)constant forView:(id)view1 inView:(id)view2 {
   NSLayoutConstraint *leftDistance = [NSLayoutConstraint constraintWithItem:view1
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view2
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:0
                                                                   constant:constant];
   [view2 addConstraint:leftDistance];
}

+ (void) setRightDistance:(int)constant forView:(id)view1 inView:(id)view2 {
   NSLayoutConstraint *rightDistance = [NSLayoutConstraint constraintWithItem:view1
                                                                  attribute:NSLayoutAttributeRight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view2
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:0
                                                                   constant:constant * -1];
   [view2 addConstraint:rightDistance];
}

+ (void) setBottomDistance:(int)constant forView:(id)view1 inView:(id)view2 {
   NSLayoutConstraint *bottomDistance = [NSLayoutConstraint constraintWithItem:view1
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view2
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:0
                                                                   constant:constant * -1];
   [view2 addConstraint:bottomDistance];
}

+ (void) setLeftDistance:(int)constant forView:(id)view1 fromView:(id)view2 inView:(id)superView {
   NSLayoutConstraint *distance = [NSLayoutConstraint constraintWithItem:view1
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view2
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1
                                                                   constant:constant];
   [superView addConstraint:distance];
}

+ (void) setRightDistance:(int)constant forView:(id)view1 fromView:(id)view2 inView:(id)superView {
   NSLayoutConstraint *distance = [NSLayoutConstraint constraintWithItem:view1
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:view2
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:-constant];
   [superView addConstraint:distance];
}

+ (void) setTopDistance:(int)constant forView:(id)view1 fromView:(id)view2 inView:(id)superView {
   NSLayoutConstraint *topDistance = [NSLayoutConstraint constraintWithItem:view1
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view2
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1
                                                                   constant:constant];
   [superView addConstraint:topDistance];
}

+ (void) setBottomDistance:(int)constant forView:(id)view1 fromView:(id)view2 inView:(id)superView {
   NSLayoutConstraint *topDistance = [NSLayoutConstraint constraintWithItem:view1
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view2
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1
                                                                   constant:-constant];
   [superView addConstraint:topDistance];
}

//+ (void) setLeadingDistance:(int)constant forView:(id)view1 inView:(id)view2 {
//   NSLayoutConstraint *leadingDistance = [NSLayoutConstraint constraintWithItem:view1
//                                                                   attribute:NSLayoutAttributeLeading
//                                                                   relatedBy:NSLayoutRelationEqual
//                                                                      toItem:view2
//                                                                   attribute:NSLayoutAttributeLeading
//                                                                  multiplier:0
//                                                                    constant:constant];
//   [view2 addConstraint:leadingDistance];
//}
//
//+ (void) setTrailingDistance:(int)constant forView:(id)view1 inView:(id)view2 {
//   NSLayoutConstraint *trailingDistance = [NSLayoutConstraint constraintWithItem:view1
//                                                                      attribute:NSLayoutAttributeTrailing
//                                                                      relatedBy:NSLayoutRelationEqual
//                                                                         toItem:view2
//                                                                      attribute:NSLayoutAttributeTrailing
//                                                                     multiplier:0
//                                                                       constant:constant];
//   [view2 addConstraint:trailingDistance];
//}

@end