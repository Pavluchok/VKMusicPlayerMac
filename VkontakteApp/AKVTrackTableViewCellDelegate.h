//
//  AKVTrackTableViewCellDelegate.h
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 12/2/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AKVTrackTableViewCell;

@protocol AKVTrackTableViewCellDelegate <NSObject>

- (void)trackCell:(AKVTrackTableViewCell *)cell rewindTrackToTime:(NSInteger)time;
- (void)trackCell:(AKVTrackTableViewCell *)cell pressPlayControl:(NSColor *)control;

@end
