//
//  CaseParkingNodePrintViewController.m
//  GDXERHMMobile
//
//  Created by XU SHIWEN on 13-9-3.
//
//

#import "CaseParkingNodePrintViewController.h"
#import "CaseInfo.h"
#import "Citizen.h"
#import "RoadSegment.h"
#import "ParkingNode.h"
#import "CaseProveInfo.h"
#import "Systype.h"
#import "OrgInfo.h"
#import "NSString+MyStringProcess.h"
#import "ParkingNode.h"
#import "AutoNumerPickerViewController.h"
#import "CaseServiceReceiptViewController.h"
#import "UserInfo.h"


static NSString * xmlName = @"AtonementNoticeTable123";
static NSString * xmlName1 = @"AssistanceNoticeTable";


typedef enum _kTextFieldTag {
    kTextFieldTagCitizenName = 0x10,
    kTextFieldTagHappenDate,
    kTextFieldTagAutoMobileNumber,
    kTextFieldTagPlacePrefix,
    kTextFieldTagStationStart,
    kTextFieldTagCaseShortDescription,
    kTextFieldTagParkingNodeAddress,
    kTextFieldTagPeriodLimit,
    kTextFieldTagOfficeAddress
} kTextFieldTag;

@interface CaseParkingNodePrintViewController () <UITextFieldDelegate>
@property (nonatomic, retain) CaseProveInfo *caseProveInfo;
@property (nonatomic, retain) UIPopoverController *pickerPopover;
@property (nonatomic, retain) UIPopoverController *autoNumberPicker;
//@property (nonatomic, retain) ParkingNode *parkingNode;




@end

@implementation CaseParkingNodePrintViewController

@synthesize caseID = _caseID;
@synthesize caseProveInfo = _caseProveInfo;
@synthesize pickerPopover=_pickerPopover;
@synthesize autoNumberPicker=_autoNumberPicker;
//@synthesize parkingNode=_parkingNode;


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
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_SMALL_WIDTH, VIEW_SMALL_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        [self pageLoadInfo];
    }
    [self assignTagsToUIControl];
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.

}



- (void)pageLoadInfo{
    
    [self pageLoadInfo:nil];
}

