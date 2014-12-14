//
//  BusInfoViewController.h
//  ShuttleBus
//
//  Created by 刘威 on 12/14/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusInfoTableViewCell.h"

@interface BusInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,JASwipeCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableData;

@end
