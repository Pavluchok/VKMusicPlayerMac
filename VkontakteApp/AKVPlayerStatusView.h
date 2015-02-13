//
//  AKVPlayerView.h
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 11/28/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol AKVPlayerViewDelegate <NSObject>

- (void)didSelectPlayButton;
- (void)didSelectPreviousTrackButton;
- (void)didSelectNextTrackButton;

@end

@interface AKVPlayerStatusView : NSView

@property (nonatomic ,weak) id<AKVPlayerViewDelegate>delegate;

- (instancetype)initPlayerView;

@end
