//
//  BusInfo.h
//  ShuttleBus
//
//  Created by 刘威 on 11/23/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusInfo : NSObject
{
    NSString* lineName;
    int seatCount;
    NSString* license;
    NSString* driver;
    NSString* phone;
}

@property NSString* lineName;
@property int seatCount;
@property NSString* license;
@property NSString* driver;
@property NSString* phone;

@end
