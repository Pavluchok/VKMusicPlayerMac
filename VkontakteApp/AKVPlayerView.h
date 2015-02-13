//
//  AKVPlayerView.h
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 12/4/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AKVPlayerView;

@protocol AKVPlayerViewDelegate <NSObject>

- (void)didTapPlayButton:(NSButton *)button;
- (void)didTapNextButton:(NSButton *)button;
- (void)didTapPreviousButton:(NSButton *)button;
- (void)didChangeSlidervalue:(NSInteger)value;

@end

@interface AKVPlayerView : NSView

@property (nonatomic, weak) id<AKVPlayerViewDelegate>delegate;

- (void)updateTrackDuration:(NSUInteger)duration trackName:(NSString *)name;
- (void)updateSliderValue:(NSInteger)value;

@end
