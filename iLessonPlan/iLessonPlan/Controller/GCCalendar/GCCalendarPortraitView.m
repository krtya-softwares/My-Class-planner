//
//  GCCalendarPortraitView.m
//  GCCalendar
//
//	GUI Cocoa Common Code Library
//
//  Created by Caleb Davenport on 1/23/10.
//  Copyright GUI Cocoa Software 2010. All rights reserved.
//

#import "GCCalendarPortraitView.h"
#import "GCCalendarDayView.h"
#import "GCCalendarTile.h"
#import "GCDatePickerControl.h"
#import "GCCalendar.h"


#import "IQActionSheetPickerView.h"

#define kAnimationDuration 0.3f

@interface GCCalendarPortraitView ()<IQActionSheetPickerViewDelegate>
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) GCCalendarDayView *dayView;

- (void)reloadDayAnimated:(BOOL)animated context:(void *)context;
@end

@implementation GCCalendarPortraitView

@synthesize date, dayView, hasAddButton;

#pragma mark create and destroy view
- (id)init {
	if(self = [super init]) {
		self.title = [[NSBundle mainBundle] localizedStringForKey:@"CALENDAR" value:@"" table:@"GCCalendar"];
		self.tabBarItem.image = [UIImage imageNamed:@"Calendar.png"];
		
		viewDirty = YES;
		viewVisible = NO;
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(calendarTileTouch:)
													 name:__GCCalendarTileTouchNotification
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(calendarShouldReload:)
													 name:GCCalendarShouldReloadNotification
												   object:nil];
	}
	
	return self;
}
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.date = nil;
	self.dayView = nil;
	
	[dayPicker release];
	
	[super dealloc];
}

#pragma mark calendar actions
- (void)calendarShouldReload:(NSNotification *)notif {
	viewDirty = YES;
}
- (void)calendarTileTouch:(NSNotification *)notif {
	if (delegate != nil) {
		GCCalendarTile *tile = [notif object];
		[delegate calendarTileTouchedInView:self withEvent:[tile event]];
	}
}

#pragma mark GCDatePickerControl actions
- (void)datePickerDidChangeDate:(GCDatePickerControl *)picker {
	NSTimeInterval interval = [date timeIntervalSinceDate:picker.date];
	
	self.date = picker.date;
	
	[[NSUserDefaults standardUserDefaults] setObject:date forKey:@"GCCalendarDate"];
	
	[self reloadDayAnimated:YES context:[NSNumber numberWithInt:interval]];
}

#pragma mark button actions
- (void)today {
	dayPicker.date = [NSDate date];
	
	self.date = dayPicker.date;
	
	[[NSUserDefaults standardUserDefaults] setObject:date forKey:@"GCCalendarDate"];
	
	[self reloadDayAnimated:NO context:NULL];
}
- (void)add {
	if (delegate != nil) {
		[delegate calendarViewAddButtonPressed:self];
	}
}

#pragma mark custom setters
- (void)setHasAddButton:(BOOL)b {
	hasAddButton = b;
	
	if (hasAddButton) {
		UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																				target:self
																				action:@selector(add)];
		self.navigationItem.rightBarButtonItem = button;
		[button release];
	}
	else {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

#pragma mark view notifications
- (void)loadView {
	[super loadView];
	
	self.date = [[NSUserDefaults standardUserDefaults] objectForKey:@"GCCalendarDate"];
	if (date == nil) {
		self.date = [NSDate date];
	}
	
	// setup day picker
	dayPicker = [[GCDatePickerControl alloc] init];
	dayPicker.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
	dayPicker.autoresizingMask = UIViewAutoresizingNone;
	dayPicker.date = date;
	[dayPicker addTarget:self action:@selector(datePickerDidChangeDate:) forControlEvents:UIControlEventValueChanged];
	
    
    UIButton *titlebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    titlebutton.frame = CGRectMake(40, 0, self.view.frame.size.width - (40 * 2), 45);
    [titlebutton setTitle:@"" forState:UIControlStateNormal];
    [titlebutton addTarget:self action:@selector(openDateSelectionController:) forControlEvents:UIControlEventTouchUpInside];
    [dayPicker addSubview:titlebutton];
    
    NSLog(@"dayPicker ::%@",[dayPicker subviews]);
    
    [self.view addSubview:dayPicker];
	
	// setup initial day view
	dayView = [[GCCalendarDayView alloc] initWithCalendarView:self];
	dayView.frame = CGRectMake(0,
							   dayPicker.frame.size.height,
							   self.view.frame.size.width,
							   self.view.frame.size.height - dayPicker.frame.size.height);
	dayView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	[self.view addSubview:dayView];
	
	// setup today button
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:[[NSBundle mainBundle] localizedStringForKey:@"TODAY" value:@"" table:@"GCCalendar"]
															   style:UIBarButtonItemStylePlain
															  target:self 
															  action:@selector(today)];
	self.navigationItem.leftBarButtonItem = button;
	[button release];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
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

    
	if (viewDirty) {
		[self reloadDayAnimated:NO context:NULL];
		viewDirty = NO;
	}
	
	viewVisible = YES;
}
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	viewVisible = NO;
}
#pragma mark - Action Method

