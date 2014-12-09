//
//  NSImage+Rotate.h
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 12/9/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Transform)

- (NSImage *)imageRotate:(float)degrees;
- (NSImage *)resizedImageToSize:(NSSize)size;

@end
