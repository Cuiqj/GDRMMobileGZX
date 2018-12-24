//
//  CaseTingGongTongZhiShuPrintViewController.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/1/16.
//
//

#import "CasePrintViewController.h"
#import "DateSelectController.h"
#import "UserPickerViewController.h"
@interface CaseTingGongTongZhiShuPrintViewController : CasePrintViewController<DatetimePickerHandler, UserPickerDelegate>



@property (weak, nonatomic) IBOutlet UITextField *textnumber;
@property (weak, nonatomic) IBOutlet UITextField *textconstruct_org;
@property (weak, nonatomic) IBOutlet UITextField *textproject_address;
@property (weak, nonatomic) IBOutlet UITextField *textdisobey_item;
@property (weak, nonatomic) IBOutlet UITextField *textobey_tiao;
@property (weak, nonatomic) IBOutlet UITextField *textobey_kuan;
@property (weak, nonatomic) IBOutlet UITextField *textmoney;
@property (weak, nonatomic) IBOutlet UITextField *textchinese_money;
@property (weak, nonatomic) IBOutlet UITextField *textrecorder;
@property (weak, nonatomic) IBOutlet UITextField *textcitizen;
@property (strong, nonatomic) IBOutlet UITextField *textsend_date;
- (IBAction)selectDateAndTime:(id)sender;

- (IBAction)userSelect:(UITextField *)sender;
@end
