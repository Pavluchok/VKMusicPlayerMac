//
//  AKVVKAuthorizationManager.m
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 11/10/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import "AKVVKAuthorizationManager.h"
#import <WebKit/WebKit.h>
#import "AKVAudioTrack.h"

static NSString *const kGetAutorizationTokenURLFormatString = @"https://oauth.vk.com/authorize?client_id=%@&scope=%@&display=page&v=5.26&response_type=token";

static NSString *const kAccessTokenKey = @"access_token";
static NSString *const kUserIdKey = @"user_id";

@interface AKVVKAuthorizationManager ()

@property (nonatomic, strong) NSViewController *parentVC;
@property (nonatomic, strong) WebView *webView;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) AKVKAuthorizationCompletion completionBlock;

@end

@implementation AKVVKAuthorizationManager

+ (instancetype)sharedVKManager
{
    
    static dispatch_once_t predicate;
    static AKVVKAuthorizationManager *manager;
    
    dispatch_once(&predicate, ^{
        manager = [AKVVKAuthorizationManager new];
    });
    
    return manager;
}


- (void)sendMessageToSelfWithCompletion:(void(^)(BOOL completion, NSError *error))completion
{
    NSString *strForSendMessaqge = [NSString stringWithFormat:@"https://api.vk.com/method/messages.send?user_id=29288617&v=5.26&message=dsfa&access_token=%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:kAccessTokenKey]];
    NSURL *sendMessageURL = [NSURL URLWithString:strForSendMessaqge];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:sendMessageURL]
                                       queue:[NSOperationQueue new]
                           completionHandler:^(NSURLResponse * response, NSData *data, NSError *error){
                               
                               NSLog(@"%@", [[NSString alloc]initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding]);
                               NSLog(@"%@", [error description]);
    }];
    
    
}

- (void)authorizationViewWithVC:(NSViewController *)controller
                     completion:(AKVKAuthorizationCompletion)completion
{
    if (!controller)
    {
        return;
    }
    
    [self setParentVC:controller];
    
    [self setupAuthorizationView];
    
    NSString *stringForURL = [NSString stringWithFormat:kGetAutorizationTokenURLFormatString, clientId, @"messages,audio,friends"];
    
    NSLog(@"%@", stringForURL);
    
    [_webView setResourceLoadDelegate:self];
    
    [_webView setMainFrameURL:stringForURL];
    
    [[_webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:stringForURL]]];
    
    _completionBlock = completion;
}

- (BOOL)isSessionEnabled
{
    BOOL sessionAviable = ([[NSUserDefaults standardUserDefaults] objectForKey:kAccessTokenKey] != nil) &&
        ([[NSUserDefaults standardUserDefaults] objectForKey:kUserIdKey] != nil);
    if (sessionAviable) {
        self.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessTokenKey];
        self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserIdKey];
    }
    return sessionAviable;
}

- (NSURLRequest *)webView:(WebView *)sender
                 resource:(id)identifier
          willSendRequest:(NSURLRequest *)request
         redirectResponse:(NSURLResponse *)redirectResponse
           fromDataSource:(WebDataSource *)dataSource
{
    NSLog(@"@%@", [[request URL]absoluteString]);
    
    
    
    
    NSString *urlString = [[request URL]absoluteString];
    
    if ([urlString rangeOfString:@"#access_token="].location != NSNotFound)
    {
        NSRange beginToken = [urlString rangeOfString:@"#access_token="];
        NSRange endToken = [urlString rangeOfString:@"&"];
        NSRange endRange = NSMakeRange(NSMaxRange(beginToken), endToken.location - NSMaxRange(beginToken));
        
        NSString *accessToken = [urlString substringWithRange:endRange];
        
        NSRange beginUserId = [urlString rangeOfString:@"&user_id="];
        NSString *userId = [urlString substringWithRange:NSMakeRange(NSMaxRange(beginUserId), urlString.length - NSMaxRange(beginUserId))];
        userId = [[userId componentsSeparatedByString:@"&"] objectAtIndex:0];
                                                                     
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kAccessTokenKey];
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kUserIdKey];
        [self setAccessToken:accessToken];
        [self setUserId:userId];
        [_webView removeFromSuperview];
        [self setWebView:nil];
        
        _completionBlock(YES, nil);
        _completionBlock = nil;
    }
    
    return request;
}

- (void)setupAuthorizationView
{
    NSWindow * newWindows = [[NSApplication sharedApplication]windows][0];
    NSRect webViewFrame = [newWindows.contentView bounds];
    
    _webView = [[WebView alloc]initWithFrame:webViewFrame];
    
    [_parentVC.view addSubview:_webView];
}

- (void)loadAudioWithCompletion:(void (^)(NSArray *, NSError *))completion
{
    NSString *strForAudio = [NSString stringWithFormat:@"https://api.vk.com/method/audio.get?user_id=%@&v=5.26&access_token=%@",
                             _userId,
                             _accessToken];
    NSURL *audioURL = [NSURL URLWithString:strForAudio];
    
    BLOCK_WEAK_SELF weakRef = self;
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:audioURL]
                                       queue:[NSOperationQueue new]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               BLOCK_STRONG_SELF strongRef = weakRef;
                               NSLog(@"%@", [[NSString alloc]initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding]);
                               NSArray *parseData;
                               if (error == nil)
                               {
                                   NSError *authorizationError = nil;
                                   parseData = [strongRef parseAudioTrackData:data error:&authorizationError];
                                   
                                   if(authorizationError)
                                   {
                                       [[NSUserDefaults standardUserDefaults]removeObjectForKey:kAccessTokenKey];
                                       error = authorizationError;
                                   }
                               }
                               
                               
                               completion(parseData, error);
                           }];
}

- (NSArray *)parseAudioTrackData:(NSData *)tracks error:(NSError **)error
{
    NSError *parsingError = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:tracks
                                                        options:NSJSONReadingMutableContainers
                                                          error:&parsingError];
    
    if (dic[@"error"])
    {
        *error = [NSError errorWithDomain:@"ParseError"
                                     code:[dic[@"error"][@"error_code"] intValue]
                                 userInfo:@{@"description":dic[@"error"]}];
        
        return nil;
    }
    
    NSMutableArray *audioTracks = nil;
    
    if (parsingError == nil) {
    
        audioTracks = [[NSMutableArray alloc]initWithCapacity:[dic[@"response"][@"count"] intValue]];
        
        for (NSDictionary *audio in dic[@"response"][@"items"])
        {
            AKVAudioTrack *track = [AKVAudioTrack new];
            [track setArtist:audio[@"artist"]];
            [track setDuration:[audio[@"duration"] intValue]];
            [track setGenre_id:audio[@"genre_id"]];
            [track setIdentifier:audio[@"id"]];
            [track setTitle:audio[@"title"]];
            [track setUrl:audio[@"url"]];
            
            [audioTracks addObject:track];
        }
    }
    
    return audioTracks;
}

@end
