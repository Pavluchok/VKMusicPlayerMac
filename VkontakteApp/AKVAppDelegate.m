//
//  AKVAppDelegate.m
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 11/6/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import "AKVAppDelegate.h"
#import "AKVMainViewController.h"

@interface AKVAppDelegate ()

@property (nonatomic, strong) AKVMainViewController *mainVC;

@end

@implementation AKVAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _mainVC = [[AKVMainViewController alloc]initWithNibName:@"MainView" bundle:nil];
    _mainVC.view.frame = ((NSView*)self.window.contentView).bounds;
    [_window.contentView addSubview:_mainVC.view];
    // Insert code here to initialize your application
}

@end
