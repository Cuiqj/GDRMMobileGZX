//
//  CaseParkingNodePrintViewController.h
//  GDXERHMMobile
//
//  Created by XU SHIWEN on 13-9-3.
//
//

#import "CasePrintViewController.h"
#import "ParkingNode.h"
#import "UserPickerViewController.h"
#import "RadioButton.h"
#import "AccInfoPickerViewController.h"
#import "AutoNumerPickerViewController.h"

@interface CaseParkingNodePrintViewController : CasePrintViewController<UserPickerDelegate,UITextFieldDelegate,UIAlertViewDelegate,AutoNumberPickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldCitizenName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldHappenDate;     //  案发时间
@property (weak, nonatomic) IBOutlet UITextField *textPrintDate;           //打印时间
@property (weak, nonatomic) IBOutlet UITextField *textFieldRoadName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldKM;             //路段
@property (weak, nonatomic) IBOutlet UITextField *textFieldCaeeReason;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPeriodLimit;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOfficeAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAutomobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCarType;
@property (weak, nonatomic) IBOutlet UITextField *textFieldInstrument;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOrgName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEnforcerName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEnforcerNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTelephone;
@property (weak, nonatomic) IBOutlet RadioButton *radioButtonCaseDisposal1;
@property (weak, nonatomic) IBOutlet RadioButton *radioButtonCaseDisposal2;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPlacePrefix;
@property (weak, nonatomic) IBOutlet UITextField *textFieldStationStart;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCaseShortDescription;
@property (weak, nonatomic) IBOutlet UITextField *textFieldParkingNodeAddress;
@property (weak, nonatomic) IBOutlet UILabel     *labelSendDate;
@property (weak, nonatomic)  UIButton     *print;




//- (IBAction)textFieldAutomobileNumber_touched:(UITextField *)sender;
@property (nonatomic, assign) int textFieldTag;
- (IBAction)userSelected:(UITextField *)sender;
- (IBAction)showAutoNumerPicker:(id)sender;
- (IBAction)printXieBanTongZhiDan:(UIButton *)sender;

@end
