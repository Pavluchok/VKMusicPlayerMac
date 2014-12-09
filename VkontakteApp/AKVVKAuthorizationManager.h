//
//  AKVVKAuthorizationManager.h
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 11/10/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKVAuthorizationConfig.h"

typedef void(^AKVKAuthorizationCompletion)(BOOL status, NSError *error);

@interface AKVVKAuthorizationManager : NSObject 

+ (instancetype)sharedVKManager;

- (BOOL)isSessionEnabled;

//- (void)sendMessageToSelfWithCompletion:(void(^)(BOOL completion, NSError *error))completion;

- (void)authorizationViewWithVC:(NSViewController *)controller
                     completion:(AKVKAuthorizationCompletion) completion;
- (void)loadAudioWithCompletion:(void (^)(NSArray *, NSError *))completion;
- (void)loadRecommendationAudioWithCompletion:(void (^)(NSArray *, NSError *))completion;

@end