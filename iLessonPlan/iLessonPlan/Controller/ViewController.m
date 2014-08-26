//
//  ViewController.m
//  Test App
//
//  Created by krtya on 21/07/14.
//  Copyright (c) 2014 Krtya. All rights reserved.
//

#import "ViewController.h"
#import "TTOpenInAppActivity.h"
/*NSInteger static compareViewsByOrigin(id sp1, id sp2, void *context)
{
    // UISegmentedControl segments use UISegment objects (private API). Then we can safely
    //   cast them to UIView objects.
    float v1 = ((UIView *)sp1).frame.origin.x;
    float v2 = ((UIView *)sp2).frame.origin.x;
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}*/


@interface ViewController ()
{
    NSMutableArray *arrCource,*arrSubject,*arrSkill,*arrStandard,*arrChapter,*arrObjective;
    NSMutableArray *selectedSkill,*selectedObjective;
    NSString *strCource,*strSubject,*strSkil,*strStandard,*strChapter,*strObjective;
    NSInteger pickerType;
    
}

@property (nonatomic, strong) UIPopoverController *activityPopoverController;
//@property (strong, nonatomic) KSEnhancedKeyboard *enhancedKeyboard;
@end

@implementation ViewController
@synthesize object;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.objectiveView.alpha = 1.0;
    self.resourceView.alpha = 0.0;
    self.homeworkView.alpha = 0.0;
    self.title = @"My iLesson Planner";
    
    
    self.scrollView.contentSize = CGSizeMake(768, 1410-80);
    self.scrollView.frame = CGRectMake( self.scrollView.frame.origin.x,  self.scrollView.frame.origin.y, 768,944);
    
   /* UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Mahesh | Logout"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(btnLogoutClick:)];
    [rightButton setImage:[UIImage imageNamed:@"user-icon.png"]];
    self.navigationItem.rightBarButtonItem = rightButton;*/
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    
    
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
   // [btnLogout setImage:[UIImage imageNamed:@"excel.png"] forState:UIControlStateNormal];
    btnLogout.frame = CGRectMake(0, 0, 90, 32);
    btnLogout.showsTouchWhenHighlighted=YES;
    [btnLogout addTarget:self action:@selector(btnLogoutClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnLogout setTitle:@"| Logout" forState:UIControlStateNormal];
    [btnLogout setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnLogout];
    [arrRightBarItems addObject:barButtonItem2];
    
    UIButton *btnUserName = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnUserName setImage:[UIImage imageNamed:@"user-icon.png.png"] forState:UIControlStateNormal];
    btnUserName.frame = CGRectMake(0, 0, 90, 32);
    btnUserName.showsTouchWhenHighlighted=NO;
    btnUserName.userInteractionEnabled = NO;
    //btnUserName.titleLabel.text = @"Mahesh";
    [btnUserName setTitle:[NSString stringWithFormat:@" %@",userName] forState:UIControlStateNormal];
    [btnUserName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[btnSetting addTarget:self action:@selector(onSettings:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnUserName];
    [arrRightBarItems addObject:barButtonItem];
    
    self.navigationItem.rightBarButtonItems=arrRightBarItems;
    
    
    arrCource = [[NSMutableArray alloc]init];
    [arrCource addObject:@"MCA"];
    [arrCource addObject:@"MBA"];
    
    arrChapter = [[NSMutableArray alloc]init];
    [arrChapter addObject:@"PL/SQL Operators"];
    [arrChapter addObject:@"Graphs"];
    [arrChapter addObject:@"Introduction to Marketing "];
    [arrChapter addObject:@"Balance Sheet"];
    
    arrSubject = [[NSMutableArray alloc]init];
    [arrSubject addObject:@"DBMS"];
    [arrSubject addObject:@"Data Structure"];
    [arrSubject addObject:@"Business Administration"];
    [arrSubject addObject:@"Account"];
    
    arrSkill = [[NSMutableArray alloc]init];
    [arrSkill addObject:@"Listening"];
    [arrSkill addObject:@"Speaking"];
    [arrSkill addObject:@"Reading"];
    [arrSkill addObject:@"Writing"];
    
    arrStandard  = [[NSMutableArray alloc]init];
    [arrStandard addObject:@"Standard-1"];
    [arrStandard addObject:@"Standard-2"];
    [arrStandard addObject:@"Standard-3"];
    [arrStandard addObject:@"Standard-4"];
    [arrStandard addObject:@"Standard-5"];
    [arrStandard addObject:@"Standard-6"];
    
    [arrStandard addObject:@"MBA 1st Year"];
    [arrStandard addObject:@"MBA 2nd Year"];
    [arrStandard addObject:@"MBA 3rd Year"];
    
    arrObjective = [[NSMutableArray alloc]init];
    [arrObjective addObject:@"Comparison Operators"];
    [arrObjective addObject:@"Arithmetic operators"];
    [arrObjective addObject:@"Current Assets"];
    [arrObjective addObject:@"Non-Current Assets"];
    
    strCource = [arrCource objectAtIndex: 0];
    strSubject = [arrSubject objectAtIndex: 0];
    strSkil = [arrSkill objectAtIndex: 0];
    strStandard = [arrStandard objectAtIndex: 0];
    strChapter = [arrChapter objectAtIndex: 0];
    strObjective = [arrObjective objectAtIndex: 0];
    
    self.tblSkill.dataSource = self;
    self.tblSkill.delegate = self;
    self.tblObjective.dataSource = self;
    self.tblObjective.delegate = self;
    
    selectedObjective = [[NSMutableArray alloc]init];
    selectedSkill = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [self.scrollView addGestureRecognizer:gestureRecognizer];
    
   
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont boldSystemFontOfSize:17], UITextAttributeFont,
                                [UIColor whiteColor], UITextAttributeTextColor,
                                nil];
    [self.segmentedControll setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.segmentedControll setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
    [self.segmentedControll setTitleTextAttributes:attributes forState:UIControlStateSelected];
    
    [self SGMValueChanged:nil];
    
    [self setRoundedBorder:1.0 borderWidth:1.0 color:[UIColor grayColor] controller:self.btnSelectChapter];
    [self setRoundedBorder:1.0 borderWidth:1.0 color:[UIColor grayColor] controller:self.btnSelectCource];
    [self setRoundedBorder:1.0 borderWidth:1.0 color:[UIColor grayColor] controller:self.btnSelectSubject];
    [self setRoundedBorder:1.0 borderWidth:1.0 color:[UIColor grayColor] controller:self.btnSelectStandard];
    [self setRoundedBorder:1.0 borderWidth:1.0 color:[UIColor grayColor] controller:self.tblObjective];
    [self setRoundedBorder:1.0 borderWidth:1.0 color:[UIColor grayColor] controller:self.tblSkill];
    [self setRoundedBorder:1.0 borderWidth:1.0 color:[UIColor grayColor] controller:self.txtplanTitle];
    [self setRoundedBorder:1.0 borderWidth:1.0 color:[UIColor grayColor] controller:self.txtPreparedBy];
    [self setRoundedBorder:1.0 borderWidth:1.0 color:[UIColor grayColor] controller:self.txtHours];
    [self setRoundedBorder:1.0 borderWidth:1.0 color:[UIColor grayColor] controller:self.txtMinute];
    
    [self setRoundedBorder:1.0 borderWidth:2.0 color:[UIColor grayColor] controller:self.madatoryView];
    [self setRoundedBorder:1.0 borderWidth:2.0 color:[UIColor grayColor] controller:self.optionalView];
    
    [self setRoundedBorder:1.0 borderWidth:1.0 color:[UIColor grayColor] controller:self.webDetail];
    [self setRoundedBorder:15.0 borderWidth:1.0 color:[UIColor blackColor] controller:self.btnX];
    [self setRoundedBorder:1.0 borderWidth:1.0 color:[UIColor blackColor] controller:self.segmentedControll];
    
    
    [self.headerView setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:174.0f/255.0f blue:240.0f/255.0f alpha:1.0]];
    [self.view setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0]];
    
    for (UIView *view in [self.optionalView subviews])
    {
        if ([view isKindOfClass: [UIView class] ])
        {
            for (UIView *subview in [view subviews])
            {
                if ([subview isKindOfClass: [UIWebView class] ])
                {
                    UIWebView *webView = (UIWebView *)subview;
                    /* UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleWebviewTabing:)];
                    [webView addGestureRecognizer:tap];*/
                     [self setRoundedBorder:1.0 borderWidth:1.0 color:[UIColor grayColor] controller:webView];
                    
                }
            }
        }
    }
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
   // [webView loadHTMLString:htmlString baseURL:baseURL];
    
    NSString *htmlFileObj = [[NSBundle mainBundle] pathForResource:@"ch16" ofType:@"html"];
    NSString* htmlStringOBJ = [NSString stringWithContentsOfFile:htmlFileObj encoding:NSUTF8StringEncoding error:nil];
    [self.webIntroduction loadHTMLString:htmlStringOBJ baseURL:baseURL];
    self.webIntroduction.scalesPageToFit = YES;
   
    
    NSString *htmlFileAss = [[NSBundle mainBundle] pathForResource:@"exe" ofType:@"html"];
    NSString* htmlStringAss = [NSString stringWithContentsOfFile:htmlFileAss encoding:NSUTF8StringEncoding error:nil];
    [self.webAssessment loadHTMLString:htmlStringAss baseURL:baseURL];
    self.webAssessment.scalesPageToFit = YES;
    
    
    NSString *htmlFilelout = [[NSBundle mainBundle] pathForResource:@"lout" ofType:@"html"];
    NSString* htmlStringlout = [NSString stringWithContentsOfFile:htmlFilelout encoding:NSUTF8StringEncoding error:nil];
    [self.webLearningOutComes loadHTMLString:htmlStringlout baseURL:baseURL];
    self.webLearningOutComes.scalesPageToFit = YES;
    
    
    NSString *htmlFileteacherNote = [[NSBundle mainBundle] pathForResource:@"teacherNote" ofType:@"html"];
    NSString* htmlStringteacherNote = [NSString stringWithContentsOfFile:htmlFileteacherNote encoding:NSUTF8StringEncoding error:nil];
    [self.webTeacherNote loadHTMLString:htmlStringteacherNote baseURL:baseURL];
    self.webTeacherNote.scalesPageToFit = YES;
    
    
    NSString *htmlFileresources = [[NSBundle mainBundle] pathForResource:@"resources" ofType:@"html"];
    NSString* htmlStringresources = [NSString stringWithContentsOfFile:htmlFileresources encoding:NSUTF8StringEncoding error:nil];
    [self.webResource loadHTMLString:htmlStringresources baseURL:baseURL];
    self.webResource.scalesPageToFit = YES;
    
    NSString *htmlFilehomework = [[NSBundle mainBundle] pathForResource:@"homework" ofType:@"html"];
    NSString* htmlStringhomework = [NSString stringWithContentsOfFile:htmlFilehomework encoding:NSUTF8StringEncoding error:nil];
    [self.webHomework loadHTMLString:htmlStringhomework baseURL:baseURL];
    self.webHomework.scalesPageToFit = YES;
    
    
    
    [self.btnUserName setTitle:userName forState:UIControlStateNormal];
    //self.navigationItem.hidesBackButton = YES;
    
    
    /*PFQuery *query = [PFQuery queryWithClassName:@"classPlannerList"]; //1
    [query whereKey:@"subject" equalTo:@"Bio"];//2
    [query whereKey:@"preparedBy" equalTo:userName];
    //[query whereKey:@"hours" greaterThan:[NSNumber numberWithInt:4]]; //3
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {//4
        if (!error) {
            NSLog(@"Successfully retrieved: %@", objects);
            
            PFObject *pfObject  = [objects lastObject];*/
    if (object)
    {
        self.txtplanTitle.text = object[@"title"];
        self.txtPreparedBy.text =object[@"preparedBy"];
        [self.btnSelectCource setTitle:object[@"courseName"] forState:UIControlStateNormal];
        [self.btnSelectSubject setTitle:object[@"subject"] forState:UIControlStateNormal];
        
        
        NSString *strSkill = [NSString stringWithFormat:@"%@",object[@"skill"]];
        arrSkill = [[NSMutableArray alloc]initWithArray:[strSkill componentsSeparatedByString:@","]];
        
        self.txtHours.text =  [NSString stringWithFormat:@"%@", object[@"hours"]];
        self.txtMinute.text = [NSString stringWithFormat:@"%@",object[@"minutes"]];
        [self.btnSelectStandard setTitle:object[@"standard"] forState:UIControlStateNormal];
        [self.btnSelectChapter setTitle:object[@"chapter"] forState:UIControlStateNormal];
        
        PFFile *imageFile = object[@"hFile"];
        
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!data) {
                return NSLog(@"%@", error);
            }
            NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            // Do something with the image
            NSLog(@"FILE ::%@",myString);
        }];
        
        

    }
    
    
    
    
      /*  } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];*/

    
    
   
    
    //self.enhancedKeyboard = [[KSEnhancedKeyboard alloc] init];
    //self.enhancedKeyboard.delegate = self;
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    int ver = [version intValue];
    if (ver < 7){
        //iOS 6 work
    }
    else{
        //iOS 7 related work
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
   /* if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }*/

    
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark- keyboard delegate

#pragma mark - UITextFieldDelegate protocol

// --------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL isCorrect = YES;
        [textField resignFirstResponder];
    return isCorrect;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
     BOOL isCorrect = YES;
    /*if (textField == self.txtHours) {
        if ([textField.text intValue] > 24 )
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter hour below 24." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
            isCorrect =NO;
        }
    }else*/ if (textField == self.txtMinute) {
        if ([textField.text intValue] >= 60 ) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter seconds below 60." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
            isCorrect =NO;
        }else if ([self.txtHours.text intValue] == 24)
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please check your hours then enter minute." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
            isCorrect =NO;
        }
    }
    return isCorrect;

}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}



