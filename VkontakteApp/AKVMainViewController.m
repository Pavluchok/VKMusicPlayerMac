//
//  AKVMainViewController.m
//  VkontakteApp
//
//  Created by vitaliy.pavlyuk on 11/10/14.
//  Copyright (c) 2014 vitaliy.pavlyuk. All rights reserved.
//

#import "AKVMainViewController.h"
#import "AKVVKAuthorizationManager.h"
#import "AKVAudioTrack.h"
#import "AKVAudioPlayer.h"
#import "AKVTrackTableViewCell.h"
#import "AKVTracksTableView.h"
#import "AKVTrackTableViewCellDelegate.h"
#import "AKVAudioTrack+TableRepresentation.h"
#import "AKVPlayerView.h"

@interface AKVMainViewController () <NSTableViewDataSource, NSTableViewDelegate, AKVAudioPlayerDelegate, AKVTrackTableViewCellDelegate, AKVPlayerViewDelegate>

@property (nonatomic, weak) IBOutlet AKVTracksTableView *audiosTable;
@property (nonatomic, weak) IBOutlet AKVPlayerView *playerView;
@property (nonatomic, strong) NSArray *tracks;
@property (nonatomic, strong) AKVAudioPlayer *player;

@property (strong, nonatomic) NSStatusItem *statusItem;

@end

@implementation AKVMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _player = [AKVAudioPlayer new];
        [_player setDelegate:self];
        [self checkLogin];
        //[self activateStatusMenu];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupTable];
}

- (void)setupTable
{
    [self.playerView setDelegate:self];
    [self.audiosTable setDelegate:self];
    [self.audiosTable setDataSource:self];
}

- (void)checkLogin
{
    if ([[AKVVKAuthorizationManager sharedVKManager]isSessionEnabled])
    {
        [self reloadTableData];
    }
    else
    {
        AKVVKAuthorizationManager *manager = [AKVVKAuthorizationManager sharedVKManager];
        [manager authorizationViewWithVC:self completion:^(BOOL status, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupTable];
            });
        }];
    }
}

- (void)reloadTableData
{
    BLOCK_WEAK_SELF weakRef = self;
    [[AKVVKAuthorizationManager sharedVKManager] loadAudioWithCompletion:^(NSArray *audioTracks, NSError *error){
        BLOCK_STRONG_SELF strongRef = weakRef;
        if (error == nil && audioTracks != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongRef setTracks:[audioTracks copy]];
                [strongRef.audiosTable reloadData];
            });
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSAlert *alert = [NSAlert alertWithError:error];
                [alert runModal];
                alert = nil;
                [strongRef checkLogin];
            });
        }
        
    }];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    AKVTrackTableViewCell *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    // Since this is a single-column table view, this would not be necessary.
    // But it's a good practice to do it in order by remember it when a table is multicolumn.
    if( [tableColumn.identifier isEqualToString:@"TracksIdentifier"] )
    {
        AKVAudioTrack *track = [_tracks objectAtIndex:row];
//        cellView.imageView.image = bugDoc.thumbImage;
        cellView.textField.stringValue = track.title;
        cellView.duration = track.duration;
        cellView.currentDuration = track.currentDuration;
        cellView.delegate = self;
        return cellView;
    }
    
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _tracks ? [_tracks count] : 0;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)rowIndex
{
    [self.player playAudioTrack:[self.tracks objectAtIndex:rowIndex]];
    return YES;
}


#pragma mark - TrackTableCell delegate

- (void)trackCell:(AKVTrackTableViewCell *)cell rewindTrackToTime:(NSInteger)time
{
    if ([self.audiosTable selectedRow] ==  [self.audiosTable rowForView:cell])
    {
        [self.player rewindToTime:time];
    }
}

- (void)trackCell:(AKVTrackTableViewCell *)cell pressPlayControl:(NSColor *)control
{
    NSInteger cellIdentifier = [self.audiosTable rowForView:cell];
    [self.audiosTable selectedRowWithIndex:cellIdentifier];
    [self.player playAudioTrack:[self.tracks objectAtIndex:cellIdentifier]];
}

#pragma mark - AudioPlayer delegate

- (void)didFinishPlayingWithAudioPlayer:(AKVAudioPlayer *)player
{
     [self updatePlayingTrackWithIndex:[self.audiosTable nextTrack]];
}

- (void)playToTime:(NSInteger)time
{
    NSInteger currentIndex = self.audiosTable.currentTrack;
    
    AKVAudioTrack *currentTrack = self.tracks[currentIndex];
    if (currentTrack.duration == time)
    {
        [currentTrack setCurrentDuration:0];
    }
    else
    {
        [currentTrack setCurrentDuration:time];
    }
    
    NSInteger columnIndex = [self.audiosTable columnWithIdentifier:@"TracksIdentifier"];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.playerView updateSliderValue:time];
        [self.audiosTable reloadDataForRowIndexes:[[NSIndexSet alloc] initWithIndex:(NSUInteger)self.audiosTable.selectedRow] columnIndexes:[[NSIndexSet alloc] initWithIndex:0]];
    });
}

#pragma mark - Player View delegate

- (void)didTapPlayButton:(NSButton *)button
{
    [self updatePlayingTrackWithIndex:[self.audiosTable currentTrack]];
}

- (void)didTapNextButton:(NSButton *)button
{
    [self updatePlayingTrackWithIndex:[self.audiosTable nextTrack]];
}

- (void)didTapPreviousButton:(NSButton *)button
{
    [self updatePlayingTrackWithIndex:[self.audiosTable previousTrack]];
}

- (void)didChangeSlidervalue:(NSInteger)time
{
    [self.player rewindToTime:time];
}

#pragma mark - Helper methods

- (void)updatePlayingTrackWithIndex:(NSInteger)index
{
    AKVAudioTrack *currentTrack = self.tracks[index];
    [self.player playAudioTrack:currentTrack];
    [self.playerView updateTrackDuration:currentTrack.duration trackName:currentTrack.title];
}

- (void)restoreCurrentRow
{
    if ([self.tracks count] > 0)
    {
        NSInteger currentIndex = self.audiosTable.selectedRow;
        AKVAudioTrack *currentTrack = self.tracks[currentIndex];
        currentTrack.duration = 0;
    }
}

@end
