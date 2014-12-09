//
//  AKVTracksTableView.h
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 12/1/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AKVTracksTableView : NSTableView

- (NSIndexPath *)indexPathPlayingRow;
- (NSUInteger)nextTrack;
- (NSUInteger)previousTrack;
- (NSUInteger)currentTrack;
- (void)selectedRowWithIndex:(NSInteger)index;

@end

