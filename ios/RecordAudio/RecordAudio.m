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
    
    if(argv[0] && (FREGetObjectAsUTF8(argv[0], &stringLength, &saveName) == FRE_OK)){
        saveNameString = [NSString stringWithUTF8String:(char*)saveName];
    }
    
    RecordController* rc = funcData;
    [rc startRecord:saveNameString];
    
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

void RecordAudioContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest,
                                   const FRENamedFunction** functionsToSet){
    uint numOfFun = 3;
    
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