//// --------------------------------------------------------------------
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [textField setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:NO NextEnabled:NO DoneEnabled:YES]];
//}
//
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    [textView setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:NO NextEnabled:NO DoneEnabled:YES]];
//}
//
//// --------------------------------------------------------------------
//#pragma mark - KSEnhancedKeyboardDelegate Protocol
//
//- (void)nextDidTouchDown
//{
//   /* NSInteger nextTag = textField.tag + 1;
//    // Try to find next responder
//    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
//    if (nextResponder) {
//        // Found next responder, so set it.
//        [nextResponder becomeFirstResponder];
//    } else {
//        // Not found, so remove keyboard.
//        [textField resignFirstResponder];
//    }
//    return NO; // We do not want UITextField to insert line-breaks.
//    
//    for (int i=0; i<[self.formItems count]; i++)
//    {
//        if ([[[self.formItems objectAtIndex:i] textField] isEditing] && i!=[self.formItems count]-1)
//        {
//            [[[self.formItems objectAtIndex:i+1] textField] becomeFirstResponder];
//            
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//            
//            break;
//        }
//    }*/
//}
//
//// --------------------------------------------------------------------
//- (void)previousDidTouchDown
//{
//    /*for (int i=0; i<[self.formItems count]; i++)
//    {
//        if ([[[self.formItems objectAtIndex:i] textField] isEditing] && i!=0)
//        {
//            [[[self.formItems objectAtIndex:i-1] textField] becomeFirstResponder];
//            
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//            
//            break;
//        }
//    }*/
//}
//
//// --------------------------------------------------------------------
//- (void)doneDidTouchDown
//{
//    [self.view endEditing:YES];
//    /* for(TextFieldFormElement *formElement in self.formItems)
//    {
//        if ([formElement.textField isEditing])
//        {
//            [formElement.textField resignFirstResponder];
//            break;
//        }
//    }*/
//}
//

