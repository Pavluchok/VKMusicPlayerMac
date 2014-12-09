//
//  AKVPlayerWindowView.h
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 12/9/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import "AKVPlayerView.h"

@interface AKVPlayerWindowView : AKVPlayerView

- (void)updateTrackDuration:(NSUInteger)duration trackName:(NSString *)name;
- (void)updateSliderValue:(NSInteger)value;

@end
