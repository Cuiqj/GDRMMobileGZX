//
//  CaseZhengGaiTongZhiShuPrintViewController.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/1/16.
//
//

#import "CaseZhengGaiTongZhiShuPrintViewController.h"
#import "AtonementNotice.h"
#import "CaseDeformation.h"
#import "CaseProveInfo.h"
#import "Citizen.h"
#import "CaseInfo.h"
#import "RoadSegment.h"
#import "OrgInfo.h"
#import "UserInfo.h"
#import "NSNumber+NumberConvert.h"
#import "Systype.h"
#import "MatchLaw.h"
#import "MatchLawDetails.h"
#import "LawItems.h"
#import "LawbreakingAction.h"
#import "Laws.h"
#import "FileCode.h"
#import "RectificationNotice.h"
#import "MaintainPlanCheck.h"
#import "MaintainPlan.h"

static NSString * xmlName = @"ZhengGaiTongZhiShu";

@interface CaseZhengGaiTongZhiShuPrintViewController ()
@property (nonatomic,retain) AtonementNotice *notice;
//@property (nonatomic,retain) NSString *maintainplanID;
@property (nonatomic, retain) RectificationNotice *RectificationNoticeInfo;
@property (nonatomic, retain) NSString *autoNumber;
@property (nonatomic,strong) UIPopoverController *pickerPopover;
//- (void)generateDefaultsForNotice:(AtonementNotice *)notice;
@end

@implementation CaseZhengGaiTongZhiShuPrintViewController
@synthesize labelCaseCode = _labelCaseCode;

@synthesize textnumber = _textnumber;
@synthesize textdisobey_item = _textdisobey_item;
@synthesize textobey_tiao = _textobey_tiao;
@synthesize textobey_kuan = _textobey_kuan;
@synthesize textmoney = _textmoney;
@synthesize textrecorder = _textrecorder;
@synthesize textcitizen = _textcitizen;
@synthesize textsend_date = _textsend_date;
@synthesize textalter_item = _textalter_item;
@synthesize textconstruct_org = _textconstruct_org;
@synthesize textproject_address = _textproject_address;
@synthesize caseID = _caseID;
//@synthesize maintainplanID = _maintainplanID;
@synthesize notice = _notice;

