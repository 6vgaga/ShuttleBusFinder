//
//  HomeViewController.h
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/16/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRevealControllerProperty.h"
#import "RestRequestor.h"

@interface HomeViewController : UIViewController <IRevealControllerProperty, AsynCallCompletionNotify, UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray* titleDataArray;

@end
