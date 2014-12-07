//
//  BusLineOperator.m
//  ShuttleBus
//
//  Created by 刘威 on 11/23/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import "BusLineOperator.h"
#import "TestBusSchedule.h"

@implementation BusLineOperator

+ (NSArray*) getBusLineSchedule: (NSString*) line
               morningOrNight: (bool) isMorning
{
    NSArray* returnArray = [TestBusSchedule getBusLineSchedule:line morningOrNight:isMorning];
    
    return returnArray;
}

+ (NSArray*) getAllBusInfo
{
    NSArray* returnArray = [TestBusSchedule getAllBusInfo];
    
    return returnArray;
}

+ (BusInfo*) getBusInfo: (NSString*) line
{
    BusInfo* returnInfo = [TestBusSchedule getBusInfo:line];
    
    return returnInfo;
}

@end
