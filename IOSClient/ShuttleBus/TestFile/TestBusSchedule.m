//
//  TestBusSchedule.m
//  ShuttleBus
//
//  Created by 刘威 on 11/23/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import "TestBusSchedule.h"
#import "BusScheduleStopInfo.h"
#import "BusInfo.h"

@implementation TestBusSchedule

+ (NSArray*) getBusLineSchedule: (NSString*) line
                 morningOrNight: (bool) isMorning
{
    NSMutableArray* busScheduleArray = [[NSMutableArray alloc] init];
    if ([line  isEqual: @"Line 1"] && isMorning == true)
    {
        BusScheduleStopInfo *stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3394560000;
        stop1.latitude = 39.8491050000;
        stop1.altitude = 0.0;
        stop1.time = @"07:40:00";
        stop1.name = @"玉泉营";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3106170000;
        stop1.latitude = 39.8886570000;
        stop1.altitude = 0.0;
        stop1.time = @"08:00:00";
        stop1.name = @"六里桥北里";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3105580000;
        stop1.latitude = 39.9103780000;
        stop1.altitude = 0.0;
        stop1.time = @"08:10:00";
        stop1.name = @"公主坟";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3102840000;
        stop1.latitude = 39.9240130000;
        stop1.altitude = 0.0;
        stop1.time = @"08:14:00";
        stop1.name = @"航天桥";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3102520000;
        stop1.latitude = 39.9416800000;
        stop1.altitude = 0.0;
        stop1.time = @"08:19:00";
        stop1.name = @"紫竹桥";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.2939070000;
        stop1.latitude = 40.0492590000;
        stop1.altitude = 0.0;
        stop1.time = @"08:45:00";
        stop1.name = @"公司";
        [busScheduleArray addObject:stop1];
    }
    else if ([line  isEqual: @"Line 1"] && isMorning == false)
    {
        BusScheduleStopInfo *stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.2961220000;
        stop1.latitude = 40.0520840000;
        stop1.altitude = 0.0;
        stop1.time = @"18:45:00";
        stop1.name = @"Info Centre信息中心";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.2939390000;
        stop1.latitude = 40.0492630000;
        stop1.altitude = 0.0;
        stop1.time = @"18:50:00";
        stop1.name = @"Arca方舟大厦";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.2659090000;
        stop1.latitude = 40.0533350000;
        stop1.altitude = 0.0;
        stop1.time = @"18:55:00";
        stop1.name = @"西北旺";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.2805580000;
        stop1.latitude = 40.0231780000;
        stop1.altitude = 0.0;
        stop1.time = @"19:10:00";
        stop1.name = @"百旺商城";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3171590000;
        stop1.latitude = 39.9766730000;
        stop1.altitude = 0.0;
        stop1.time = @"19:30:00";
        stop1.name = @"海淀剧院";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3199970000;
        stop1.latitude = 39.9697140000;
        stop1.altitude = 0.0;
        stop1.time = @"19:40:00";
        stop1.name = @"当代";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3099540000;
        stop1.latitude = 39.9427120000;
        stop1.altitude = 0.0;
        stop1.time = @"20:00:00";
        stop1.name = @"紫竹桥";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3101260000;
        stop1.latitude = 39.9243420000;
        stop1.altitude = 0.0;
        stop1.time = @"20:05:00";
        stop1.name = @"航天桥";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3099540000;
        stop1.latitude = 39.9103980000;
        stop1.altitude = 0.0;
        stop1.time = @"20:10:00";
        stop1.name = @"公主坟";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3108500000;
        stop1.latitude = 39.8813910000;
        stop1.altitude = 0.0;
        stop1.time = @"20:15:00";
        stop1.name = @"六里桥";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3388420000;
        stop1.latitude = 39.8488670000;
        stop1.altitude = 0.0;
        stop1.time = @"20:25:00";
        stop1.name = @"玉泉营";
        [busScheduleArray addObject:stop1];
    }
    else if ([line  isEqual: @"Line 2"] && isMorning == true)
    {
        BusScheduleStopInfo *stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3200230000;
        stop1.latitude = 39.9703160000;
        stop1.altitude = 0.0;
        stop1.time = @"08:05:00";
        stop1.name = @"当代商城";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3172230000;
        stop1.latitude = 39.9780790000;
        stop1.altitude = 0.0;
        stop1.time = @"08:08:00";
        stop1.name = @"海淀剧院";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.2807400000;
        stop1.latitude = 40.0233630000;
        stop1.altitude = 0.0;
        stop1.time = @"08:25:00";
        stop1.name = @"百旺商城";
        [busScheduleArray addObject:stop1];

        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.2659350000;
        stop1.latitude = 40.0532940000;
        stop1.altitude = 0.0;
        stop1.time = @"08:35:00";
        stop1.name = @"西北旺";
        [busScheduleArray addObject:stop1];

        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.2939070000;
        stop1.latitude = 40.0492590000;
        stop1.altitude = 0.0;
        stop1.time = @"08:45:00";
        stop1.name = @"公司";
        [busScheduleArray addObject:stop1];
    }
    else if ([line  isEqual: @"Line 2"] && isMorning == false)
    {
        BusScheduleStopInfo *stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.2961220000;
        stop1.latitude = 40.0520840000;
        stop1.altitude = 0.0;
        stop1.time = @"18:15:00";
        stop1.name = @"Info Centre信息中心";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.2939390000;
        stop1.latitude = 40.0492630000;
        stop1.altitude = 0.0;
        stop1.time = @"18:20";
        stop1.name = @"Arca方舟大厦";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3171590000;
        stop1.latitude = 39.9766730000;
        stop1.altitude = 0.0;
        stop1.time = @"19:00:00";
        stop1.name = @"海淀剧院";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3199970000;
        stop1.latitude = 39.9697140000;
        stop1.altitude = 0.0;
        stop1.time = @"19:10:00";
        stop1.name = @"当代";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3099540000;
        stop1.latitude = 39.9427120000;
        stop1.altitude = 0.0;
        stop1.time = @"19:15:00";
        stop1.name = @"紫竹桥";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3101260000;
        stop1.latitude = 39.9243420000;
        stop1.altitude = 0.0;
        stop1.time = @"19:25:00";
        stop1.name = @"航天桥";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3099540000;
        stop1.latitude = 39.9103980000;
        stop1.altitude = 0.0;
        stop1.time = @"19:30:00";
        stop1.name = @"公主坟";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3108500000;
        stop1.latitude = 39.8813910000;
        stop1.altitude = 0.0;
        stop1.time = @"19:35:00";
        stop1.name = @"六里桥";
        [busScheduleArray addObject:stop1];
        
        stop1 = [[BusScheduleStopInfo alloc] init];
        stop1.longitude = 116.3388420000;
        stop1.latitude = 39.8488670000;
        stop1.altitude = 0.0;
        stop1.time = @"19:45:00";
        stop1.name = @"玉泉营";
        [busScheduleArray addObject:stop1];
    }
    
    NSArray* returnArray = [busScheduleArray mutableCopy];
    
    return returnArray;
}

