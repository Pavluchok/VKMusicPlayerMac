//
//  AKVPlayerView.m
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 12/4/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import "AKVPlayerView.h"
#import "NSString+TimeFormatter.h"
#import "NSImage+Rotate.h"

static CGFloat const kButtonSideValue = 30.0f;

@interface AKVPlayerView ()

@property (nonatomic, strong) NSTextView *timeLabel;
@property (nonatomic, strong) NSTextView *trackNameLabel;

@property (nonatomic, strong) NSSlider *timeSlider;

@property (nonatomic, strong) NSButton *previousButton;
@property (nonatomic, strong) NSButton *playButton;
@property (nonatomic, strong) NSButton *nextButton;

@property (nonatomic, assign) NSUInteger trackDuration;

@end

@implementation AKVPlayerView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];

    if (self)
    {
        [self setupPlayerView];
        _trackDuration = 0;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        
    }
    
    return self;
}

#pragma mark - instance methods

- (void)updateTrackDuration:(NSUInteger)duration trackName:(NSString *)name
{
    [self.timeLabel setString:[NSString timeStringWithTime:duration]];
    [self.trackNameLabel setString:name];
    [self.timeSlider setMaxValue:duration];
    self.trackDuration = duration;
}

- (void)updateSliderValue:(NSInteger)value
{
    [self.timeLabel setString:[NSString timeStringWithTime:value]];
    [self.timeSlider setIntegerValue:value];
}

#pragma mark -

- (void)setupPlayerView
{
    NSRect playButtonFrame = NSMakeRect(15, kButtonSideValue, kButtonSideValue, kButtonSideValue);
    NSButton *playButton = [[NSButton alloc]initWithFrame:playButtonFrame];
    [playButton setTarget:self];
    [playButton setAction:@selector(tapPlayButton:)];
    [playButton setBordered:NO];
    [playButton setImage:[self resizedImageWithName:@"PlayButton" toSize:playButtonFrame.size]];
    [self addSubview:playButton];
    
    [self setPlayButton:playButton];
    
    NSRect previousButtonFrame =  NSMakeRect(NSMaxX(playButtonFrame), kButtonSideValue, kButtonSideValue, kButtonSideValue);
    NSButton *previousButton = [[NSButton alloc] initWithFrame:previousButtonFrame];
    [previousButton setTarget:self];
    [previousButton setAction:@selector(tapPreviousButton:)];
    [previousButton setBordered:NO];
    [previousButton setImage:[[self resizedImageWithName:@"NextSong" toSize:previousButtonFrame.size] imageRotated:180]];
    [self addSubview:previousButton];
    
    [self setPreviousButton:previousButton];
    
    NSRect nextButtonFrame = NSMakeRect(NSMaxX(previousButtonFrame), kButtonSideValue, kButtonSideValue, kButtonSideValue);
    NSButton *nextButton = [[NSButton alloc]initWithFrame:nextButtonFrame];
    [nextButton setAction:@selector(tapNextButton:)];
    [nextButton setTarget:self];
    [nextButton setBordered:NO];
    [nextButton setImage:[self resizedImageWithName:@"NextSong" toSize:nextButtonFrame.size]];
    [self addSubview:nextButton];
    
    [self setNextButton:nextButton];
    
    NSRect sliderFrame = NSMakeRect(NSMinX(playButtonFrame), 0, self.bounds.size.width - NSMinX(playButtonFrame)*2, kButtonSideValue);
    NSSlider *slider = [[NSSlider alloc]initWithFrame:sliderFrame];
    [slider setMinValue:0];
    [slider setAction:@selector(changeSliderValue:)];
    [slider setTarget:self];
    [self addSubview:slider];

    [self setTimeSlider:slider];

    NSRect timeFrame = NSMakeRect(self.bounds.size.width - (kButtonSideValue +15), kButtonSideValue, kButtonSideValue*2, kButtonSideValue);
    NSTextView *timeLabel = [[NSTextView alloc] initWithFrame:timeFrame];
    [timeLabel setString:@"00:00"];
    [timeLabel setBackgroundColor:[NSColor clearColor]];
    [self addSubview:timeLabel];
    
    [self setTimeLabel:timeLabel];
    
    CGFloat trackTitleWidth = NSMinX(timeFrame) - NSMaxX(nextButtonFrame);
    NSRect trackNameFrame = NSMakeRect(NSMaxX(nextButtonFrame),
                                       kButtonSideValue,
                                       trackTitleWidth,
                                       kButtonSideValue);
    NSTextView *trackNameTitle = [[NSTextView alloc]initWithFrame:trackNameFrame];
    [trackNameTitle setBackgroundColor:[NSColor clearColor]];
    [self addSubview:trackNameTitle];
    
    [self setTrackNameLabel:trackNameTitle];
}

- (void)changeSliderValue:(NSSlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(didChangeSlidervalue:)])
    {
        [self.delegate didChangeSlidervalue:[slider integerValue]];
    }
}

- (void)tapPreviousButton:(NSButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didTapPlayButton:)])
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
    if ([self.delegate respondsToSelector:@selector(didTapPlayButton:)])
    {
        [self.delegate didTapNextButton:button];
    }
}

#pragma mark - helper methods

- (NSImage *)resizedImageWithName:(NSString *)name toSize:(NSSize)size
{
    NSImage *resizeImage = [NSImage imageNamed:name];
    [resizeImage setScalesWhenResized:YES];
    
    if (![resizeImage isValid])
    {
        NSLog(@"ERROR!!! INVALID IMAGE");
        return nil;
    }
    
    NSImage *smallImage = [[NSImage alloc]initWithSize:size];
    [smallImage lockFocus];
    [resizeImage setSize:size];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [resizeImage drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    [smallImage unlockFocus];
    
    return smallImage;
}

@end
