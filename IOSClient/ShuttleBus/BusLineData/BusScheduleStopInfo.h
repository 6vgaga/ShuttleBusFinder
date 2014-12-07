//
//  BusScheduleStopInfo.h
//  ShuttleBus
//
//  Created by 刘威 on 11/23/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusScheduleStopInfo : NSObject
{
    double longitude;
    double latitude;
    double altitude;
    NSString* name;
    NSString* time;
}

@property double longitude;
@property double latitude;
@property double altitude;
@property NSString* name;
@property NSString* time;

@end