- (IBAction)openDateSelectionController:(id)sender {
   /* RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.delegate = self;
    dateSelectionVC.titleLabel.text = @"";//@"This is an example title.\n\nPlease choose a date and press 'Select' or 'Cancel'.";
    
    //You can enable or disable bouncing and motion effects
    //dateSelectionVC.disableBouncingWhenShowing = YES;
    //dateSelectionVC.disableMotionEffects = YES;
    
    [dateSelectionVC show];
    
    //You can access the actual UIDatePicker via the datePicker property
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    dateSelectionVC.datePicker.minuteInterval = 5;
    dateSelectionVC.datePicker.date = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    
    //You can also adjust colors (enabling example will result in a black version)
    //dateSelectionVC.tintColor = [UIColor whiteColor];
    //dateSelectionVC.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];*/
    
    /*RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    
    //You can enable or disable bouncing and motion effects
    //dateSelectionVC.disableBouncingWhenShowing = YES;
    //dateSelectionVC.disableMotionEffects = YES;
    
    [dateSelectionVC showWithSelectionHandler:^(RMDateSelectionViewController *vc, NSDate *aDate) {
        NSLog(@"Successfully selected date: %@ (With block)", aDate);
        self.view.userInteractionEnabled = YES;
    } andCancelHandler:^(RMDateSelectionViewController *vc) {
        NSLog(@"Date selection was canceled (with block)");
        self.view.userInteractionEnabled = YES;
    }];
    
    //You can access the actual UIDatePicker via the datePicker property
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    dateSelectionVC.datePicker.minuteInterval = 5;
    dateSelectionVC.datePicker.date = [NSDate dateWithTimeIntervalSinceReferenceDate:0];*/
    
    //TestViewController *testView = [[TestViewController alloc]init];
    //[self presentViewController:testView animated:YES completion:nil];
    
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Date Picker" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [picker setTag:6];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker showInView:self.view];
    
}
#pragma mark -- DELEGATE
- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray*)titles
{
    
    NSLog(@"titles ::%@ %@ %@",titles , [[titles lastObject] class],pickerView.date);
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:
							  (NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit)
															 fromDate:pickerView.date];
	
	NSInteger weekday = [comp weekday];
	NSInteger month = [comp month];
	NSInteger year = [comp year];
	NSInteger day = [comp day];
	
	NSArray *weekdayStrings = [[GCCalendar dateFormatter] weekdaySymbols];
	NSArray *monthStrings = [[GCCalendar dateFormatter] shortMonthSymbols];
	
	NSString *toDisplay = [NSString stringWithFormat:@"%@ %@ %d %d",
                           [weekdayStrings objectAtIndex:weekday - 1],
                           [monthStrings objectAtIndex:month - 1],
                           day, year];
	dayPicker.titleLabel.text = toDisplay;
    dayPicker.date = pickerView.date;
    
    [dayPicker sendActionsForControlEvents:UIControlEventValueChanged];
    
    
    
}

#pragma mark - RMDAteSelectionViewController Delegates
/*- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    NSLog(@"Successfully selected date: %@", aDate);
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:
							  (NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit)
															 fromDate:aDate];
	
	NSInteger weekday = [comp weekday];
	NSInteger month = [comp month];
	NSInteger year = [comp year];
	NSInteger day = [comp day];
	
	NSArray *weekdayStrings = [[GCCalendar dateFormatter] weekdaySymbols];
	NSArray *monthStrings = [[GCCalendar dateFormatter] shortMonthSymbols];
	
	NSString *toDisplay = [NSString stringWithFormat:@"%@ %@ %d %d",
                           [weekdayStrings objectAtIndex:weekday - 1],
                           [monthStrings objectAtIndex:month - 1],
                           day, year];
	dayPicker.titleLabel.text = toDisplay;
    
    
    
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    NSLog(@"Date selection was canceled");
}*/

#pragma mark view animation functions
- (void)reloadDayAnimated:(BOOL)animated context:(void *)context {
	if (animated) {
		NSTimeInterval interval = [(__bridge NSNumber *)context doubleValue];
		
		// block user interaction
		dayPicker.userInteractionEnabled = NO;
		
		// setup next day view
		GCCalendarDayView *nextDayView = [[GCCalendarDayView alloc] initWithCalendarView:self];
		CGRect initialFrame = dayView.frame;
		if (interval < 0) {
			initialFrame.origin.x = initialFrame.size.width;
		}
		else if (interval > 0) {
			initialFrame.origin.x = 0 - initialFrame.size.width;
		}
		else {
			[nextDayView release];
			return;
		}
		nextDayView.frame = initialFrame;
		nextDayView.date = date;
		[nextDayView reloadData];
		nextDayView.contentOffset = dayView.contentOffset;

		[self.view addSubview:nextDayView];
		
		[UIView beginAnimations:nil context:(__bridge void *)(nextDayView)];
		[UIView setAnimationDuration:kAnimationDuration];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		CGRect finalFrame = dayView.frame;
		if(interval < 0) {
			finalFrame.origin.x = 0 - finalFrame.size.width;
		} else if(interval > 0) {
			finalFrame.origin.x = finalFrame.size.width;
		}
		nextDayView.frame = dayView.frame;
		dayView.frame = finalFrame;
		[UIView commitAnimations];
	}
	else {
		CGPoint contentOffset = dayView.contentOffset;
		dayView.date = date;
		[dayView reloadData];
		dayView.contentOffset = contentOffset;
	}
}
- (void)animationDidStop:(NSString *)animationID 
				finished:(NSNumber *)finished 
				 context:(void *)context {
	
	GCCalendarDayView *nextDayView = (__bridge GCCalendarDayView *)context;
	
	// cut variables
	[dayView removeFromSuperview];
	
	// reassign variables
	self.dayView = nextDayView;
	
	// release pointers
	[nextDayView release];
	
	// reset pickers
	dayPicker.userInteractionEnabled = YES;
}

@end
