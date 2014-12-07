//
//  TestBusSchedule.h
//  ShuttleBus
//
//  Created by 刘威 on 11/23/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BusInfo;

@interface TestBusSchedule : NSObject

+ (NSArray*) getBusLineSchedule: (NSString*) line
                 morningOrNight: (bool) isMorning;

+ (BusInfo*) getBusInfo: (NSString*) line;

+ (NSArray*) getAllBusInfo;

@end
