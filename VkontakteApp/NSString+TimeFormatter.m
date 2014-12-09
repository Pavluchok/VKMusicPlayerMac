//
//  NSString+TimeFormatter.m
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 12/5/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import "NSString+TimeFormatter.h"

@implementation NSString (TimeFormatter)

+ (NSString *)timeStringWithTime:(NSUInteger)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

@end
