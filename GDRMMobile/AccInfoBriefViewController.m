//
//  AccInfoBriefViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AccInfoBriefViewController.h"
#import "Systype.h"
#import "UserInfo.h"
#import "CasePrintViewController.h"
#import "OrgInfo.h"
#import "NSArray+NewCaseDescArray.h"

typedef enum {
    kStartTime=0,
    kEndTime
} TimeState;

@interface AccInfoBriefViewController (){
    //TextField点击标识
    //事故性质=0；事故原因=1；事故类型=2；停驶车辆=3；车辆类型=4
    NSInteger textIndex;
}
@property (nonatomic,retain) UIPopoverController *pickerPopover;
@property (nonatomic,assign) TimeState timeState;
//车辆外观数组
@property (nonatomic,retain) NSArray *carLooksArray;

-(void)pickerPresentForIndex:(NSInteger)iIndex fromRect:(CGRect)rect;
-(void)saveParkingNodeForCase:(NSString *)caseID;
@end

@implementation AccInfoBriefViewController

@synthesize caseID =_caseID;
@synthesize textdeath =_textdeath; 
@synthesize textbadcar =_textbadcar;
@synthesize textreason =_textreason;
@synthesize textbadwound =_textbadwound;
@synthesize textfleshwound =_textfleshwound;
@synthesize textCaseStyle = _textCaseStyle;
@synthesize textCaseType = _textCaseType;
@synthesize labelParkingCarName = _labelParkingCarName;
@synthesize textParkingCarName = _textParkingCarName;
@synthesize labelParkingLocation = _labelParkingLocation;
@synthesize textParkingLocation = _textParkingLocation;
@synthesize labelStartTime = _labelStartTime;
@synthesize textStartTime = _textStartTime;
@synthesize labelEndTime = _labelEndTime;
@synthesize textEndTime = _textEndTime;
@synthesize swithIsParking = _swithIsParking;
@synthesize delegate=_delegate;
@synthesize pickerPopover=_pickerPopover;
@synthesize timeState=_timeState;
@synthesize textCarType=_textCarType;
@synthesize labelCarType=_labelCarType;

@synthesize carLooksArray=_carLooksArray;


@synthesize  textcar_bump_part=_textcar_bump_part;
@synthesize  textbump_object=_textbump_object;
@synthesize  textcar_stop_status=_textcar_stop_status;
@synthesize  textcar_stop_side=_textcar_stop_side;
@synthesize  texthead_side=_texthead_side;
@synthesize  textbody_side=_textbody_side;
@synthesize  texttail_side=_texttail_side;
@synthesize  textcar_looks=_textcar_looks;


- (void)viewDidLoad
{
    [self.swithIsParking setOn:NO];
    [self parkingChanged:self.swithIsParking];
//    self.textParkingLocation.placeholder = [Systype typeValueForCodeName:@"停车地点"].count>0 ? [[Systype typeValueForCodeName:@"停车地点"] objectAtIndex:0] : @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteParkingNumber:) name:@"DeleteCitizen" object:nil];
    textIndex=-1;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //add by lxm
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCaseID:) name:@"refreshCaseID" object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteParkingNumber:) name:@"DeleteCitizen" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//获取全部的车辆外观
-(NSArray *)carLooksArray{
    if (_carLooksArray==nil) {
        _carLooksArray=[NSArray newCarLookDescArray];
    }
    return _carLooksArray;
}
- (void)setCaseDescArrayDelegate:(NSArray *)aCaseDescArray{
    self.carLooksArray=aCaseDescArray;
    NSString *caseFullDesc=@"";
    for (CaseDescString *temp in aCaseDescArray) {
        if (temp.isSelected) {
            if ([caseFullDesc isEmpty]) {
                caseFullDesc=[caseFullDesc stringByAppendingString:temp.caseDesc];
            } else {
                caseFullDesc=[caseFullDesc stringByAppendingFormat:@"、%@",temp.caseDesc];
            }
        }
    }
    self.textcar_looks.text=caseFullDesc;
}

