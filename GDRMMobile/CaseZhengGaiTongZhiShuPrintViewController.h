//
//  CaseZhengGaiTongZhiShuPrintViewController.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/1/16.
//
//
#import "CasePrintViewController.h"
#import "RectificationNotice.h"
#import "DateSelectController.h"
#import "UserPickerViewController.h"

@interface CaseZhengGaiTongZhiShuPrintViewController : CasePrintViewController<DatetimePickerHandler, UserPickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelCaseCode;

@property (weak, nonatomic) IBOutlet UILabel *labelDateSend;


@property (weak, nonatomic) IBOutlet UITextField *textnumber;
@property (weak, nonatomic) IBOutlet UITextField *textdisobey_item;
@property (weak, nonatomic) IBOutlet UITextField *textobey_tiao;
@property (weak, nonatomic) IBOutlet UITextField *textobey_kuan;
@property (weak, nonatomic) IBOutlet UITextField *textchinese_money;
@property (weak, nonatomic) IBOutlet UITextField *textmoney;
@property (weak, nonatomic) IBOutlet UITextField *textrecorder;
@property (weak, nonatomic) IBOutlet UITextField *textcitizen;
@property (weak, nonatomic) IBOutlet UITextField *textsend_date;
@property (weak, nonatomic) IBOutlet UITextField *textconstruct_org;
@property (weak, nonatomic) IBOutlet UITextField *textproject_address;
@property (weak, nonatomic) IBOutlet UITextView *textalter_item;
- (void)generateDefaultInfo:(RectificationNotice *)rectificationNoticeInfo;
- (IBAction)selectDateAndTime:(id)sender;

- (IBAction)userSelect:(UITextField *)sender;
@end
