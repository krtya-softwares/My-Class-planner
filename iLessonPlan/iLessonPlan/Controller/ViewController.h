//
//  ViewController.h
//  Test App
//
//  Created by krtya on 21/07/14.
//  Copyright (c) 2014 Krtya. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "KSEnhancedKeyboard.h"


@interface ViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>//, KSEnhancedKeyboardDelegate>
{
    PFObject *object;
}
@property (nonatomic,retain) IBOutlet PFObject *object;


@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *btnLogoutClick;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *madatoryView;
@property (weak, nonatomic) IBOutlet UITextField *txtplanTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtPreparedBy;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectCource;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectSubject;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectStandard;
@property (weak, nonatomic) IBOutlet UITextField *txtHours;
@property (weak, nonatomic) IBOutlet UITextField *txtMinute;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectChapter;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectSkill;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectObjective;
@property (weak, nonatomic) IBOutlet UITableView *tblSkill;
@property (weak, nonatomic) IBOutlet UITableView *tblObjective;

@property (weak, nonatomic) IBOutlet UIView *optionalView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControll;
@property (weak, nonatomic) IBOutlet UIView *objectiveView;
@property (weak, nonatomic) IBOutlet UIWebView *webIntroduction;
@property (weak, nonatomic) IBOutlet UIWebView *webGeneral;
@property (weak, nonatomic) IBOutlet UIWebView *webSpecific;
@property (weak, nonatomic) IBOutlet UIWebView *webLearningOutComes;
@property (weak, nonatomic) IBOutlet UIWebView *webTeacherNote;

@property (weak, nonatomic) IBOutlet UIView *resourceView;
@property (weak, nonatomic) IBOutlet UIWebView *webResource;
@property (weak, nonatomic) IBOutlet UIView *attachmentView;

@property (weak, nonatomic) IBOutlet UIView *homeworkView;
@property (weak, nonatomic) IBOutlet UIWebView *webHomework;
@property (weak, nonatomic) IBOutlet UIButton *btnView;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@property (weak, nonatomic) IBOutlet UIView *assessmentView;
@property (weak, nonatomic) IBOutlet UIWebView *webAssessment;

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *btnX;

@property (weak, nonatomic) IBOutlet UIButton *btnUserName;
@property (weak, nonatomic) IBOutlet UIWebView *webDetail;
- (IBAction)btnDoneClick:(id)sender;
- (IBAction)btnCancelClick:(id)sender;
- (IBAction)btnSelectCourceClick:(id)sender;
- (IBAction)btnSelectSubjectClick:(id)sender;
- (IBAction)btnSelectStandardClick:(id)sender;
- (IBAction)btnSelectChapterClick:(id)sender;
- (IBAction)btnSelectSkillClick:(id)sender;
- (IBAction)btnSelectObjectiveClick:(id)sender;
- (IBAction)SGMValueChanged:(id)sender;
- (IBAction)btnObjSaveClick:(id)sender;
- (IBAction)btnObjCancelClick:(id)sender;

- (IBAction)btnResSaveClick:(id)sender;
- (IBAction)btnResCancelClick:(id)sender;

- (IBAction)btnHomeSaveClick:(id)sender;
- (IBAction)btnHomeCancelClick:(id)sender;

- (IBAction)btnOpenDetailClick:(id)sender;

- (IBAction)btnOpenOfficeClick:(id)sender;

- (IBAction)btnXClick:(id)sender;
- (IBAction)btnLogoutClick:(id)sender;
@end
