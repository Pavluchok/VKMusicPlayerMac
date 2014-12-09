//
//  AKVAudioTrack.h
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 11/10/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKVAudioTrack : NSObject

@property (nonatomic, strong) NSString *artist;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) NSString *genre_id;
@property (nonatomic, strong) NSString *identifier;
//@property (nonatomic, strong) NSString *lyrics_id;
//@property (nonatomic, strong) NSString *owner_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSInteger currentDuration;

@end