- (void)pageLoadInfo:(NSString*)citizenName{
//    //案件
//    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
//    //当事人
//    Citizen *citizen = [Citizen citizenForCitizenName:self.parkingNode.citizen_name nexus:@"当事人" case:self.caseID];
//    if (citizen.automobile_owner && [self.textFieldCitizenName.text isEmpty]) {
//                       self.textFieldCitizenName.text = citizen.automobile_owner;
//                    }
//                    if ([citizen.nexus isEqualToString:@"当事人"]) {
//                       self.textFieldCitizenName.text = citizen.party;
//                    }
//    //时间
//           if (caseInfo.happen_date && !self.parkingNode.date_start) {
//             self.parkingNode.date_start = caseInfo.happen_date;
//              //把date_start显示在textField中
//  
//        }
//           NSDate *startDate =self.parkingNode.date_start;
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//           [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
//           [dateFormatter setLocale:[NSLocale currentLocale]];
//           self.textFieldHappenDate.text = [dateFormatter stringFromDate:startDate];
//   
//           //最下面打印时间
//            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
//           self.textPrintDate.text = [dateFormatter stringFromDate:[NSDate date]];
//    //线  路段
//    self.textFieldRoadName.text =caseInfo.full_roadName;
//    self.textFieldKM.text = [NSString stringWithFormat:@"K%@+%@",caseInfo.station_start_km,caseInfo.station_start_m];
//    
//    //案由
//    CaseProveInfo *caseproveInfo=[CaseProveInfo proveInfoForCase:self.caseID];
//    if (caseproveInfo) {
//        self.textFieldCaeeReason.text = caseproveInfo.case_short_desc;
//    }
//    //扣留车辆或工具
//    if ([self.parkingNode.car_choose isEqualToString:@"√"]) {
//        [self.radioButtonCaseDisposal1 setSelected:YES];
//    }
//    if ([self.parkingNode.instrument_choose isEqualToString:@"√"]) {
//        [self.radioButtonCaseDisposal2 setSelected:YES];
//    }
//    
//    //接受处理和路政机构
//    OrgInfo *orgInfo = [OrgInfo orgInfoForOrgID:caseInfo.organization_id];
//    if (orgInfo.orgshortname) {
//        [self.textFieldOfficeAddress setText:orgInfo.orgshortname];
//        [self.textFieldOrgName setText:orgInfo.orgshortname];
//    }
//
//    
//    //停驶期限
//    NSArray *typeValues = [Systype typeValueForCodeName:@"停驶期限"];
//    if (typeValues.count > 0) {
//        NSString *typeValue = typeValues[0];
//        [self.textFieldPeriodLimit setText:typeValue];
//    } else {
//        [self.textFieldPeriodLimit setText:@"七"];
//    }
//
//    
//    //被扣车牌号码
//    self.textFieldAutomobileNumber.text = self.parkingNode.car_number;
//    
//    //被扣车辆类型
//    self.textFieldCarType.text = self.parkingNode.car_type;
//
//    //被扣工具
//    self.textFieldInstrument.text = self.parkingNode.instrument_name;
//    
//    //路政机构
//    if (orgInfo.orgshortname) {
//        [self.textFieldOfficeAddress setText:orgInfo.orgshortname];
//        [self.textFieldOrgName setText:orgInfo.orgshortname];
//    }
//    
//    //路政人员及编号
//    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
//    NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
//    self.textFieldEnforcerName.text = currentUserName;
//    self.textFieldEnforcerNumber.text = [UserInfo exelawIDForUserName:currentUserName];
//    //联系电话
//    if (![orgInfo.telephone isEmpty]) {
//        self.textFieldTelephone.text = orgInfo.telephone;
//    }else if (![self.parkingNode.telephone isEmpty])
//        self.textFieldTelephone.text = self.parkingNode.telephone;
//    else{
//        self.textFieldTelephone.text = @"020-87438288-958";
//    }



    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo) {
        ParkingNode * parkingNode = nil;
        if (citizenName) {
            parkingNode=  [ParkingNode parkingNodesForCase:self.caseID withCitizenName:citizenName];
        }else{
            
         parkingNode = [ParkingNode parkingNodesForCase:self.caseID];
            
        }
        Citizen *citizen = [Citizen citizenForCitizenName:parkingNode.citizen_name nexus:@"当事人" case:self.caseID];
        if (citizen)
        {
            //当事人
            if (citizen.automobile_owner && [self.textFieldCitizenName.text isEmpty]) {
                self.textFieldCitizenName.text = citizen.automobile_owner;
            }
            if ([citizen.nexus isEqualToString:@"当事人"]) {
                self.textFieldCitizenName.text = citizen.party;
            }
        }
        //责令停止时间
        if (caseInfo.happen_date && !parkingNode.date_start) {
            parkingNode.date_start = caseInfo.happen_date;
            //把date_start显示在textField中
            
        }
        NSDate *startDate = parkingNode.date_start;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        self.textFieldHappenDate.text = [dateFormatter stringFromDate:startDate];
        
        //最下面打印时间
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        self.textPrintDate.text = [dateFormatter stringFromDate:[NSDate date]];
            
        //线  路段
        self.textFieldRoadName.text =caseInfo.full_roadName;
        self.textFieldKM.text = [NSString stringWithFormat:@"K%@+%@",caseInfo.station_start_km,caseInfo.station_start_m];
        
        //因
        CaseProveInfo *caseproveInfo=[CaseProveInfo proveInfoForCase:self.caseID];
        if (caseproveInfo) {
            self.textFieldCaeeReason.text = caseproveInfo.case_short_desc;
        }

        //车牌号码和车辆类型 (判断是否扣留车辆后再传入)
        self.textFieldCarType.text = parkingNode.limitday;
        self.textFieldAutomobileNumber.text = parkingNode.citizen_name;
        self.textFieldInstrument.text = parkingNode.instrument_name;
        self.textFieldCarType.text =parkingNode.car_type;
        if ([parkingNode.car_choose isEqualToString:@"√"]) {
            [self.radioButtonCaseDisposal1 setSelected:YES];
            NSLog(@"%@",parkingNode.car_choose);
        }
        if ([parkingNode.instrument_choose isEqualToString:@"√"]) {
            [self.radioButtonCaseDisposal2 setSelected:YES];
            NSLog(@"%@",parkingNode.instrument_choose);
        }
        //停驶期限
        NSArray *typeValues = [Systype typeValueForCodeName:@"停驶期限"];
        if (typeValues.count > 0) {
            NSString *typeValue = typeValues[0];
            [self.textFieldPeriodLimit setText:typeValue];
        } else {
            [self.textFieldPeriodLimit setText:@"十五"];
        }

        //接受处理和路政机构
        OrgInfo *orgInfo = [OrgInfo orgInfoForOrgID:caseInfo.organization_id];
        if (orgInfo.orgname) {
            //[self.textFieldOfficeAddress setText:orgInfo.orgshortname];
            [self.textFieldOfficeAddress setText:[[Systype typeValueForCodeName:@"交款地点"] objectAtIndex:0]];
            [self.textFieldOrgName setText:[[orgInfo.orgname  stringByReplacingOccurrencesOfString:@"一中队" withString:@""]stringByReplacingOccurrencesOfString:@"二中队" withString:@""] ];
        }

        //联系电话
        if (![orgInfo.telephone isEmpty]) {
            self.textFieldTelephone.text = orgInfo.telephone;
        }else if (parkingNode.telephone)
            self.textFieldTelephone.text = parkingNode.telephone;
        else{
            //self.textFieldTelephone.text = @"020-87438288-958";
            self.textFieldTelephone.text = @" ";
        }

        //执法人员
            NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
            NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
        self.textFieldEnforcerName.text = @"";//currentUserName;
            self.textFieldEnforcerNumber.text = @"";//[UserInfo exelawIDForUserName:currentUserName];

        
    }
   [[AppDelegate App] saveContext];
}

