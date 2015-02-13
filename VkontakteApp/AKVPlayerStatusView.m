//
//  AKVPlayerView.m
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 11/28/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import "AKVPlayerStatusView.h"

static CGFloat const kWidthAndHeightPlayerButton = 25.0;

@implementation AKVPlayerStatusView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    
    if (self) {
        [self setupPlayerButton];
    }
    
    return self;
}

- (instancetype)initPlayerView
{
    self = [super init];
    if (self) {
        [self setupPlayerButton];
    }
    return self;
}

- (void)setupPlayerButton
{
    NSRect previousRect = NSMakeRect(0, 0, kWidthAndHeightPlayerButton, kWidthAndHeightPlayerButton);
    
    NSImageView *previousImageView = [[NSImageView alloc]initWithFrame:previousRect];
    [previousImageView setTarget:self];
    [previousImageView setAction:@selector(tapPreviousButton:)];
    
    NSButton *previousButton = [[NSButton alloc]initWithFrame:previousRect];
    [previousButton setTarget:self];
    [previousButton setAction:@selector(tapPreviousButton:)];
    
    NSRect playRect = NSMakeRect(NSMaxX(previousRect), 0, kWidthAndHeightPlayerButton, kWidthAndHeightPlayerButton);
    NSButton *playButton = [[NSButton alloc]initWithFrame:playRect];
    [playButton setTarget:self];
    [playButton setAction:@selector(tapPlayButton:)];
    
    NSRect nextRect = NSMakeRect(NSMaxX(playRect), 0, kWidthAndHeightPlayerButton, kWidthAndHeightPlayerButton);
    NSButton *nextButton = [[NSButton alloc]initWithFrame:nextRect];
    [nextButton setTarget:self];
    [nextButton setAction:@selector(tapNextButton:)];
    
//[self addSubview:previousButton];
    [self addSubview:previousImageView];
    [self addSubview:playButton];
    [self addSubview:nextButton];
    
    [self setFrame:NSMakeRect(0, 0, NSMaxX(nextRect), kWidthAndHeightPlayerButton)];
}

- (void)tapPreviousButton:(NSButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didSelectPreviousTrackButton)])
    {
        [self.delegate didSelectPreviousTrackButton];
    }
}

- (void)tapPlayButton:(NSButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didSelectPlayButton)])
    {
        [self.delegate didSelectPlayButton];
    }

}

- (void)tapNextButton:(NSButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didSelectNextTrackButton)])
    {
        [self.delegate didSelectNextTrackButton];
    }

}


- (void)drawRect:(NSRect)dirtyRect
{
    
}

@end
