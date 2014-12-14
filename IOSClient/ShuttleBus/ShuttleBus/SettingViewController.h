//
//  SettingViewController.h
//  ShuttleBus
//
//  Created by 刘威 on 12/8/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRevealControllerProperty.h"
#import "DOPDropDownMenu.h"

@interface SettingViewController : UIViewController <IRevealControllerProperty, UITextFieldDelegate, DOPDropDownMenuDataSource, DOPDropDownMenuDelegate>
{
}

@property NSArray* busMenuArray;
@property (weak, nonatomic) IBOutlet UISwitch *switchClickToUpload;
@property (weak, nonatomic) IBOutlet UITextField *frequenceText;
@property (weak, nonatomic) IBOutlet UILabel *fakeLineMenu;
@property NSString* selectLine;
@property (weak, nonatomic) IBOutlet UILabel *currentLine;

@end
