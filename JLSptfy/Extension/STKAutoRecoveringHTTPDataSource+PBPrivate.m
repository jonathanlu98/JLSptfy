//
//  STKAutoRecoveringHTTPDataSource+PBPrivate.m
//  STKSample
//
//  Created by Patrick BODET on 13/06/2019.
//  Copyright © 2019 iDevelopper. All rights reserved.
//

#import "STKAutoRecoveringHTTPDataSource+PBPrivate.h"

@import ObjectiveC;

static void _swizzleInstanceMethod(Class cls, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    
    if(originalMethod == NULL)
    {
        return;
    }
    
    if(swizzledMethod == NULL)
    {
        [NSException raise:NSInvalidArgumentException format:@"Swizzled method cannot be found."];
    }
    
    BOOL didAdd = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if(didAdd)
    {
        class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation STKAutoRecoveringHTTPDataSource (PBPrivate)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _swizzleInstanceMethod(self,
                               @selector(dataSourceErrorOccured:),
                               @selector(_pb_dataSourceErrorOccured:));
        _swizzleInstanceMethod(self,
                               @selector(dataSourceEof:),
                               @selector(_pb_dataSourceEof:));
    });
}

- (void)_pb_dataSourceErrorOccured:(STKDataSource*)dataSource {
    [self.audioPlayer.delegate audioPlayer:self.audioPlayer unexpectedError:STKAudioPlayerErrorDataSource];
    [self _pb_dataSourceErrorOccured:dataSource];
}

- (void)_pb_dataSourceEof:(STKDataSource*)dataSource {
    [self.audioPlayer.delegate audioPlayer:self.audioPlayer unexpectedError:STKAudioPlayerErrorDataSource];
    [self _pb_dataSourceEof:dataSource];
}

// STKAudioPlayer
static void * STKAudioPlayerPropertyKey = &STKAudioPlayerPropertyKey;

- (STKAudioPlayer *)audioPlayer {
    return objc_getAssociatedObject(self, STKAudioPlayerPropertyKey);
}

- (void)setAudioPlayer:(STKAudioPlayer *)player {
    objc_setAssociatedObject(self, STKAudioPlayerPropertyKey, player, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