- (void)pageSaveInfo{
  
//    Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
//    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
//        RoadSegment *roadSegment=[RoadSegment roadNameFromSegment:caseInfo.roadsegment_id];
//        [self drawDateTable:xmlName withDataModel:roadSegment];
        ParkingNode *parkingNode = [ParkingNode parkingNodesForCase:self.caseID];
//    ParkingNode *parkingNode=[ParkingNode newDataObjectWithEntityName:@"ParkingNode"];
        parkingNode.car_number = self.textFieldAutomobileNumber.text;
        parkingNode.limitday = self.textFieldPeriodLimit.text;
        parkingNode.instrument_name=self.textFieldInstrument.text;
        parkingNode.telephone =self.textFieldTelephone.text;
    //parkingNode.offic_address =self.textFieldParkingNodeAddress.text;
        parkingNode.offic_address =self.textFieldOfficeAddress.text;
        parkingNode.name = self.textFieldEnforcerName.text;
        parkingNode.nameNo =self .textFieldEnforcerNumber.text;
    //parkingNode.orgshortname=self .textFieldOrgName.text;
//        parkingNode.name=self.textFieldEnforcerName.text;
    
    if (self.radioButtonCaseDisposal1.selected==YES) {
        parkingNode.car_choose= @"√";
    }
    if (self.radioButtonCaseDisposal2.selected==YES) {
        parkingNode.instrument_choose= @"√";
    }
    [[AppDelegate App] saveContext];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextFieldCitizenName:nil];
    [self setTextFieldHappenDate:nil];
    [self setTextFieldAutomobileNumber:nil];
    [self setTextFieldPlacePrefix:nil];
    [self setTextFieldStationStart:nil];
    [self setTextFieldCaseShortDescription:nil];
    [self setTextFieldParkingNodeAddress:nil];
    [self setTextFieldPeriodLimit:nil];
    [self setTextFieldOfficeAddress:nil];
    [self setLabelSendDate:nil];
    [self setTextPrintDate:nil];
    [self setTextFieldRoadName:nil];
    [self setTextFieldKM:nil];
    [self setTextFieldCaeeReason:nil];
    [self setTextFieldCarType:nil];
    [self setTextFieldInstrument:nil];
    [self setTextFieldOrgName:nil];
    [self setTextFieldEnforcerName:nil];
    [self setTextFieldEnforcerNumber:nil];
    [self setTextFieldTelephone:nil];
    [self setRadioButtonCaseDisposal1:nil];
    [self setRadioButtonCaseDisposal2:nil];
    [super viewDidUnload];
}

- (void)assignTagsToUIControl
{
    self.textFieldCitizenName.tag = kTextFieldTagCitizenName;
    self.textFieldHappenDate.tag = kTextFieldTagHappenDate;
    self.textFieldAutomobileNumber.tag = kTextFieldTagAutoMobileNumber;
    self.textFieldPlacePrefix.tag = kTextFieldTagPlacePrefix;
    self.textFieldStationStart.tag = kTextFieldTagStationStart;
    self.textFieldCaseShortDescription.tag = kTextFieldTagCaseShortDescription;
    self.textFieldParkingNodeAddress.tag = kTextFieldTagParkingNodeAddress;
    self.textFieldPeriodLimit.tag = kTextFieldTagPeriodLimit;
    self.textFieldOfficeAddress.tag = kTextFieldTagOfficeAddress;
}


- (BOOL)shouldGenereateDefaultDoc {
    return NO;
}


