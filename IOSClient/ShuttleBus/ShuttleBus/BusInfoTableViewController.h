//
//  BusInfoViewController.h
//  ShuttleBus
//
//  Created by 刘威 on 12/14/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusInfoTableViewCell.h"

@interface BusInfoTableViewController : UITableViewController<JASwipeCellDelegate>
@property (nonatomic, strong) NSMutableArray *tableData;
@property NSString* busLine;

@end
