//
//  LoginViewController.h
//  TutorialBase
//
//  Created by Antonio MG on 6/23/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCCalendar.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate,GCCalendarDataSource, GCCalendarDelegate>
{
    CGRect selectedTextbox;
    BOOL keyboardVisible;
    CGPoint offset;
}

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITextField *userTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;


-(IBAction)logInPressed:(id)sender;

-(void) keyboardDidShow: (NSNotification *)notif;
-(void) keyboardDidHide: (NSNotification *)notif;

@end