#pragma mark ---
// -----------------------------------------------------------------------------
#pragma mark - PickerView view delegate & data source methods.
// -----------------------------------------------------------------------------

// Number of components.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    int count = 0;
    if (pickerType == 1)
    {
        count = (int)[arrCource count];
    }else if (pickerType == 2)
    {
        count = (int)[arrSubject count];
    }else if (pickerType == 3)
    {
        count = (int)[arrSkill count];
    }else if (pickerType == 4)
    {
        count = (int)[arrStandard count];
    }else if (pickerType == 5)
    {
        count = (int)[arrChapter count];
    }else if (pickerType == 6)
    {
        count = (int)[arrObjective count];
    }
    return count;
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //NSMutableDictionary *tempDict ;
    NSString *strData =@"";
    
    /*if (self.pickerType.tag == 102)
    {
        tempDict = [dataArray objectAtIndex: row];
    }else  if (self.pickerType.tag == 202)
    {
        tempDict = [PTZArray objectAtIndex: row];
    }*/
    if (pickerType == 1)
    {
        strData = [arrCource objectAtIndex: row];
    }else if (pickerType == 2)
    {
        strData = [arrSubject objectAtIndex: row];
    }else if (pickerType == 3)
    {
        strData = [arrSkill objectAtIndex: row];
    }else if (pickerType == 4)
    {
        strData = [arrStandard objectAtIndex: row];
    }else if (pickerType == 5)
    {
        strData = [arrChapter objectAtIndex: row];
    }else if (pickerType == 6)
    {
        strData = [arrObjective objectAtIndex: row];
    }
    
    
    
    return strData;//[tempDict valueForKey:@"name"];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
   /* if (self.pickerType.tag == 102)
    {
        selectedDict = [dataArray objectAtIndex: row];
        strSubUser = [selectedDict valueForKey:@"name"];
    }else  if (self.pickerType.tag == 202)
    {
        selectedPresetIndex =(int) row;
    }*/
    
    if (pickerType == 1)
    {
        strCource = [arrCource objectAtIndex: row];
        //self.btnSelectCource.titleLabel.text =  strCource;
        [self.btnSelectCource setTitle:strCource forState:UIControlStateNormal];

        
    }else if (pickerType == 2)
    {
        strSubject = [arrSubject objectAtIndex: row];
        //self.btnSelectSubject.titleLabel.text = strSubject ;
        [self.btnSelectSubject setTitle:strSubject forState:UIControlStateNormal];

    }else if (pickerType == 3)
    {
        strSkil = [arrSkill objectAtIndex: row];
        //self.btnSelectSkill.titleLabel.text =  strSkil;
        [self.btnSelectSkill setTitle:strSkil forState:UIControlStateNormal];

    }else if (pickerType == 4)
    {
        strStandard = [arrStandard objectAtIndex: row];
        //self.btnSelectStandard.titleLabel.text = strStandard;
        [self.btnSelectStandard setTitle:strStandard forState:UIControlStateNormal];

    }else if (pickerType == 5)
    {
        strChapter = [arrChapter objectAtIndex: row];
        //self.btnSelectChapter.titleLabel.text = strChapter;
        [self.btnSelectChapter setTitle:strChapter forState:UIControlStateNormal];

    }else if (pickerType == 6)
    {
        strObjective = [arrObjective objectAtIndex: row];
        //self.btnSelectObjective.titleLabel.text = strObjective;
        [self.btnSelectObjective setTitle:strObjective forState:UIControlStateNormal];

    }
    
}


