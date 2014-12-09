//
//  AKVTrackTableViewCell.h
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 12/1/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AKVTrackTableViewCellDelegate.h"

@interface AKVTrackTableViewCell : NSTableCellView

@property (nonatomic,weak) id <AKVTrackTableViewCellDelegate>delegate;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger currentDuration;

@end
