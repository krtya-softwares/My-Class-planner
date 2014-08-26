//
//  LoginViewController.m
//  TutorialBase
//
//  Created by Antonio MG on 6/23/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ViewController.h"
#import "MBProgressHUD.h"

@implementation LoginViewController
{
    NSMutableArray *arrObjects;
}

@synthesize userTextField = _userTextField, passwordTextField = _passwordTextField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    self.userTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    // set the frame scroll view to its original value
    self.scrollView.frame = CGRectMake(0, 0, 768, 1024);
    self.scrollView.contentSize=CGSizeMake(768,1024);
    
    
   self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgrond.png"]];
    
    //self.title =@"Login";
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    int ver = [version intValue];
    if (ver < 7){
        //iOS 6 work
    }
    else{
        //iOS 7 related work
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
     self.navigationController.interactivePopGestureRecognizer.enabled = NO;
     }

}

- (void) viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.title=@"Login";
    
    //Delete me
    self.userTextField.text = @"";//@"mahesh";
    self.passwordTextField.text = @"";//@"pass#123";
    
    
	// Register for the events
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector (keyboardDidShow:)	 name: UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector (keyboardDidHide:)	 name: UIKeyboardDidHideNotification object:nil];
	
	//Initially the keyboard is hidden
	keyboardVisible = NO;
    
   [super viewWillAppear:animated];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    keyboardVisible = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.userTextField = nil;
    self.passwordTextField = nil;
}

#pragma mark - Keyboard methods
-(void) keyboardDidShow: (NSNotification *)notif {
    
	//NSLog(@"[[[UIDevice currentDevice] systemVersion] floatValue]::%f",[[[UIDevice currentDevice] systemVersion] floatValue]);
    
	if (keyboardVisible) {
		//NSLog(@"Keyboard is already visible. Ignore notification.");
        
		return;
	}
	//[self addButtonToKeyboard];
	// Get the size of the keyboard.
	NSDictionary* info = [notif userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
    
	
	// Save the current location so we can restore
	offset = self.scrollView.contentOffset;
	
	// Resize the scroll view to make room for the keyboard
	CGRect viewFrame = self.scrollView.frame;
	viewFrame.size.height -= keyboardSize.height;
	self.scrollView.frame = viewFrame;
	
	CGRect textFieldRect = selectedTextbox;
	textFieldRect.origin.y += 76;
	[self.scrollView scrollRectToVisible:textFieldRect animated:YES];
     self.scrollView.contentSize=CGSizeMake(768,1024);
	
	keyboardVisible = YES;
    
}




-(void) keyboardDidHide: (NSNotification *)notif {
	// Is the keyboard already shown
	if (!keyboardVisible) {
		return;
	}
	
	// Reset the frame scroll view to its original value
    
        self.scrollView.frame = CGRectMake(0, 0, 768, 1024);
        self.scrollView.contentSize=CGSizeMake(768,1024);
    
    // Reset the scrollview to previous location
	self.scrollView.contentOffset = offset;
	
	// Keyboard is no longer visible
	keyboardVisible = NO;
	
	
}
#pragma mark- keyboard delegate


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    selectedTextbox = [textField frame];
	return YES;
}