//返回当前选定的案由
- (NSArray *)getCaseDescArrayDelegate{
    return self.carLooksArray;
}
- (IBAction)selectCarLooks:(id)sender{
    //[self performSegueWithIdentifier:@"toCaseDescList" sender:self];
    //[self performSegueWithIdentifier:@"toMutiSelect" sender:self];//[self pickerPresentForIndex:[sender tag]  fromRect:[(UITextField*)sender frame]];
    /*
    UIView *anchor = sender;
    UIViewController *viewControllerForPopover =
    [self.storyboard instantiateViewControllerWithIdentifier:@"toMutiSelect"];
    
    self.pickerPopover = [[UIPopoverController alloc]
               initWithContentViewController:viewControllerForPopover];
    [self.pickerPopover presentPopoverFromRect:anchor.frame
                             inView:anchor.superview
     permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES]; */
    
    if (  ([_pickerPopover isPopoverVisible])) {
        [_pickerPopover dismissPopoverAnimated:YES];
    } else {
        //textIndex=iIndex;
        CaseDescListViewController *acPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"caseDescListPicker"];
        //acPicker.pickerType=iIndex;
        acPicker.delegate=self;
        //acPicker.caseID=self.caseID;
        acPicker.poptype=  @"2" ;
        _pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        //if (iIndex==0) {
            [_pickerPopover setPopoverContentSize:CGSizeMake(100, 176)];
        //}
        [_pickerPopover presentPopoverFromRect:[(UITextField*)sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.popOver=_pickerPopover;
    }//*/
}

- (void)viewDidUnload
{
    [self setLabelParkingCarName:nil];
    [self setTextParkingCarName:nil];
    [self setLabelParkingLocation:nil];
    [self setTextParkingLocation:nil];
    [self setSwithIsParking:nil];
    [self setTextCaseStyle:nil];
    [self setTextCaseType:nil];
    textIndex=-1;
    [self setLabelStartTime:nil];
    [self setTextStartTime:nil];
    [self setTextEndTime:nil];
    [self setLabelEndTime:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

//弹窗
-(void)pickerPresentForIndex:(NSInteger)iIndex fromRect:(CGRect)rect{
    if ((iIndex==textIndex) && ([_pickerPopover isPopoverVisible])) {
        [_pickerPopover dismissPopoverAnimated:YES];
    } else {
        textIndex=iIndex;
        AccInfoPickerViewController *acPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"AccInfoPicker"];
        acPicker.pickerType=iIndex;
        acPicker.delegate=self;
        acPicker.caseID=self.caseID;
        _pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        if (iIndex==0) {
            [_pickerPopover setPopoverContentSize:CGSizeMake(200, 176)];
        }
        [_pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover=_pickerPopover;
    }
}

//选择停驶车辆
- (IBAction)selectParkingCitizenName:(id)sender {
    [self pickerPresentForIndex:3 fromRect:[(UITextField*)sender frame]];
}

//选择事故性质
- (IBAction)selectCaseStyle:(id)sender {
    [self pickerPresentForIndex:0 fromRect:[(UITextField*)sender frame]];
}

//选择事故原因
- (IBAction)selectCaseReason:(id)sender {
    [self pickerPresentForIndex:1 fromRect:[(UITextField*)sender frame]];
}

//选择事故类型
- (IBAction)selectCaseType:(id)sender {
    [self pickerPresentForIndex:2 fromRect:[(UITextField*)sender frame]];
}

//车辆类型
- (IBAction)selectCarType:(id)sender{

    [self pickerPresentForIndex:4 fromRect:[(UITextField*)sender frame]];
}



//选择起止时间
- (IBAction)selectTime:(id)sender {
    DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
    datePicker.delegate=self;
    datePicker.pickerType=1;
    if ([sender tag]==12) {
        [datePicker showdate:self.textStartTime.text];
        self.timeState=kStartTime;
    } else if ([sender tag]==13) {
        [datePicker showdate:self.textEndTime.text];
        self.timeState=kEndTime;
    }
    self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
    [self.pickerPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    datePicker.dateselectPopover=self.pickerPopover;
}

-(void)setDate:(NSString *)date{
    if (self.timeState==kStartTime) {
        self.textStartTime.text=date;
        if ([self.textEndTime.text isEmpty]) {
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setDay:7];
            NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDate *endDate=[calendar dateByAddingComponents:components toDate:[dateFormatter dateFromString:date] options:0];
            self.textEndTime.text=[dateFormatter stringFromDate:endDate];
        }
    } else {
        self.textEndTime.text=date;
    }
}

//根据伤亡人数，判断事故性质
- (IBAction)textChanged:(id)sender {
    //轻微事故：一次造成轻伤1-2人
    //一般事故：指一次造成重伤1-2人或者轻伤3人及3人以上
    //重大事故：指一次造成死亡1-2人或者重伤3-10人
    //特大事故：指一次造成死亡3人以上，或重伤11人及11人以上或者死亡1人同时重伤8人以上；或者死亡2人同时重伤5人以上
    NSInteger deathNum=[_textdeath.text integerValue];
    NSInteger badwoundNum=[_textbadwound.text integerValue];
    NSInteger fleshwoundNum=[_textfleshwound.text integerValue];
    if (fleshwoundNum>0 && fleshwoundNum<=2 && badwoundNum==0 && deathNum==0) {
        _textCaseStyle.text= @"轻微事故";
    } else if (badwoundNum<=2 && deathNum==0) {
         _textCaseStyle.text = @"一般事故";
    } else if (badwoundNum<11 && deathNum==0) {
        _textCaseStyle.text = @"重大事故";
    } else if (badwoundNum<8 && deathNum==1) {
        _textCaseStyle.text = @"重大事故";
    } else if (badwoundNum<5 && deathNum==2) {
        _textCaseStyle.text = @"重大事故";
    } else {
        _textCaseStyle.text = @"特大事故";
    }   
}

//是否停驶
- (IBAction)parkingChanged:(UISwitch *)sender {
    CGFloat alpha=sender.isOn?1.0:0.0;
    [UIView transitionWithView:self.view 
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseInOut 
                    animations:^{
                        self.labelParkingCarName.alpha=alpha;
                        self.labelParkingLocation.alpha=alpha;
                        self.labelCarType.alpha=alpha;
                        self.textParkingCarName.alpha=alpha;
                        self.textCarType.alpha=alpha;
                        self.textParkingLocation.alpha=alpha;
                        self.textStartTime.alpha=alpha;
                        self.textEndTime.alpha=alpha;
                        self.labelEndTime.alpha=alpha;
                        self.labelStartTime.alpha=alpha;
                    } 
                    completion:nil];
}

//delegate，将选择文字显示
-(void)setCaseText:(NSString *)aText{
    switch (textIndex) {
        case 0:
            _textCaseStyle.text=aText;
            break;
        case 1:
            _textreason.text=aText;
            break;
        case 2:
            _textCaseType.text=aText;
            break;
        case 3:
            _textParkingCarName.text=aText;
            break;
        case 4:
            _textCarType.text=aText;
            break;
            
        case 11:
            _textcar_bump_part.text=aText;
            break;
        case 12:
            _textbump_object.text=aText;
            break;
        case 13:
            _textcar_stop_status.text=aText;
            break;
        case 14:
            _textcar_stop_side.text=aText;
            break;
        case 15:
            _texthead_side.text=aText;
            break;
        case 16:
            _textbody_side.text=aText;
            break;
        case 17:
            _texttail_side.text=aText;
            break;
        case 18:
            _textcar_looks.text=aText;
            break;
        default:
            
            break;
    }
}

- (IBAction)selectCarStatus:(id)sender{
    [self pickerPresentForIndex:[sender tag]  fromRect:[(UITextField*)sender frame]];
}

-(NSString *)getParkingCitizens{
    if (self.textParkingCarName.text==nil) {
        return @"";
    } else {
        return self.textParkingCarName.text;
    }
}

//将当前页面显示数据保存至该caseID下
-(void)saveDataForCase:(NSString *)caseID{
    //self.caseID=caseID;
    
    NSString *fleshwoundsum=[_textfleshwound.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *badcarsum=[_textbadcar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *badwoundsum=[_textbadwound.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *deathsum=[_textdeath.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    fleshwoundsum=[fleshwoundsum isEmpty]?@"0":fleshwoundsum;
    badcarsum=[badcarsum isEmpty]?@"0":badcarsum;
    badwoundsum=[badwoundsum isEmpty]?@"0":badwoundsum;
    deathsum=[deathsum isEmpty]?@"0":deathsum;
    self.textfleshwound.text=[NSString stringWithFormat:@"%d",fleshwoundsum.integerValue];
    self.textbadcar.text=[NSString stringWithFormat:@"%d",badcarsum.integerValue];
    self.textbadwound.text=[NSString stringWithFormat:@"%d",badwoundsum.integerValue];
    self.textdeath.text=[NSString stringWithFormat:@"%d",deathsum.integerValue];
    
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:caseID];
    if (caseInfo){
        caseInfo.case_reason=_textreason.text;
        caseInfo.badcar_sum= NSStringNilIsBadReturn0([NSString stringWithFormat:@"%d",badcarsum.integerValue]);
        caseInfo.badwound_sum= NSStringNilIsBadReturn0([NSString stringWithFormat:@"%d",badwoundsum.integerValue]);
        caseInfo.fleshwound_sum= NSStringNilIsBadReturn0([NSString stringWithFormat:@"%d",fleshwoundsum.integerValue]);
        caseInfo.death_sum= NSStringNilIsBadReturn0([NSString stringWithFormat:@"%d",deathsum.integerValue]);
        caseInfo.case_type=_textCaseType.text;
        caseInfo.case_style=_textCaseStyle.text;
        
        caseInfo.car_bump_part= _textcar_bump_part.text;
        caseInfo.bump_object=_textbump_object.text;
        caseInfo.car_stop_status=_textcar_stop_status.text;
        caseInfo.car_stop_side=_textcar_stop_side.text;
        caseInfo.head_side=_texthead_side.text;
        caseInfo.body_side=_textbody_side.text;
        caseInfo.tail_side=_texttail_side.text;
        caseInfo.car_looks=_textcar_looks.text;
        
    }    
    
    CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:caseID];
    if (!caseProveInfo){
        if (![caseID isEmpty]){
            caseProveInfo = [CaseProveInfo newDataObjectWithEntityName:@"CaseProveInfo"];
            caseProveInfo.caseinfo_id=caseID;
            NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
            NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
            NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
            if (inspectorArray.count < 1) {
                caseProveInfo.prover = currentUserName;
            } else {
                NSString *inspectorName = @"";
                for (NSString *name in inspectorArray) {
                    if ([inspectorName isEmpty]) {
                        inspectorName = name;
                    } else {
                        inspectorName = [inspectorName stringByAppendingFormat:@",%@",name];
                    }
                }
                caseProveInfo.prover = inspectorName;
            }
            caseProveInfo.recorder = currentUserName;
        }
    }
    [self saveParkingNodeForCase:caseID];
    [[AppDelegate App] saveContext];
}


//点击textField出现软键盘，为防止软键盘遮挡，上移scrollview
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [_delegate scrollViewNeedsMove];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==12 || textField.tag==13 || textField.tag==10) {
        return NO;
    } else {
        return YES;
    }
}

//根据caseID载入相应案件数据
-(void)loadDataForCase:(NSString *)caseID{
    self.caseID=caseID;
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:caseID];
    if (caseInfo) {
        _textbadcar.text= caseInfo.badcar_sum;
        _textbadwound.text= caseInfo.badwound_sum;
        _textfleshwound.text=caseInfo.fleshwound_sum;
        _textdeath.text=caseInfo.death_sum;
        _textreason.text=caseInfo.case_reason;
        _textCaseStyle.text=caseInfo.case_style;
        _textCaseType.text=caseInfo.case_type;
        
        _textcar_bump_part.text=caseInfo.car_bump_part;
        _textbump_object.text=caseInfo.bump_object;
        _textcar_stop_status.text=caseInfo.car_stop_status;
        _textcar_stop_side.text=caseInfo.car_stop_side;
        _texthead_side.text=caseInfo.head_side;
        _textbody_side.text=caseInfo.body_side;
        _texttail_side.text=caseInfo.tail_side;
        _textcar_looks.text=caseInfo.car_looks;
        
    }    
    [self loadParkingNodeForCase:caseID];
}


-(void)newDataForCase:(NSString *)caseID{
    self.caseID=caseID;
    for (UITextField *text in [self.view subviews]) {
        if ([text isKindOfClass:[UITextField class]]) {
            text.text=@"";
        }
    }
    [self.swithIsParking setOn:NO];
    [self parkingChanged:self.swithIsParking];
}

-(void)saveParkingNodeForCase:(NSString *)caseID{
    [ParkingNode deleteAllParkingNodeForCase:caseID];
    if (self.swithIsParking.isOn) {
        if (![self.textParkingCarName.text isEmpty]||![self.textParkingLocation.text isEmpty]) {
//            if ([self.textParkingLocation.text isEmpty]) {
//                self.textParkingLocation.text=self.textParkingLocation.placeholder;
//            }
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            if ([self.textStartTime.text isEmpty]) {
                self.textStartTime.text=[dateFormatter stringFromDate:[NSDate date]];
            }
            if ([self.textEndTime.text isEmpty]) {
                NSDateComponents *components = [[NSDateComponents alloc] init];
                [components setDay:7];
                NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDate *endDate=[calendar dateByAddingComponents:components toDate:[dateFormatter dateFromString:self.textStartTime.text] options:0];
                self.textEndTime.text=[dateFormatter stringFromDate:endDate];
            }
            NSArray *numberArray=[self.textParkingCarName.text componentsSeparatedByString:@"、"];
            NSDateFormatter *codeFormatter = [[NSDateFormatter alloc] init];
            [codeFormatter setDateFormat:@"yyyyMM'0'dd"];
            [codeFormatter setLocale:[NSLocale currentLocale]];
            for (NSString *citizenName in numberArray){
//                if (![citizenName isEmpty]) {
                    ParkingNode *parkingNode=[ParkingNode newDataObjectWithEntityName:@"ParkingNode"];
                    parkingNode.date_send = [NSDate date];
                    parkingNode.code = [codeFormatter stringFromDate:parkingNode.date_send];
                    parkingNode.caseinfo_id=caseID;
                    parkingNode.citizen_name=citizenName;
                    parkingNode.date_end=[dateFormatter dateFromString:self.textEndTime.text];
                    parkingNode.date_start=[dateFormatter dateFromString:self.textStartTime.text];
                    parkingNode.instrument_name=self.textParkingLocation.text;
                    parkingNode.car_type=self.textCarType.text;
                    parkingNode.limitday=@"十五";
                    if (![self.textParkingCarName.text isEmpty] && self.textParkingCarName.text!=nil) {
                        parkingNode.car_choose = @"√";
                    }
                    if (![self.textParkingLocation.text isEmpty] && self.textParkingLocation.text!=nil) {
                        parkingNode.instrument_choose = @"√";
                    }
                    [[AppDelegate App] saveContext];
//                }
            }
            codeFormatter = nil;
            dateFormatter = nil;
        } else {
            self.textEndTime.text=@"";
            self.textStartTime.text=@"";
            self.textParkingLocation.text=@"";
        }
    }
}

-(void)loadParkingNodeForCase:(NSString *)caseID{
    if (![caseID isEmpty]) {
        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"ParkingNode" inManagedObjectContext:context];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id ==%@",caseID];
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        fetchRequest.predicate=predicate;
        fetchRequest.entity=entity;
        NSArray *parkingArray=[context executeFetchRequest:fetchRequest error:nil];
        if (parkingArray.count>0) {
            [self.swithIsParking setOn:YES];
            NSString *citizen=@"";
            for (id parkingNode in parkingArray) {
                if ([citizen isEmpty]) {
                    citizen=[citizen stringByAppendingString:[parkingNode valueForKey:@"citizen_name"]];
                } else {
                    citizen=[citizen stringByAppendingFormat:@"、%@",[parkingNode valueForKey:@"citizen_name"]];
                }
            }
            self.textParkingCarName.text=citizen;
            ParkingNode *parkingNode=[parkingArray objectAtIndex:0];
            self.textParkingLocation.text=parkingNode.instrument_name;
            self.textCarType.text=parkingNode.car_type;
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            self.textStartTime.text=[dateFormatter stringFromDate:parkingNode.date_start];
            self.textEndTime.text=[dateFormatter stringFromDate:parkingNode.date_end];
            [self parkingChanged:self.swithIsParking];
        } else {
            [self.swithIsParking setOn:NO];
            [self parkingChanged:self.swithIsParking];
        }
    } else {
        [self.swithIsParking setOn:NO];
        [self parkingChanged:self.swithIsParking];
    }
}

//若删除停驶车号对应的citizen信息，则停驶车号相应删除
-(void)deleteParkingNumber:(NSNotification *)noti{
    if (![self.textParkingCarName.text isEmpty]) {
        NSDictionary *info=[noti userInfo];
        NSString *deleteString=[info objectForKey:@"citizen_name"];
        NSMutableArray *tempArray=[[self.textParkingCarName.text componentsSeparatedByString:@"、"] mutableCopy];
        NSMutableArray *deleteArray=[NSMutableArray array];
        for (NSString *tempString in tempArray) {
            if ([tempString isEqualToString:deleteString]) {
                [deleteArray addObject:tempString];
            }
        }
        [tempArray removeObjectsInArray:deleteArray];
        [deleteArray removeAllObjects];
        NSString *citizen=@"";
        for (NSString *tempString in tempArray) {
            if ([citizen isEmpty]) {
                citizen=[citizen stringByAppendingString:tempString];
            } else {
                citizen=[citizen stringByAppendingFormat:@"、%@",tempString];
            }
        }
        [tempArray removeAllObjects];
        self.textParkingCarName.text=citizen;
    }
}



//add by lxm 2013.05.13
- (void)refreshCaseID:(NSNotification *)notify
{
    NSDictionary *info=[notify userInfo];
    self.caseID= [info objectForKey:@"caseID"];

}
@end
