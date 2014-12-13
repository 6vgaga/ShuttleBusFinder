//
//  ViewController.h
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/16/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOPDropDownMenu.h"
#import "RestRequestor.h"

@interface ViewController : UIViewController <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, AsynCallCompletionNotify, UITextFieldDelegate>
{
    NSArray* busMenuArray;
}

@property NSArray* busMenuArray;
@property (weak, nonatomic) IBOutlet UILabel *fakeMenu;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
