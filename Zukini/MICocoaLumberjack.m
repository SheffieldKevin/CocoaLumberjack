//  MICocoaLumberjack.m
//
//  Copyright (c) 2015 Zukini. MIT license.

@import Foundation;

#if TARGET_OS_IPHONE
@import MovingImagesiOS;
#else
@import MovingImages;
#endif

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDFileLogger.h"

void MIInitializeCocoaLumberjack()
{
    // Set up the logging.
#ifdef DEBUG
//    I've not had time to resolve why DDTTYLogger outputs out of sync.
//    [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:LOG_LEVEL_INFO];
#endif
    // Create the file logger.
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    
    // We only want to roll the log file when it reaches it's maximum size.
    // We don't want to roll the log file after some time interval.
    // I'm using the default maximum size of 1MByte.
    fileLogger.rollingFrequency = 0;
    
    // Only keep the last three log files.
    fileLogger.logFileManager.maximumNumberOfLogFiles = 2;
    // fileLogger.doNotReuseLogFiles = YES;
    // fileLogger.maximumFileSize = 1024; // for testing log file creation
    [DDLog addLogger:fileLogger withLogLevel:LOG_LEVEL_INFO];
    
    MILoggingFunction miLog = ^void(NSString *msg, NSString *objClass,
                                    NSString *objStringRep, NSString *file,
                                    int line, NSString *function)
    {
        BOOL async = YES;
        NSString *_sFileName;
        if (file)
        {
            // _sFileName = [[NSString stringWithUTF8String:file] lastPathComponent];
            _sFileName = file.lastPathComponent;
            [DDLog log:async level:LOG_LEVEL_INFO flag:LOG_FLAG_INFO
               context:0 file:nil function:nil line:0 tag:0
                format:@"File: %@ Line: %d", _sFileName, line];
        }
        
        if (function)
        {
            [DDLog log:async level:LOG_LEVEL_INFO flag:LOG_FLAG_INFO
               context:0 file:nil function:nil line:0 tag:0
                format:@"Method/Function: %@", function];
        }
        
        if (msg)
        {
            [DDLog log:async level:LOG_LEVEL_INFO flag:LOG_FLAG_INFO
               context:0 file:nil function:nil line:0 tag:0
                format:@"%@", msg];
        }
        
        if (objStringRep)
        {
            [DDLog log:async level:LOG_LEVEL_INFO flag:LOG_FLAG_INFO
               context:0 file:nil function:nil line:0 tag:0
                format:@"Class: %@ Object: %@", objClass, objStringRep];
        }
    };
    MISetLogging(miLog);
}

