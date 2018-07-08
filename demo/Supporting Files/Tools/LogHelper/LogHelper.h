//
//  LogTimeStamp.h
//  demo
//
//  Created by liman on 02/12/2016.
//  Copyright © 2016 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogHelper : NSObject

SHARED_INSTANCE_FOR_HEADER(LogHelper);

- (NSString *)timeStamp;

@end