+ (BusInfo*) getBusInfo: (NSString*) line
{
    BusInfo* busInfo = [[BusInfo alloc] init];
    
    if ([line isEqual:@"Line 1"]) {
        busInfo.lineName = @"Line 1";
        busInfo.seatCount = 37;
        busInfo.license = @"京B10023";
        busInfo.driver = @"Driver Zhang";
        busInfo.phone = @"13910560524";
    } else if ([line isEqual:@"Line 2"]) {
        busInfo.lineName = @"Line 2";
        busInfo.seatCount = 49;
        busInfo.license = @"京B08735";
        busInfo.driver = @"Driver Li";
        busInfo.phone = @"13651280365";
    }
    
    return busInfo;
}

+ (NSArray*) getAllBusInfo
{
    NSMutableArray* busLineArray = [[NSMutableArray alloc] init];
    
    BusInfo* busInfo = [[BusInfo alloc] init];
    
    busInfo.lineName = @"Line 1";
    busInfo.seatCount = 37;
    busInfo.license = @"京B10023";
    busInfo.driver = @"Driver Zhang";
    busInfo.phone = @"13910560524";
    [busLineArray addObject:busInfo];
    
    busInfo = [[BusInfo alloc] init];
    busInfo.lineName = @"Line 2";
    busInfo.seatCount = 49;
    busInfo.license = @"京B08735";
    busInfo.driver = @"Driver Li";
    busInfo.phone = @"13651280365";
    [busLineArray addObject:busInfo];
    
    NSArray* returnArray = [busLineArray mutableCopy];
    
    return returnArray;
}

@end
