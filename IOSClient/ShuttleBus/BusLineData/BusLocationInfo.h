//
//  BusLocationInfo.h
//  ShuttleBus
//
//  Created by 刘威 on 11/25/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusLocationInfo : NSObject
{
    double longitude;
    double latitude;
    double altitude;
    NSString* time; // Format: 2011-08-26 05:41:06 +0000
    NSString* userId;
}

@property double longitude;
@property double latitude;
@property double altitude;
@property NSString* time;
@property NSString* userId;

@end