-(NSURL *)toFullPDFWithPath:(NSString *)filePath{

    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable1:xmlName];
        CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
        [self drawDateTable:xmlName withDataModel:caseInfo];
        ParkingNode *parkingNode=[ParkingNode parkingNodesForCase:self.caseID];
        [self drawDateTable:xmlName withDataModel:parkingNode];
        OrgInfo *orgInfo=[OrgInfo orgInfoForOrgID:caseInfo.organization_id];
        [self drawDateTable:xmlName withDataModel:orgInfo];
        Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
//        NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
//        UserInfo *userInfo = [UserInfo userInfoForUserID:currentUserID];
//        [self drawDateTable:xmlName withDataModel:userInfo];
        citizen.org_full_name=self.textFieldOrgName.text;
        [self drawDateTable:xmlName withDataModel:citizen];
       CaseServiceReceipt *caseServiceReceipt=[CaseServiceReceipt caseServiceReceiptForCase:self.caseID];
       [self drawDateTable:xmlName withDataModel:caseServiceReceipt];
        [self drawDateTable:xmlName withDataModel:self.caseProveInfo];
        
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
        
    }else{
    
        return nil;
    }

}

- (NSURL *)toFormedPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
        [self drawDateTable:xmlName withDataModel:caseInfo];
        [self drawDateTable:xmlName withDataModel:citizen];
        OrgInfo *orgInfo=[OrgInfo orgInfoForOrgID:caseInfo.organization_id];
        [self drawDateTable:xmlName withDataModel:orgInfo];
//        NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
//        UserInfo *userInfo = [UserInfo userInfoForUserID:currentUserID];
//        [self drawDateTable:xmlName withDataModel:userInfo];
         ParkingNode *parkingNode=[ParkingNode parkingNodesForCase:self.caseID];
        [self drawDateTable:xmlName withDataModel:parkingNode];
        CaseServiceReceipt *caseServiceReceipt=[CaseServiceReceipt caseServiceReceiptForCase:self.caseID];
        [self drawDateTable:xmlName withDataModel:caseServiceReceipt];
        [self drawDateTable:xmlName withDataModel:self.caseProveInfo];

        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}


- (void)setSelectData:(NSString *)data {
    for (UITextField *textField in self.view.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            if (self.popoverIndex == textField.tag) {
                [textField setText:data];
                [textField resignFirstResponder];
            }
        }
    }
    [self.popover dismissPopoverAnimated:YES];
}




