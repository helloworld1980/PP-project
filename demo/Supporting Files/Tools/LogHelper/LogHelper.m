//
//  LogTimeStamp.m
//  demo
//
//  Created by liman on 02/12/2016.
//  Copyright © 2016 apple. All rights reserved.
//

#import "LogHelper.h"

@implementation LogHelper

SHARED_INSTANCE_FOR_CLASS(LogHelper);

static NSDateFormatter *timeStampFormat;

- (NSString *)timeStamp
{
    if (!timeStampFormat) {
        timeStampFormat = [[NSDateFormatter alloc] init];
        [timeStampFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        [timeStampFormat setTimeZone:[NSTimeZone systemTimeZone]];
    }
    return [timeStampFormat stringFromDate:[NSDate date]];
}

@end