/*- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        
        //tView.font = [UIFont systemFontOfSize:kFontSize];
        tView.textAlignment = NSTextAlignmentCenter;
        
    }
    // Fill the label text here
    NSMutableDictionary *tempDict;
    if (self.pickerType.tag == 102)
    {
        tempDict = [dataArray objectAtIndex: row];
    }else  if (self.pickerType.tag == 202)
    {
        tempDict = [PTZArray objectAtIndex: row];
    }
    
    tView.text = [tempDict valueForKey:@"name"];
    return tView;
}
*/
#pragma mark - UITABLEVIEW Delegate method 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    int count = 0;
    if(tableView.tag == 1)
    {
        count = (int)[arrSkill count];
    }else if (tableView.tag == 2)
    {
        count = (int)[arrObjective count];
    }
    
    return count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    // Set the data for this cell:
    if (tableView.tag == 1)
    {
        cell.textLabel.text = [arrSkill objectAtIndex:indexPath.row];
        if ([selectedSkill containsObject:[arrSkill objectAtIndex:indexPath.row]]) {
            cell.imageView.image = [UIImage imageNamed:@"checked.png"];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"checked.png"];
            
        }
             UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSkillChecking:)];
             [cell.imageView addGestureRecognizer:tap];
             cell.imageView.userInteractionEnabled = YES;
        

        
    }else if (tableView.tag == 2 )
    {
         cell.textLabel.text = [arrObjective objectAtIndex:indexPath.row];
        if ([selectedObjective containsObject:[arrObjective objectAtIndex:indexPath.row]]) {
            cell.imageView.image = [UIImage imageNamed:@"checked.png"];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"checked.png"];
            
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleObjectiveChecking:)];
        [cell.imageView addGestureRecognizer:tap];
        cell.imageView.userInteractionEnabled = YES;
    }
   
   
    
    // set the accessory view:
    cell.accessoryType =  UITableViewCellAccessoryNone;
    
    return cell;
}

