//
//  BusInfoViewController.h
//  ShuttleBus
//
//  Created by 刘威 on 12/14/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusInfoTableViewCell.h"
#import "RestRequestor.h"

@interface BusInfoTableViewController : UITableViewController<JASwipeCellDelegate, AsynCallCompletionNotify>
@property (nonatomic, strong) NSMutableArray *tableData;
@property NSString* busLine;
@property NSArray* busScheduleArray;

@end