#pragma mark - IBAction
-(IBAction)userSelected:(UITextField *)sender {
    self.textFieldTag = sender.tag;
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
-(IBAction)printXieBanTongZhiDan:(UIButton *)sender{
   
//        [self.docPrinter toFullPDFWithPath:[self docPathFromFileName]];
//        [self printPDF:PDFWithoutTable withSender:sender];
    
    NSString *tongzhidanPath=@"";
    NSURL *TongZhiShuUrl=nil;
        if (![self.caseID isEmpty]  ) {
            NSString *fileName=[NSString stringWithFormat:@"CaseDoc/%@/%@.pdf",self.caseID,@"协办通知单"];
            
            NSLog(@"协办通知单== %@",fileName);
            NSArray *arrayPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path=[arrayPaths objectAtIndex:0];
            NSLog(@"协办通知单路径 ==  %@",path);
            tongzhidanPath= [path stringByAppendingPathComponent:fileName];
        } else {
            tongzhidanPath= @"";
        }
    if (![tongzhidanPath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", tongzhidanPath];
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
        Systype *sys= [[Systype sysTypeArrayForCodeName:@"协办单位"] objectAtIndex:0]  ;
//        citizen.party=sys.type_code; //@"";
        NSString *party=citizen.party;
        //citizen.party=@"广州交通集团交通拯救有限公司";
        citizen.party=sys;
        id TongZhiShuData =@{};
          TongZhiShuData = @{
                               @"party":@"广州交通集团交通拯救有限公司xxxxx",
                               @"happen_date":caseInfo.happen_date,
                               @"automobile_number":citizen.automobile_number,
                               @"address":citizen.address
                               };
        //Systype *sys= [[Systype sysTypeArrayForCodeName:@"协办单位"] objectAtIndex:0]  ;
        //[self drawDateTable:xmlName1 withDataModel:sys];
        [self drawDateTable:xmlName1 withDataModel:TongZhiShuData];
        [self drawDateTable:xmlName1 withDataModel:caseInfo];
        [self drawDateTable:xmlName1 withDataModel:citizen];
        [self drawDateTable:xmlName1 withDataModel:self.caseProveInfo];
        
        
//        [self drawDateTable:xmlName1 withDataModel:caseInfo];
//        [self drawDateTable:xmlName1 withDataModel:citizen];
//        OrgInfo *orgInfo=[OrgInfo orgInfoForOrgID:caseInfo.organization_id];
//        [self drawDateTable:xmlName1 withDataModel:orgInfo];
//        ParkingNode *parkingNode=[ParkingNode parkingNodesForCase:self.caseID];
//        [self drawDateTable:xmlName1 withDataModel:parkingNode];
//        CaseServiceReceipt *caseServiceReceipt=[CaseServiceReceipt caseServiceReceiptForCase:self.caseID];
//        [self drawDateTable:xmlName1 withDataModel:caseServiceReceipt];
//        [self drawDateTable:xmlName1 withDataModel:self.caseProveInfo];
        
        UIGraphicsEndPDFContext();
        
        citizen.party=party;
        TongZhiShuUrl= [NSURL fileURLWithPath:formatFilePath];
    } else {
        TongZhiShuUrl= nil;
    }
    [self printPDF:TongZhiShuUrl withSender:sender];
    
   }


- (void) printPDF:(NSURL*)fileUrl withSender:(id)sender{
    NSURL *file = fileUrl;
    if (file != nil) {
        //self.selectedPDFType = fileType;
        if ([UIPrintInteractionController isPrintingAvailable]) {
            UIPrintInteractionController * printer=[UIPrintInteractionController sharedPrintController];
            if ([UIPrintInteractionController canPrintURL:file]) {
                [printer setDelegate:self];
                UIPrintInfo *printInfo=[UIPrintInfo printInfo];
                printInfo.jobName=@"协办通知单";//self.fileName;
                printInfo.outputType=UIPrintInfoOutputPhoto;
                printInfo.orientation = UIPrintInfoOrientationPortrait;
                printInfo.duplex = UIPrintInfoDuplexNone;
                /*if (self.docPrinterState==kDocEditAndPrint) {
                    newFile=YES;
                    //if (![CaseDocuments isExistingDocumentForCase:self.caseID docPath:self.docPathFromFileName]) {
                    if (![CaseDocuments isExistingDocumentForCase:self.caseID docPath:[file path]]) {
                        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
                        NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseDocuments" inManagedObjectContext:context];
                        CaseDocuments *newDoc=[[CaseDocuments alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                        newDoc.caseinfo_id=self.caseID;
                        newDoc.document_name=self.fileName;
                        //newDoc.document_path=self.docPathFromFileName;
                        newDoc.document_path=[file path];
                    }
                }*/
                printer.printInfo=printInfo;
                printer.printingItem=file;
                
                //测试PDF转图片打印用
                //[self imagesFromPDFURL:file];
                
                void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
                ^(UIPrintInteractionController *printController, BOOL completed, NSError *error ) {
                    if (!completed && error) {
                        NSLog(@"Printing could not complete because of error: %@", [error localizedDescription]);
                    }
                };
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    [printer presentFromRect:[sender frame] inView:self.view animated:YES completionHandler:completionHandler];
                } else {
                    [printer presentAnimated:YES completionHandler:completionHandler];
                }
            } else {
                NSLog(@"AirPrinter can NOT print the given file");
            }
        } else {
            NSLog(@"AirPrinter NOT Available");
        }
    }
}

- (void)setUser:(NSString *)name andUserID:(NSString *)userID{
    if (self.textFieldTag == 200) {
        self.textFieldEnforcerName.text = name;
        self.textFieldEnforcerNumber.text = [UserInfo exelawIDForUserName:name];

  }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 200:
            return NO;
            break;
        default:
            return YES;
            break;
    }
}
- (IBAction)showAutoNumerPicker:(id)sender{
    if (([_autoNumberPicker isPopoverVisible])) {
        [_autoNumberPicker dismissPopoverAnimated:YES];
    } else {
        AutoNumerPickerViewController *pickerVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AutoNumberPicker"];
        pickerVC.delegate=self;
        pickerVC.caseID=self.caseID;
        pickerVC.pickerType=kParkingNodeAutoNumber;
        _autoNumberPicker=[[UIPopoverController alloc] initWithContentViewController:pickerVC];
        [_autoNumberPicker presentPopoverFromRect:[(UITextField*)sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
}
//- (IBAction)printXieBanTongZhiDan:(UIButton *)sender{
//    ParkingNode *parkingNode=[ParkingNode parkingNodesForCase:self.caseID];
//	[self drawDateTable:xmlName withDataModel:parkingNode];
//    
//    // [self printPDF:super.PDFWithTable withSender:sender];
//
//}
-(void)setAutoNumberText:(NSString *)aAutoNumber{
    [_autoNumberPicker dismissPopoverAnimated:YES];
    [self pageLoadInfo:aAutoNumber];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == kTextFieldTagAutoMobileNumber) {
        
    }
}





@end