- (void)viewDidLoad
{
    // [super setCaseID:self.caseID];
    // [super setMaintainplanID:self.maintainplanID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
    self.view.frame = viewFrame;
    /*modify by lxm 不能实时更新*/
    if (![self.caseID isEmpty]) {
        self.RectificationNoticeInfo = [RectificationNotice rectificationNoticeproveInfoForCheckID:self.caseID];
        
        if(self.RectificationNoticeInfo==nil){
            self.RectificationNoticeInfo =[RectificationNotice newDataObjectWithEntityName:@"RectificationNotice"];
            self.RectificationNoticeInfo.maintainPlanCheck_id=self.caseID;
        }
        [self generateDefaultInfo:self.RectificationNoticeInfo];
        [self pageLoadInfo];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)generateDefaultInfo:(RectificationNotice *)rectificationNoticeInfo{

    ;
}
- (void)pageLoadInfo{
    
    RectificationNotice *RectificationNoticeInfo = [RectificationNotice rectificationNoticeproveInfoForCheckID:self.caseID];
    self.textnumber.text=RectificationNoticeInfo.number;
    
    // self.textproject_address.text=RectificationNoticeInfo.project_address;
    //self.textconstruct_org.text=RectificationNoticeInfo.construct_org;
    
    MaintainPlanCheck *iPlanCheck= [[MaintainPlanCheck maintainCheckForID:self.caseID] objectAtIndex:0];
    //MaintainPlan *iPlan=  [MaintainPlan maintainPlanInfoForID:self.maintainplanID];
    MaintainPlan *iPlan=  [MaintainPlan maintainPlanInfoForID:iPlanCheck.maintainPlan_id];
    self.textproject_address.text=iPlan.project_address;
    self.textconstruct_org.text=iPlan.construct_org;
    
    self.textdisobey_item.text=RectificationNoticeInfo.disobey_item;
    self.textalter_item.text=RectificationNoticeInfo.alter_item;
    self.textobey_tiao.text=RectificationNoticeInfo.obey_tiao;
    self.textobey_kuan.text=RectificationNoticeInfo.obey_kuan;
    self.textmoney.text=RectificationNoticeInfo.money;
    self.textchinese_money.text=RectificationNoticeInfo.chinese_money;
    self.textrecorder.text=RectificationNoticeInfo.recorder;
    self.textcitizen.text=RectificationNoticeInfo.citizen;
    //self.textsend_date.text=RectificationNoticeInfo.send_date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.textsend_date.text = [dateFormatter stringFromDate:self.RectificationNoticeInfo.send_date];
    
    
}
- (void)pageSaveInfo{
    //案由
    self.RectificationNoticeInfo.number = self.textnumber.text;
    self.RectificationNoticeInfo.disobey_item=self.textdisobey_item.text;
    self.RectificationNoticeInfo.alter_item=self.textalter_item.text;
    self.RectificationNoticeInfo.obey_tiao=self.textobey_tiao.text;
    self.RectificationNoticeInfo.obey_kuan=self.textobey_kuan.text;
    self.RectificationNoticeInfo.money=self.textmoney.text;
    self.RectificationNoticeInfo.chinese_money=self.textchinese_money.text;
    self.RectificationNoticeInfo.recorder=self.textrecorder.text;
    self.RectificationNoticeInfo.citizen=self.textcitizen.text;
    self.RectificationNoticeInfo.year=@"2017";
    //self.RectificationNoticeInfo.send_date=sel
    [[AppDelegate App] saveContext];
    
}
-(NSURL *)toFullPDFWithPath:(NSString *)filePath{
     [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.RectificationNoticeInfo];
        UIGraphicsEndPDFContext();
        
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

-(NSURL *)toFormedPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawDateTable:xmlName withDataModel:self.RectificationNoticeInfo];
        UIGraphicsEndPDFContext();
        
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}
#pragma mark - prepare for Segue
//初始化各弹出选择页面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *segueIdentifier= [segue identifier];
    if ([segueIdentifier isEqualToString:@"toDateTimePicker"]) {
        DateSelectController *dsVC=segue.destinationViewController;
        dsVC.dateselectPopover=[(UIStoryboardPopoverSegue *) segue popoverController];
        dsVC.delegate=self;
        dsVC.pickerType=1;
        dsVC.textFieldTag = self.textsend_date.tag;
        dsVC.datePicker.maximumDate=[NSDate date];
        [dsVC showPastDate:[NSDate date]];
    }else if ([segueIdentifier isEqualToString:@"toDateTimePicker2"]) {
        DateSelectController *dsVC=segue.destinationViewController;
        dsVC.dateselectPopover=[(UIStoryboardPopoverSegue *) segue popoverController];
        dsVC.delegate=self;
        dsVC.pickerType=1;
        dsVC.textFieldTag = self.textsend_date.tag;
        dsVC.datePicker.maximumDate=[NSDate date];
        [dsVC showPastDate:self.RectificationNoticeInfo.send_date];
    }
}

//时间选择
- (IBAction)selectDateAndTime:(id)sender{
    UITextField* textField = (UITextField* )sender;
    switch (textField.tag) {
        case 100:
            [self performSegueWithIdentifier:@"toDateTimePicker" sender:self];
            break;
        case 101:
            [self performSegueWithIdentifier:@"toDateTimePicker" sender:self];
            break;
        default:
            [self performSegueWithIdentifier:@"toDateTimePicker" sender:self];
            break;
    }
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 100:
        case 101:
        case 200:
        case 201:
        case 202:
            return NO;
            break;
        default:
            return YES;
            break;
    }
}

- (void)setPastDate:(NSDate *)date withTag:(int)tag{
    
    self.RectificationNoticeInfo.send_date = date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        self.textsend_date.text = [dateFormatter stringFromDate:date];
     
}
-(void)setDate:(NSString *)date{
    self.textsend_date.text =date;
}

- (IBAction)userSelect:(UITextField *)sender {
    //self.textFieldTag = sender.tag;
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        UserPickerViewController *acPicker=[[UserPickerViewController alloc] init];
        acPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover=self.pickerPopover;
    }
}

- (void)setUser:(NSString *)name andUserID:(NSString *)userID{
//    if (self.textFieldTag == 200) {
//        self.textprover1.text = name;
//        self.textprover1_duty.text = [UserInfo orgAndDutyForUserName:name];
//    }else if (self.textFieldTag == 201){
//        self.textprover2.text = name;
//        self.textprover2_duty.text = [UserInfo orgAndDutyForUserName:name];
//    }else if (self.textFieldTag == 202){
//        self.textrecorder.text = name;
//        self.textrecorder_duty.text = [UserInfo orgAndDutyForUserName:name];
//    }
    self.textrecorder.text=name;
}
@end