//
//  AKVAudioTrack+TableRepresentation.m
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 12/4/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import "AKVAudioTrack+TableRepresentation.h"

@implementation AKVAudioTrack (TableRepresentation)

- (NSInteger)leftTime
{
    return self.duration - self.currentDuration;
}

@end
