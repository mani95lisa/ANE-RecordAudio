//
//  RecordAudio.m
//  RecordAudio
//
//  Created by mani on 14-2-19.
//  Copyright (c) 2014年 pamakids. All rights reserved.
//

#import "RecordAudio.h"
#import "FlashRuntimeExtensions.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "RecordController.h"
#import "PlayAMR.h"
#include "lame.h"

@interface RecordAudio ()

@end

@implementation RecordAudio
{
    
}

FREObject startRecord(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    NSLog(@"Call Start Function");
    
    uint32_t stringLength;
    const uint8_t* saveName;
    NSString *saveNameString = nil;
    
    const uint8_t* index;
    NSString *indexString = nil;
    
    const uint8_t* rate;
    NSString *rateString = nil;
    
    if(argv[0] && (FREGetObjectAsUTF8(argv[0], &stringLength, &saveName) == FRE_OK)){
        saveNameString = [NSString stringWithUTF8String:(char*)saveName];
    }
    
    if(argv[1] && (FREGetObjectAsUTF8(argv[1], &stringLength, &index) == FRE_OK)){
        indexString= [NSString stringWithUTF8String:(char*)index];
    }
    
    if(argv[2] && (FREGetObjectAsUTF8(argv[2], &stringLength, &rate) == FRE_OK)){
        rateString= [NSString stringWithUTF8String:(char*)rate];
    }
    
    RecordController* rc = funcData;
    [rc startRecord:saveNameString index:indexString sampleRate:rateString];
    
    return nil;
}

FREObject stopRecord(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    NSLog(@"Call Stop Function");
    
    RecordController* rc = funcData;
    [rc stopRecord];
    
    return nil;
}

FREObject toMp3(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    NSLog(@"Call to mp3");
    
    RecordController* rc = funcData;
    [rc toMp3];

    return nil;
}

FREObject toAmr(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    NSLog(@"Call to Amr3");
    
    RecordController* rc = funcData;
    [rc toAmr];
    
    return nil;
}

FREObject stopAmr(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    NSLog(@"stop Amr");
    
    PlayAMR* pa = funcData;
    [pa stopCurrentPlayAMRFile];
    
    return nil;
}

FREObject playAmr(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    uint32_t stringLength;
    const uint8_t* path;
    NSString *pathString = nil;
    
    const uint8_t* volume;
    NSString *volumeString = nil;
    
    
    if(argv[0] && (FREGetObjectAsUTF8(argv[0], &stringLength, &path) == FRE_OK)){
        pathString = [NSString stringWithUTF8String:(char*)path];
    }
    
    if(argv[1] && (FREGetObjectAsUTF8(argv[1], &stringLength, &volume) == FRE_OK)){
        volumeString= [NSString stringWithUTF8String:(char*)volume];
    }
    
    if(!volumeString)
        volumeString = @"1.0";
    
    NSLog(@"Call to playAmr %@, %@", pathString, volumeString);
    
    PlayAMR* pa = funcData;
    [pa playAMR:pathString volume:[volumeString floatValue]];
    
    return nil;
}


void RecordAudioContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest,
                                   const FRENamedFunction** functionsToSet){
    uint numOfFun = 6;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * numOfFun);
    *numFunctionsToTest = numOfFun;
   
    RecordController* rc = [RecordController alloc];
    rc.freContext = ctx;
    FRESetContextNativeData(ctx, rc);
    
    func[0].name = (const uint8_t*) "startRecord";
    func[0].functionData = rc;
    func[0].function = &startRecord;
    
    func[1].name = (const uint8_t*) "stopRecord";
    func[1].functionData = rc;
    func[1].function = &stopRecord;
    
    func[2].name = (const uint8_t*) "toMp3";
    func[2].functionData = rc;
    func[2].function = &toMp3;
    
    func[3].name = (const uint8_t*) "toAmr";
    func[3].functionData = rc;
    func[3].function = &toAmr;
    
    PlayAMR* pa = [PlayAMR alloc];
    pa.freContext = ctx;

    
    func[4].name = (const uint8_t*) "playAmr";
    func[4].functionData = pa;
    func[4].function = &playAmr;
    
    func[5].name = (const uint8_t*) "stopAmr";
    func[5].functionData = pa;
    func[5].function = &stopAmr;

    
    
    *functionsToSet = func;
    
    NSLog(@"Inited 1");
}

void RecordAudioExtFinalizer(void* extData)
{
    NSLog(@"Finalize!");
    return;
}

void RecordAudioContextFinalizer(FREContext ctx) { }
void RecordAudioFinalizer(void *extData) { }

void RecordAudioInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &RecordAudioContextInitializer;
    *ctxFinalizerToSet = &RecordAudioContextFinalizer;
}

@end
