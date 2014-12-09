//
//  AKVAudioPlayer.m
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 11/28/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import "AKVAudioPlayer.h"
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import "AKVAudioTrack.h"
#import "AKVPlayerStatusView.h"

@interface AKVAudioPlayer ()
{
    NSStatusItem *statusItem;
    id playbackObserver;
}
@property (nonatomic, strong) AVPlayer *audioPlayer;
@property (nonatomic, strong) AKVPlayerStatusView *playerView;

@end

@implementation AKVAudioPlayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _audioPlayer = [AVPlayer new];
        [self setupStatusItem];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(itemDidFinishPlaying:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];
        
        
    }
    return self;
}

- (void)setupStatusItem
{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _playerView = [[AKVPlayerStatusView alloc]initPlayerView];
    [statusItem setView:_playerView];
}

- (void)playAudioTrack:(AKVAudioTrack *)track
{
    NSURL *trackURL = [NSURL URLWithString:track.url];
    
    if (playbackObserver)
    {
        [self.audioPlayer removeTimeObserver:playbackObserver];
    }
    
    self.audioPlayer = [AVPlayer playerWithURL:trackURL];
    [self.audioPlayer play];
    
    BLOCK_WEAK_SELF weakRef = self;
    
    playbackObserver = [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)//interval
                                                                      queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
                                                                 usingBlock: ^(CMTime time)
    {
        BLOCK_STRONG_SELF strong = weakRef;
        if ([strong.delegate respondsToSelector:@selector(playToTime:)])
        {
            [strong.delegate playToTime:(NSInteger)CMTimeGetSeconds(time)];
        }
     }];
}

-(void)itemDidFinishPlaying:(NSNotification *) notification
{
    [self.audioPlayer pause];
    [self.audioPlayer removeTimeObserver:playbackObserver];
    
    if ([self.delegate respondsToSelector:@selector(didFinishPlayingWithAudioPlayer:)])
    {
        [self.delegate didFinishPlayingWithAudioPlayer:self];
    }
}

- (void)rewindToTime:(NSInteger)time
{
    CMTime newTime = CMTimeMakeWithSeconds(time, 1);
    [self.audioPlayer seekToTime:newTime];
}

@end
