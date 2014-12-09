//
//  AKVTracksTableView.m
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 12/1/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import "AKVTracksTableView.h"
#import "AKVTrackTableViewCell.h"

@interface AKVTracksTableView () 

@property (nonatomic, assign) NSUInteger playingIndex;

@end

@implementation AKVTracksTableView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _playingIndex = 0;
    }
    return self;
}

- (NSIndexPath *)indexPathPlayingRow
{
    return [NSIndexPath indexPathWithIndex:0];
}

- (NSUInteger)nextTrack
{
    [super deselectRow:self.playingIndex];
    
    if ((self.playingIndex+1) < [super numberOfRows])
    {
        self.playingIndex++;
    }
    else
    {
        self.playingIndex = 0;
    }
 
    [super selectRowIndexes:[[NSIndexSet alloc]initWithIndex:self.playingIndex] byExtendingSelection:extend];
    return self.playingIndex;
}

- (NSUInteger)previousTrack
{
    [super deselectRow:self.playingIndex];
    
    if (self.playingIndex != 0)
    {
        self.playingIndex--;
    }
    else
    {
        self.playingIndex = ([super numberOfRows]-1);
    }
    
    [super selectRowIndexes:[[NSIndexSet alloc]initWithIndex:self.playingIndex] byExtendingSelection:extend];
    
    return self.playingIndex;
}

- (NSUInteger)currentTrack
{
    return self.playingIndex;
}

- (void)selectRowIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extend
{
    if ([super isRowSelected:self.playingIndex])
    {
        [super deselectRow:self.playingIndex];
    }
    self.playingIndex = indexes.firstIndex;

    //AKVTracksTableView *currentCell = [self ]
    
    //[super selectRowIndexes:indexes byExtendingSelection:extend];
}

- (void)selectedRowWithIndex:(NSInteger)index
{
    
    if ([super isRowSelected:self.playingIndex])
    {
        [super deselectRow:self.playingIndex];
    }
    
    self.playingIndex = index;
    
    [super selectRowIndexes:[[NSIndexSet alloc]initWithIndex:self.playingIndex] byExtendingSelection:NO];
}

@end
