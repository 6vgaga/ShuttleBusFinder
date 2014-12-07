//
//  BusLineOperator.h
//  ShuttleBus
//
//  Created by 刘威 on 11/23/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BusInfo;
@class BusLocationInfo;

@interface BusLineOperator : NSObject

+ (NSArray*) getBusLineSchedule: (NSString*) line
               morningOrNight: (bool) isMorning;

+ (NSArray*) getAllBusInfo;

+ (BusInfo*) getBusInfo: (NSString*) line;

/*+ (bool) uploadBusLocation: (NSString*) line
            morningOrNight: (bool) isMorning
           busLocationInfo: (BusLocationInfo*) info;

+ (NSArray*) getBusLocation: (NSString*) line
             morningOrNight: (bool) isMorning
                     userId: (NSString*) userId
                       time: (NSString*) time; // Format: 2011-08-26 05:41:06 +0000
*/
@end
