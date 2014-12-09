//
//  AKVPlayerView.m
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 11/28/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import "AKVPlayerStatusView.h"
#import "NSImage+Transform.h"

static CGFloat const kWidthAndHeightPlayerButton = 20.0;

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
    
    NSImage *nextSongImage = [[NSImage imageNamed:@"NextSong"]resizedImageToSize:previousRect.size];
    
    NSButton *previousButton = [[NSButton alloc]initWithFrame:previousRect];
    [previousButton setTarget:self];
    [previousButton setAction:@selector(tapPreviousButton:)];
    [previousButton setBordered:NO];
    [previousButton setImage:[nextSongImage imageRotate:180.0]];
    
    NSRect playRect = NSMakeRect(NSMaxX(previousRect), 0, kWidthAndHeightPlayerButton, kWidthAndHeightPlayerButton);
    NSButton *playButton = [[NSButton alloc]initWithFrame:playRect];
    [playButton setTarget:self];
    [playButton setAction:@selector(tapPlayButton:)];
    [playButton setBordered:NO];
    [playButton setImage:[[NSImage imageNamed:@"PlayButton"]resizedImageToSize:playRect.size]];
    
    NSRect nextRect = NSMakeRect(NSMaxX(playRect), 0, kWidthAndHeightPlayerButton, kWidthAndHeightPlayerButton);
    NSButton *nextButton = [[NSButton alloc]initWithFrame:nextRect];
    [nextButton setTarget:self];
    [nextButton setAction:@selector(tapNextButton:)];
    [nextButton setBordered:NO];
    [nextButton setImage:nextSongImage];
    
    [self addSubview:previousButton];
    [self addSubview:playButton];
    [self addSubview:nextButton];
    
    [self setFrame:NSMakeRect(0, 1, NSMaxX(nextRect), kWidthAndHeightPlayerButton)];
}

- (void)tapPreviousButton:(NSButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didTapPreviousButton:)])
    {
        [self.delegate didTapPreviousButton:button];
    }
}

- (void)tapPlayButton:(NSButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didTapPlayButton:)])
    {
        [self.delegate didTapPlayButton:button];
    }
}

- (void)tapNextButton:(NSButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didTapNextButton:)])
    {
        [self.delegate didTapNextButton:button];
    }
}


- (void)drawRect:(NSRect)dirtyRect
{
    
}

@end
