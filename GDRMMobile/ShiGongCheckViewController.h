//
//  ShiGongCheckViewController.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/1/13.
//
//

#import <UIKit/UIKit.h>
#import "InspectionConstructionViewController.h"
#import "InspectionConstruction.h"
#import "DateSelectController.h"
#import "UserPickerViewController.h"
#import "CaseInfoPickerViewController.h"
#import "CasePrintViewController.h"
#import "ShiGongCheckViewController.h"
#import "MaintainPlanPickerViewController.h"
#import "RoadInspectViewController.h"
@interface ShiGongCheckViewController :UIViewController<UITextFieldDelegate,CaseIDHandler,UserPickerDelegate,DatetimePickerHandler,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,MaintainPlanPickerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *uiBtnSave;
@property (weak, nonatomic) IBOutlet UIButton *uiBtnAdd;
@property (weak, nonatomic) IBOutlet UIButton *uiBtnFujian;
@property (weak, nonatomic) IBOutlet UITableView *tableCloseList;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContent;

@property (weak, nonatomic) IBOutlet UITextField *check_date;
@property (weak, nonatomic) IBOutlet UITextField *textchecktype;
@property (weak, nonatomic) IBOutlet UITextField *textcheckitem1;
@property (weak, nonatomic) IBOutlet UITextField *textcheckitem2;
@property (weak, nonatomic) IBOutlet UITextField *textcheckitem3;
@property (weak, nonatomic) IBOutlet UITextField *textcheckitem4;
@property (weak, nonatomic) IBOutlet UITextField *textrectify_no;
@property (weak, nonatomic) IBOutlet UITextField *textstopwork_no;
@property (weak, nonatomic) IBOutlet UITextView *textcheck_remark;

@property (weak, nonatomic) IBOutlet UITextField *textchecker;
@property (weak, nonatomic) IBOutlet UITextField *textsafety;
@property (weak, nonatomic) IBOutlet UITextField *textduty_opinion;
@property (weak, nonatomic) IBOutlet UITextField *textMaintain;
@property (weak, nonatomic) IBOutlet UISwitch *switchisZhengGai;
@property (weak, nonatomic) IBOutlet UISwitch *switchisTingGong;
@property (weak, nonatomic) IBOutlet UIButton *buttonTingGong;
@property (weak, nonatomic) IBOutlet UIButton *buttonZhengGai;
@property (weak, nonatomic) IBOutlet UILabel *labelZhengGai;
@property (weak, nonatomic) IBOutlet UILabel *labelTingGong;


@property (nonatomic, retain) NSString *inspectionID;
@property (nonatomic, assign) RoadInspectViewController *roadInspectVC;


@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (retain, nonatomic) NSURL *pdfFormatFileURL;
@property (retain, nonatomic) NSURL *pdfFileURL;
- (IBAction)btnAddNew:(UIButton *)sender;
- (IBAction)btnSave:(UIButton *)sender;
- (IBAction)btnTongzhishu:(UIButton *)sender;
- (IBAction)btnPhoto:(UIButton *)sender;
- (IBAction)textTouch:(UITextField *)sender;
- (IBAction)btnZhengGai:(UISwitch *)sender;
- (IBAction)btnTingGong:(UISwitch *)sender;

- (IBAction)userSelect:(UITextField *)sender;
- (IBAction)toAttachmentView:(id)sender;
- (IBAction)toPrintView:(id)sender;
- (IBAction)btnDeleteDoc:(id)sender;
@end
