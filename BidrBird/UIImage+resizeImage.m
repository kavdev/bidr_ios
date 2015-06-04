//
//  UIImage+resizeImage.m
//  BidrBird
//
//  Created by Zachary Glazer on 5/14/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import "UIImage+resizeImage.h"

@implementation UIImage (resizeImage)

/**
 * Creates a resized, autoreleased copy of the image, with the given dimensions.
 * @return an autoreleased, resized copy of the image
 */
//code from http://vladimir.zardina.org/2010/05/resizing-uiimage-objects/
- (UIImage*) resizedImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    // An autoreleased image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end