/*- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
 {
 BOOL isValidate =YES;
 if (textField.tag == 0) {
 NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
 NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
 isValidate= [emailTest evaluateWithObject:textField.text];
 }
 return  isValidate;
 }*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
    [textField resignFirstResponder];
    
	return YES;
}


#pragma mark -

#pragma mark IB Actions

//Login button pressed
-(IBAction)logInPressed:(id)sender
{
    [self.view endEditing:YES];
    if ([self.userTextField.text length] >0 && [self.passwordTextField.text length] >0 )
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Loading";
        
        [PFUser logInWithUsernameInBackground:self.userTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
            if (user) {
                //Open the wall
                NSLog(@"USER ::%@",user);
                [[NSUserDefaults standardUserDefaults] setValue:self.userTextField.text forKey:@"UserName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
                
                PFQuery *query = [PFQuery queryWithClassName:@"classPlannerList"]; //1
                [query whereKey:@"preparedBy" equalTo:userName];
                //[query whereKey:@"hours" greaterThan:[NSNumber numberWithInt:4]]; //3
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {//4
                    if (!error) {
                        NSLog(@"Successfully retrieved: %@", objects);
                        if (objects.count > 0) {
                            arrObjects = [[NSMutableArray alloc]initWithArray:objects];
                            
                        }
                        
                        
                    } else {
                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                        NSLog(@"Error: %@", errorString);
                    }
                    
                    GCCalendarPortraitView *calendar = [[GCCalendarPortraitView alloc] init];
                    calendar.dataSource = self;
                    calendar.delegate = self;
                    calendar.hasAddButton = NO;
                    //ViewController *viewController = [[ViewController alloc]init];
                    [self.navigationController pushViewController:calendar animated:YES];
                    
                }];
                
                
                
                
            } else {
                //Something bad has ocurred
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];

        
    }else
    {
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please check your Username and Password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
       
    }
    
}


-(IBAction)registerPressed:(id)sender
{
    RegisterViewController *registerViewController = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

#pragma mark GCCalendarDataSource
- (NSArray *)calendarEventsForDate:(NSDate *)date {
	NSMutableArray *events = [NSMutableArray array];
	
	NSDateComponents *components = [[NSCalendar currentCalendar] components:
									(NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit)
																   fromDate:date];
	[components setSecond:0];
    
	/*/ create 5 calendar events that aren't all day events
	for (NSInteger i = 0; i < 5; i++) {
		GCCalendarEvent *event = [[GCCalendarEvent alloc] init];
		event.color = [[GCCalendar colors] objectAtIndex:i];
		event.allDayEvent = NO;
		event.eventName = [event.color capitalizedString];
		event.eventDescription = event.eventName;
		
		[components setHour:9 + i];
		[components setMinute:0];
		
		event.startDate = [[NSCalendar currentCalendar] dateFromComponents:components];
		
		[components setMinute:50];
		
		event.endDate = [[NSCalendar currentCalendar] dateFromComponents:components];
		
		[events addObject:event];
		//[event release];
	}*/
    
    
                
                int i=9;
                int j=0;
                int colorCount = 0;
                for (PFObject *eachObject in arrObjects) {
                   
                
                    if ([[GCCalendar colors] count ] == colorCount) {
                        colorCount =0;
                    }
                    
                    NSString *eventName = [NSString stringWithFormat:@"%@",eachObject[@"title"]];
                    GCCalendarEvent *evt = [[GCCalendarEvent alloc] init];
                    evt.color = [[GCCalendar colors] objectAtIndex:colorCount];
                    evt.allDayEvent = NO;
                    evt.eventName = eventName;
                    evt.eventDescription = @"Learning Students and After completing Chapter take test.";
                    [components setHour:i];
                    [components setMinute:0];
                    evt.startDate = [[NSCalendar currentCalendar] dateFromComponents:components];
                    [components setHour:i+2];
                    evt.endDate = [[NSCalendar currentCalendar] dateFromComponents:components];
                    
                    evt.tag = j;
                    [events addObject:evt];
                    i=i+2;
                    j++;
                    colorCount++;
                    
                }
    
    
    
	/*GCCalendarEvent *evt = [[GCCalendarEvent alloc] init];
	evt.color = [[GCCalendar colors] objectAtIndex:1];
	evt.allDayEvent = NO;
	evt.eventName = @"11th Sci Biologogy 5th chapter";
	evt.eventDescription = @"Learning Students Biologogy. After completing Chapter take test.";
	[components setHour:15];
	[components setMinute:0];
	evt.startDate = [[NSCalendar currentCalendar] dateFromComponents:components];
	[components setHour:17];
	evt.endDate = [[NSCalendar currentCalendar] dateFromComponents:components];
	[events addObject:evt];
	//[evt release];*/
	
       
	// create an all day event
	/*GCCalendarEvent *event = [[GCCalendarEvent alloc] init];
	event.allDayEvent = YES;
	event.eventName = @"All Day Event";
	[events addObject:event];*/
	//[event release];
	
	return events;
}

#pragma mark GCCalendarDelegate
- (void)calendarTileTouchedInView:(GCCalendarView *)view withEvent:(GCCalendarEvent *)event {
	NSLog(@"Touch event %@", event.eventName);
    ViewController *viewController = [[ViewController alloc]init];
    viewController.object = [arrObjects objectAtIndex:event.tag];
    [self.navigationController pushViewController:viewController animated:YES];
    
}
- (void)calendarViewAddButtonPressed:(GCCalendarView *)view {
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark--
#pragma mark--
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // only want to do this on iOS 6
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        //  Don't want to rehydrate the view if it's already unloaded
        BOOL isLoaded = [self isViewLoaded];
        
        //  We check the window property to make sure that the view is not visible
        if (isLoaded && self.view.window == nil) {
            
            //  Give a chance to implementors to get model data from their views
            [self performSelectorOnMainThread:@selector(viewWillUnload)
                                   withObject:nil
                                waitUntilDone:YES];
            
            //  Detach it from its parent (in cases of view controller containment)
            [self.view removeFromSuperview];
            self.view = nil;    //  Clear out the view.  Goodbye!
            
            //  The view is now unloaded...now call viewDidUnload
            [self performSelectorOnMainThread:@selector(viewDidUnload)
                                   withObject:nil
                                waitUntilDone:YES];
        }
    }
}




@end