- (void) handleSkillChecking:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint tapLocation = [tapRecognizer locationInView:self.tblSkill];
    NSIndexPath *tappedIndexPath = [self.tblSkill indexPathForRowAtPoint:tapLocation];
    
    if ([selectedSkill containsObject:[arrSkill objectAtIndex:tappedIndexPath.row]]) {
        [selectedSkill removeObject:[arrSkill objectAtIndex:tappedIndexPath.row]];
    }
    else {
        [selectedSkill addObject:[arrSkill objectAtIndex:tappedIndexPath.row]];
    }
    [self.tblSkill reloadRowsAtIndexPaths:[NSArray arrayWithObject:tappedIndexPath] withRowAnimation: UITableViewRowAnimationFade];
}

- (void) handleObjectiveChecking:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint tapLocation = [tapRecognizer locationInView:self.tblObjective];
    NSIndexPath *tappedIndexPath = [self.tblObjective indexPathForRowAtPoint:tapLocation];
    
    if ([selectedObjective containsObject:[arrObjective objectAtIndex:tappedIndexPath.row]]) {
        [selectedObjective removeObject:[arrObjective objectAtIndex:tappedIndexPath.row]];
    }
    else {
        [selectedObjective addObject:[arrObjective objectAtIndex:tappedIndexPath.row]];
    }
    [self.tblObjective reloadRowsAtIndexPaths:[NSArray arrayWithObject:tappedIndexPath] withRowAnimation: UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int selectedRow = (int)indexPath.row;
    NSLog(@"touch on row %d", selectedRow);
    if (tableView.tag == 1)
    {
        if ([selectedSkill containsObject:[arrSkill objectAtIndex:indexPath.row]]) {
            [selectedSkill removeObject:[arrSkill objectAtIndex:indexPath.row]];
        }
        else {
            [selectedSkill addObject:[arrSkill objectAtIndex:indexPath.row]];
        }
        [self.tblSkill reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
        
    }else if (tableView.tag == 2)
    {
        if ([selectedObjective containsObject:[arrObjective objectAtIndex:indexPath.row]]) {
            [selectedObjective removeObject:[arrObjective objectAtIndex:indexPath.row]];
        }
        else {
            [selectedObjective addObject:[arrObjective objectAtIndex:indexPath.row]];
        }
        [self.tblObjective reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
    }
        
    
}


#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Action Event
- (IBAction)btnDoneClick:(id)sender
{
    if (pickerType == 1)
    {
        //self.btnSelectCource.titleLabel.text =  strCource;
        [self.btnSelectCource setTitle:strCource forState:UIControlStateNormal];
        
    }else if (pickerType == 2)
    {
        //self.btnSelectSubject.titleLabel.text = strSubject ;
        [self.btnSelectSubject setTitle:strSubject forState:UIControlStateNormal];
    }else if (pickerType == 3)
    {
        //self.btnSelectSkill.titleLabel.text =  strSkil;
        [self.btnSelectSkill setTitle:strSkil forState:UIControlStateNormal];
    }else if (pickerType == 4)
    {
        //self.btnSelectStandard.titleLabel.text = strStandard;
        [self.btnSelectStandard setTitle:strStandard forState:UIControlStateNormal];
    }else if (pickerType == 5)
    {
        //self.btnSelectChapter.titleLabel.text = strChapter;
        [self.btnSelectChapter setTitle:strChapter forState:UIControlStateNormal];
    }else if (pickerType == 6)
    {
        //self.btnSelectObjective.titleLabel.text = strObjective;
        [self.btnSelectObjective setTitle:strObjective forState:UIControlStateNormal];
    }

    
    [UIView beginAnimations:@"fade" context:NULL];
    [UIView setAnimationDuration:1.0];
    self.pickerView.frame = CGRectMake(self.pickerView.frame.origin.x, 2000, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction)btnCancelClick:(id)sender
{
    [UIView beginAnimations:@"fade" context:NULL];
    [UIView setAnimationDuration:1.0];
    self.pickerView.frame = CGRectMake(self.pickerView.frame.origin.x, 2000, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction)btnSelectCourceClick:(id)sender
{
    pickerType =1;
    [self showPicker];
}

- (IBAction)btnSelectSubjectClick:(id)sender
{
     pickerType =2;
    [self showPicker];
}

- (IBAction)btnSelectStandardClick:(id)sender
{
     pickerType =4;
    [self showPicker];
}

- (IBAction)btnSelectChapterClick:(id)sender
{
     pickerType =5;
    [self showPicker];
}

- (IBAction)btnSelectSkillClick:(id)sender
{
     pickerType =3;
    [self showPicker];
}

- (IBAction)btnSelectObjectiveClick:(id)sender
{
     pickerType =6;
    [self showPicker];
}

-(void)showPicker
{
    [self.view endEditing:YES];
    [self.picker setDelegate:self];
    [self.picker setDataSource: self];
    [UIView beginAnimations:@"fade" context:NULL];
    [UIView setAnimationDuration:1.0];
    self.pickerView.frame = CGRectMake(self.pickerView.frame.origin.x, 20, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
    [UIView commitAnimations];

}

- (IBAction)SGMValueChanged:(id)sender
{
    
    self.objectiveView.alpha = 0.0;
    self.resourceView.alpha = 0.0;
    self.homeworkView.alpha = 0.0;
    self.assessmentView.alpha = 0.0;
    
    //NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    //[self.segmentedControll setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
   
    
    UIColor *deselectedColor = [UIColor colorWithRed:0.0f/255.0f green:174.0f/255.0f blue:240.0f/255.0f alpha:1.0];
    UIColor *selectedColor = [UIColor colorWithRed: 0.0f/255.0 green: 127.0f/255.0 blue: 197.0/255.0 alpha:1.0];
    
    self.segmentedControll.backgroundColor = deselectedColor;
    for (id subview in [self.segmentedControll subviews]) {
        if ([subview isSelected])
            [subview setTintColor:selectedColor];
        else
            [subview setTintColor:deselectedColor];
    }
    
    
    /*int numSegments = [self.segmentedControll.subviews count];
    
    // Reset segment's color (non selected color)
    for( int i = 0; i < numSegments; i++ ) {
        // reset color
        [[self.segmentedControll.subviews objectAtIndex:i] setTintColor:nil];
        [[self.segmentedControll.subviews objectAtIndex:i] setTintColor:deselectedColor];
    }
    
    // Sort segments from left to right
    NSArray *sortedViews = [self.segmentedControll.subviews sortedArrayUsingFunction:compareViewsByOrigin context:NULL];
    
    // Change color of selected segment
    [[sortedViews objectAtIndex:self.segmentedControll.selectedSegmentIndex] setTintColor:selectedColor];
    
    // Remove all original segments from the control
    for (id view in self.segmentedControll.subviews) {
        [view removeFromSuperview];
    }
    
    // Append sorted and colored segments to the control
    for (id view in sortedViews) {
        [self.segmentedControll addSubview:view];
    }*/


    
    
    [UIView beginAnimations:@"fade" context:NULL];
    [UIView setAnimationDuration:1.0];
    //self.pickerViewBG.frame = CGRectMake(0, self.scrollView.frame.origin.y, self.pickerViewBG.frame.size.width, self.pickerViewBG.frame.size.height);
    //self.scrollView.alpha = 0.0;
    
    if (self.segmentedControll.selectedSegmentIndex == 0) {
        
        self.objectiveView.alpha = 1.0;
    }else if (self.segmentedControll.selectedSegmentIndex == 1) {
        
        self.resourceView.alpha = 1.0;
    }else if (self.segmentedControll.selectedSegmentIndex == 2) {
        
        self.homeworkView.alpha = 1.0;
    }else if (self.segmentedControll.selectedSegmentIndex == 3) {
        
        self.assessmentView.alpha = 1.0 ;
    }
    
    [UIView commitAnimations];
}

- (IBAction)btnObjSaveClick:(id)sender
{
    
}

- (IBAction)btnObjCancelClick:(id)sender
{
    
}


- (IBAction)btnResSaveClick:(id)sender
{
    
}
- (IBAction)btnResCancelClick:(id)sender
{
    
}

- (IBAction)btnHomeSaveClick:(id)sender
{
    
}
- (IBAction)btnHomeCancelClick:(id)sender
{
    
}

- (IBAction)btnOpenDetailClick:(id)sender
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlFile =@"";
    NSString* htmlString=@"";
    if ([sender tag] == 101) {
         htmlFile = [[NSBundle mainBundle] pathForResource:@"ch16" ofType:@"html"];
         htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        
    }else if ([sender tag] == 102) {
        htmlFile = [[NSBundle mainBundle] pathForResource:@"" ofType:@"html"];
        htmlString = @"";//[NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        
    }else if ([sender tag] == 103) {
        htmlFile = [[NSBundle mainBundle] pathForResource:@"lout" ofType:@"html"];
        htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        
    }else if ([sender tag] == 104) {
        htmlFile = [[NSBundle mainBundle] pathForResource:@"teacherNote" ofType:@"html"];
        htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        
    }else if ([sender tag] == 105) {
        htmlFile = [[NSBundle mainBundle] pathForResource:@"resources" ofType:@"html"];
        htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        
    }else if ([sender tag] == 106) {
        htmlFile = [[NSBundle mainBundle] pathForResource:@"homework" ofType:@"html"];
        htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        
    }else if ([sender tag] == 107)
    {
       htmlFile = [[NSBundle mainBundle] pathForResource:@"exe" ofType:@"html"];
       htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    }
    
    [self.webDetail loadHTMLString:htmlString baseURL:baseURL];
    self.webDetail.scalesPageToFit = YES;
    
    [self showDetailPage];
    
}

- (IBAction)btnOpenOfficeClick:(id)sender {
    
//    UIApplication *ourApplication = [UIApplication sharedApplication];
//    //NSString *URLEncodedText = [self.textBox.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    //NSString *ourPath = [@"readtext://" stringByAppendingString:URLEncodedText];
//    NSString *powerPointFilePath = [[NSBundle mainBundle] pathForResource:@"presentation" ofType:@"pptx"];
//    NSURL *powerPointFileURL = [NSURL fileURLWithPath:powerPointFilePath];
//    
//    NSString *URLEncodedText = [powerPointFilePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//[@"www.itrs.net/Links/2012Summer/Test.pptx" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *ourURL = [NSURL URLWithString:[NSString stringWithFormat:@"powerpoint://%@",URLEncodedText]];
//    if ([ourApplication canOpenURL:ourURL]) {
//        [ourApplication openURL:ourURL];
//    }
//    else {
//        //Display error
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Receiver Not Found" message:@"The Receiver App is not installed. It must be installed to send text." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
//        
//    }
     NSString *filePath = [[NSBundle mainBundle] pathForResource:@"presentation" ofType:@"pptx"];
    
    if ([sender tag] ==1001)
    {
        filePath = [[NSBundle mainBundle] pathForResource:@"kebo116" ofType:@"docx"];
    }else if ([sender tag] ==1002)
    {
        filePath = [[NSBundle mainBundle] pathForResource:@"New_Lesson_Plan" ofType:@"xls"];
    }else if ([sender tag] ==1003)
    {
        filePath = [[NSBundle mainBundle] pathForResource:@"cssession3" ofType:@"ppt"];
    }else if ([sender tag] ==1004)
    {
        filePath = [[NSBundle mainBundle] pathForResource:@"kebo122" ofType:@"pdf"];
    }else if ([sender tag] ==1005)
    {
        filePath = [[NSBundle mainBundle] pathForResource:@"16_1" ofType:@"png"];
    }else if ([sender tag] ==1006)
    {
        filePath = [[NSBundle mainBundle] pathForResource:@"Unit-Lesson-Planning-Guide" ofType:@"rtf"];
    }
    
    
   
    NSURL *URL = [NSURL fileURLWithPath:filePath];   
    TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.attachmentView andRect:((UIButton *)sender).frame];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        // Store reference to superview (UIActionSheet) to allow dismissal
        openInAppActivity.superViewController = activityViewController;
        // Show UIActivityViewController
        [self presentViewController:activityViewController animated:YES completion:NULL];
    } else {
        // Create pop up
        self.activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        // Store reference to superview (UIPopoverController) to allow dismissal
        openInAppActivity.superViewController = self.activityPopoverController;
        // Show UIActivityViewController in popup
        [self.activityPopoverController presentPopoverFromRect:((UIButton *)sender).frame inView:self.attachmentView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }

}

- (IBAction)btnViewClick:(id)sender
{
    for (UIView *view in [self.optionalView subviews])
    {
        if ([view isKindOfClass: [UIView class] ])
        {
            for (UIView *subview in [view subviews])
            {
                if ([subview isKindOfClass: [UITextView class] ])
                {
                    UITextView *txtView = (UITextView *)subview;
                    txtView.editable = NO;
                }else  if ([subview isKindOfClass: [UIButton class] ])
                {
                    subview.userInteractionEnabled = NO;
                }
            }
        }
    }
    
    self.madatoryView.userInteractionEnabled= NO;
    
    self.btnView.userInteractionEnabled = YES;
    self.btnEdit.userInteractionEnabled = YES;
}


- (IBAction)btnEditClick:(id)sender
{
    for (UIView *view in [self.optionalView subviews])
    {
        if ([view isKindOfClass: [UIView class] ])
        {
            for (UIView *subview in [view subviews])
            {
                if ([subview isKindOfClass: [UITextView class] ])
                {
                    UITextView *txtView = (UITextView *)subview;
                    txtView.editable = YES;
                }else if ([subview isKindOfClass: [UIButton class] ])
                {
                    subview.userInteractionEnabled = YES;
                }
            }
        }
    }
    
    self.madatoryView.userInteractionEnabled= YES;
}


#pragma mark --
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void) hideKeyBoard:(id) sender
{
    // Do whatever such as hiding the keyboard
    [self.view endEditing:YES];
}

- (void) handleWebviewTabing:(UITapGestureRecognizer *)tapRecognizer
{
    //UIWebView *webView = (UIWebView *)tapRecognizer.view;
    
    [self showDetailPage];
}


-(void)showDetailPage
{
    [UIView beginAnimations:@"fade" context:NULL];
    [UIView setAnimationDuration:1.0];
    self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, 0, self.detailView.frame.size.width, self.detailView.frame.size.height);
    [UIView commitAnimations];

}

-(void)hideDetailPage
{
    [UIView beginAnimations:@"fade" context:NULL];
    [UIView setAnimationDuration:1.0];
    self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, 2000, self.detailView.frame.size.width, self.detailView.frame.size.height);
    [UIView commitAnimations];
    
}
- (void)setRoundedBorder:(float) radius borderWidth:(float)borderWidth color:(UIColor*)color controller:(id)controller
{
    CALayer * l = [controller layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:radius];
    // You can even add a border
    [l setBorderWidth:borderWidth];
    [l setBorderColor:[color CGColor]];
}


- (IBAction)btnXClick:(id)sender {
    [self hideDetailPage];
}

- (IBAction)btnLogoutClick:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
