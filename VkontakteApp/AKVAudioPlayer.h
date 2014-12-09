//
//  AKVAudioPlayer.h
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 11/28/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AKVAudioTrack, AKVAudioPlayer;

@protocol AKVAudioPlayerDelegate <NSObject>

- (void)didFinishPlayingWithAudioPlayer:(AKVAudioPlayer *)player;
- (void)playToTime:(NSInteger)time;

@end

@interface AKVAudioPlayer : NSObject

@property (nonatomic, weak) id<AKVAudioPlayerDelegate>delegate;

- (void)playAudioTrack:(AKVAudioTrack *)track;
- (void)rewindToTime:(NSInteger)time;

@end
