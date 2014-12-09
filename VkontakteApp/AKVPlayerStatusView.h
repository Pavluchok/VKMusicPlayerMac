//
//  AKVPlayerView.h
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 11/28/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import "AKVPlayerView.h"

@interface AKVPlayerStatusView : NSView

@property (nonatomic ,weak) id<AKVPlayerViewDelegate>delegate;

- (instancetype)initPlayerView;

@end
