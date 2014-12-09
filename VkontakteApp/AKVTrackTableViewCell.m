//
//  AKVTrackTableViewCell.m
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 12/1/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import "AKVTrackTableViewCell.h"

@interface AKVTrackTableViewCell ()
{
    NSTimer *updateTimer;
}

@property (nonatomic, weak) IBOutlet NSSlider *timeSlider;
@property (nonatomic, weak) IBOutlet NSTextField *timeLabel;
@property (nonatomic, weak) IBOutlet NSButton *playButton;
@property (nonatomic, weak) id target;

@end

@implementation AKVTrackTableViewCell

- (void)resizeSubviewsWithOldSize:(NSSize)oldSize
{
    [self.timeLabel setStringValue:[self timeFormatted:self.duration]];
    [self.timeSlider setMaxValue:self.duration];
    [self.playButton setTarget:self];
    [self.playButton setAction:@selector(pressPlay:)];
   
    [super resizeSubviewsWithOldSize:oldSize];
}


- (void)pressPlay:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(trackCell:pressPlayControl:)])
    {
        [self.delegate trackCell:self pressPlayControl:sender];
//        updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateInterface) userInfo:nil repeats:YES];
    }
}

- (void)updateInterface
{
    NSInteger time = [self.timeSlider integerValue];
    [self.timeLabel setStringValue:[self timeFormatted:time]];
    [self.timeSlider setIntegerValue:++time];
}

- (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

- (IBAction)sliderValueChanged:(NSSlider *)sender {
    NSLog(@"%d", sender.intValue);
    [self.timeLabel setStringValue:[self timeFormatted:sender.intValue]];
    
    if ([self.delegate respondsToSelector:@selector(trackCell:rewindTrackToTime:)])
    {
        [self.delegate trackCell:self rewindTrackToTime:sender.integerValue];
    }
}

- (void)setCurrentDuration:(NSInteger)currentDuration
{
    [self.timeLabel setStringValue:[self timeFormatted:currentDuration]];
    [self.timeSlider setIntegerValue:currentDuration];
}

@end
