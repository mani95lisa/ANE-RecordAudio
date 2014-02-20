//
//  RecordController.m
//  RecordAudio
//
//  Created by mani on 14-2-19.
//  Copyright (c) 2014年 pamakids. All rights reserved.
//

#import "RecordController.h"
#import <UIKit/UIKit.h>
#import "FlashRuntimeExtensions.h"

#define recording (const uint8_t*)"recording"
#define mp3Converted (const uint8_t*)"mp3_converted"
#define stoped (const uint8_t*)"stoped"

@implementation RecordController

- (id)init
{
    self = [super self];
    
    
    NSLog(@"Init OK");
    
    return self;
}

- (NSInteger) formatIndexToEnum:(NSInteger) index
{
    //auto generate by python
    switch (index) {
        case 0: return kAudioFormatLinearPCM; break;
        case 1: return kAudioFormatAC3; break;
        case 2: return kAudioFormat60958AC3; break;
        case 3: return kAudioFormatAppleIMA4; break;
        case 4: return kAudioFormatMPEG4AAC; break;
        case 5: return kAudioFormatMPEG4CELP; break;
        case 6: return kAudioFormatMPEG4HVXC; break;
        case 7: return kAudioFormatMPEG4TwinVQ; break;
        case 8: return kAudioFormatMACE3; break;
        case 9: return kAudioFormatMACE6; break;
        case 10: return kAudioFormatULaw; break;
        case 11: return kAudioFormatALaw; break;
        case 12: return kAudioFormatQDesign; break;
        case 13: return kAudioFormatQDesign2; break;
        case 14: return kAudioFormatQUALCOMM; break;
        case 15: return kAudioFormatMPEGLayer1; break;
        case 16: return kAudioFormatMPEGLayer2; break;
        case 17: return kAudioFormatMPEGLayer3; break;
        case 18: return kAudioFormatTimeCode; break;
        case 19: return kAudioFormatMIDIStream; break;
        case 20: return kAudioFormatParameterValueStream; break;
        case 21: return kAudioFormatAppleLossless; break;
        case 22: return kAudioFormatMPEG4AAC_HE; break;
        case 23: return kAudioFormatMPEG4AAC_LD; break;
        case 24: return kAudioFormatMPEG4AAC_ELD; break;
        case 25: return kAudioFormatMPEG4AAC_ELD_SBR; break;
        case 26: return kAudioFormatMPEG4AAC_ELD_V2; break;
        case 27: return kAudioFormatMPEG4AAC_HE_V2; break;
        case 28: return kAudioFormatMPEG4AAC_Spatial; break;
        case 29: return kAudioFormatAMR; break;
        case 30: return kAudioFormatAudible; break;
        case 31: return kAudioFormatiLBC; break;
        case 32: return kAudioFormatDVIIntelIMA; break;
        case 33: return kAudioFormatMicrosoftGSM; break;
        case 34: return kAudioFormatAES3; break;
        default:
            return -1;
            break;
    }
}

- (void)startRecord:(NSString*) saveName
{
    NSLog(@"StartRecord");
    
    if (!_recording)
    {

        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
        _sampleRate  = 44100;
        _quality     = AVAudioQualityLow;
        _recording = _playing = _hasCAFFile = NO;
        _formatIndex = [self formatIndexToEnum:4];

        NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat: _sampleRate],                  AVSampleRateKey,
                                  [NSNumber numberWithInt: _formatIndex],                   AVFormatIDKey,
                                  [NSNumber numberWithInt: 2],                              AVNumberOfChannelsKey,
                                  [NSNumber numberWithInt: _quality],                       AVEncoderAudioQualityKey,
                                  nil];
        _saveName = saveName;
        _recordedFile = [[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:saveName]]retain];
        NSError* error;
        _recorder = [[AVAudioRecorder alloc] initWithURL:_recordedFile settings:settings error:&error];
        NSLog(@"%@ 3", [error description]);
        if (error)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"抱歉"
                                                            message:@"录音设置错误"
                                                           delegate:self
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
                        NSLog(@"StartRecord2");
        _recording = YES;
        [_recorder prepareToRecord];
        _recorder.meteringEnabled = YES;
        [_recorder record];
        
                NSLog(@"StartRecord3");
        
//        _timer = [NSTimer scheduledTimerWithTimeInterval:.01f
//                                                  target:self
//                                                selector:@selector(timerUpdate)
//                                                userInfo:nil
//                                                 repeats:YES];
    }
}

- (NSInteger) getFileSize:(NSString*) path
{
    NSFileManager * filemanager = [[[NSFileManager alloc]init] autorelease];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else
    {
        return -1;
    }
}

- (void) timerUpdate
{
    if (_recording)
    {
                        NSLog(@"StartRecord4");
//        int m = _recorder.currentTime / 60;
//        int s = ((int) _recorder.currentTime) % 60;
//        int ss = (_recorder.currentTime - ((int) _recorder.currentTime)) * 100;
//        
//        NSString *recordTime = [NSString stringWithFormat:@"%.2d:%.2d %.2d", m, s, ss];
//        NSInteger fileSize =  [self getFileSize:[NSTemporaryDirectory() stringByAppendingString:_saveName]];
//        NSString *recordSize = [NSString stringWithFormat:@"%ld", fileSize/1024];
//        
//        NSString *result = [recordTime stringByAppendingString:recordSize];
//                                        NSLog(@"StartRecord5");
//        FREDispatchStatusEventAsync(self.freContext, recording, (uint8_t*)result);
//                                NSLog(@"StartRecord5");
    }
}

- (void) stopRecord
{
    if(_recording)
    {
        _recording = NO;
        
        [_timer invalidate];
        _timer = nil;
        
        if (_recorder != nil )
        {
            _hasCAFFile = YES;
        }
        [_recorder stop];
        [_recorder release];
        _recorder = nil;
        NSData *someData = [[_recordedFile path] dataUsingEncoding:NSUTF8StringEncoding];
        
        const void *bytes = [someData bytes];
        //Easy way
        uint8_t *crypto_data = (uint8_t*)bytes;
        
        FREDispatchStatusEventAsync(self.freContext, stoped, crypto_data);
    }
}

- (void) toMp3
{
        NSLog(@"toMp3 %@", [_recordedFile path]);
    NSString *cafFilePath =[_recordedFile path];
//        NSString *cafFilePath =[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"];
        NSLog(@"mp30");
//    NSString *mp3FileName = _saveName;
//    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
//    NSLog(@"mp31 %@", mp3FileName);
    NSString *mp3FilePath = [NSTemporaryDirectory() stringByAppendingString:@"temp.mp3"];
    
    NSLog(@"mp31 %@", mp3FilePath);
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
            NSLog(@"mp32");
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, _sampleRate);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
            NSLog(@"mp33");
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
            NSLog(@"mp34");
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
            NSLog(@"mp35");
    }
    @finally {
        [self performSelectorOnMainThread:@selector(convertMp3Finish)
                               withObject:nil
                            waitUntilDone:YES];
    }
}

- (void) convertMp3Finish
{
    [_startDate release];
    _hasMp3File = YES;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//    NSInteger fileSize =  [self getFileSize:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", @"Mp3File.mp3"]];
//    NSString* fileString = [NSString stringWithFormat:@"%ld", fileSize/1024];
//
//    NSData *someData = [[_recordedFile path] dataUsingEncoding:NSUTF8StringEncoding];
//    const void *bytes = [someData bytes];
//    //Easy way
//    uint8_t *crypto_data = (uint8_t*)bytes;
    
    FREDispatchStatusEventAsync(self.freContext, mp3Converted, mp3Converted);
}

@end
