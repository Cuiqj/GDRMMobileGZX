#import "ShiGongCheckViewController.h"
#import "UserInfo.h"
#import "InspectionConstructionCell.h"
#import "AttachmentViewController.h"
#import "InspectionConstructionPDFViewController.h"
#import "CaseDocumentsViewController.h"
#import "MaintainPlanCheck.h"
static NSString *inspectionConstructionTable = @"InspectionConstructionTable";
static NSString *inspectionConstruction = @"InspectionConstruction";

typedef enum {
    kStartTime1=0,
    kEndTime1,
    kStartTime2,
    kEndTime2,
    kInspectionDate
} TimeState;

@interface ShiGongCheckViewController ()
@property (retain, nonatomic) NSMutableArray *constructionList;
@property (retain, nonatomic) UIPopoverController *pickerPopover;
@property (copy, nonatomic) NSString *constructionID;
@property (assign, nonatomic) TimeState timeState;

@property (copy, nonatomic) NSString *maintainPlanID;

//设定文书查看状态，编辑模式或者PDF查看模式
@property (nonatomic,assign) DocPrinterState docPrinterState;

@property (assign,nonatomic)BOOL isWeatherFirstOrWeatherSecond;
@property (assign,nonatomic)NSInteger touchTextTag;

-(void)keyboardWillShow:(NSNotification *)aNotification;
-(void)keyboardWillHide:(NSNotification *)aNotification;
-(BOOL)checkInspectionConstructionInfo;
@end

@implementation ShiGongCheckViewController{
    NSIndexPath *notDeleteIndexPath;
 
        NSString *currentFileName;
        //弹窗标识，为0弹出天气选择，为1弹出车型选择，为2弹出损坏程度选择
        NSInteger touchedTag;
        NSDate *proveDate;

}
@synthesize uiBtnSave;
@synthesize tableCloseList;
@synthesize scrollContent;
@synthesize constructionList;
@synthesize pickerPopover;
@synthesize constructionID = _constructionID;
@synthesize maintainPlanID = _maintainPlanID;
@synthesize docPrinterState=_docPrinterState;

@synthesize inspectionID = _inspectionID;
@synthesize roadInspectVC = _roadInspectVC;

@synthesize firstView;
@synthesize secondView;
@synthesize isWeatherFirstOrWeatherSecond;
@synthesize pdfFormatFileURL;
@synthesize pdfFileURL;
- (NSString *)constructionID{
    if (_constructionID==nil) {
        _constructionID=@"";
    }
    return _constructionID;
}
- (IBAction)btnTongzhishu:(UIButton *)sender{
    /*
    NSString *title = NSLocalizedString(@"提示", nil);
    NSString *message = NSLocalizedString(@"A message should be a short, complete sentence.", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"好", nil);
    
    if(sender.tag ==1001){
        message=@"去发整改通知书？";
        currentFileName=@"整改通知书";
        self.docPrinterState=1;
    }
    else{
            message=@"去发停工通知书？";
        currentFileName=@"停工通知书";
        self.docPrinterState=1;
    }
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"我点了取消");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"我点了ok");
        [self performSegueWithIdentifier:@"toCaseDocument" sender:sender];
    }];
    
    // Add the actions.
    
    [alertController addAction:otherAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
     */
    if(sender.tag ==1001){
        currentFileName=@"整改通知书";
        self.docPrinterState=1;
    }
    else{
        currentFileName=@"停工通知书";
        self.docPrinterState=1;
    }
    if(self.constructionID == nil || [self.constructionID isEmpty]){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先保存记录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return;
    }
   [self performSegueWithIdentifier:@"toCaseDocument" sender:sender];
}

- (IBAction)btnPhoto:(UIButton *)sender {
    //[self performSegueWithIdentifier:@"toPhoto" sender:sender];
    if(self.constructionID == nil || [self.constructionID isEmpty]){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择一条记录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return;
    }
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AttachmentViewController *next = [board instantiateViewControllerWithIdentifier:@"AttachmentViewController"];
    [next setValue:self.constructionID forKey:@"constructionId"];
    [self.navigationController pushViewController:next animated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *segueIdentifier= [segue identifier];
    if ([segueIdentifier isEqualToString:@"toCaseDocument"]){
         CaseDocumentsViewController *documentsVC=segue.destinationViewController;
         documentsVC.fileName=currentFileName;
        documentsVC.caseID=self.constructionID;//nil;//self.caseID;
        documentsVC.maintainplanID=self.maintainPlanID;
         documentsVC.docPrinterState=self.docPrinterState;
         documentsVC.docReloadDelegate=self;
    }else if ([segueIdentifier isEqualToString:@"toPhoto"]){
        AttachmentViewController *attach = segue.destinationViewController;
        [attach setValue: self.constructionID forKey:@"constructionId"];
    }
}
- (void)viewDidLoad
{
    [self.switchisTingGong setOn:NO];
    [self.switchisZhengGai setOn:NO];
    [self.switchisZhengGai addTarget:self action:@selector(btnZhengGai:) forControlEvents:UIControlEventValueChanged];
    [self.switchisTingGong addTarget:self action:@selector(btnTingGong:) forControlEvents:UIControlEventValueChanged];
    [self btnZhengGai:self.switchisZhengGai];
    [self btnTingGong:self.switchisTingGong];
    self.constructionList=[[InspectionConstruction inspectionConstructionInfoForID:@""] mutableCopy];
    self.constructionList=[[ MaintainPlanCheck maintainCheckForID:@""] mutableCopy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSwitch:) name:@"refreshSwitch" object:nil];
    /*
    
    firstView.layer.cornerRadius = 8;
    firstView.layer.masksToBounds = YES;
    firstView.layer.borderWidth = 1;
    firstView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    
    secondView.layer.cornerRadius = 8;
    secondView.layer.masksToBounds = YES;
    secondView.layer.borderWidth = 1;
    secondView.layer.borderColor = [[UIColor blackColor] CGColor];
    */
    
    
    self.scrollContent.showsVerticalScrollIndicator=NO;
    //进入界面 默认显示第一条
    /*if([self.constructionList count]> 0){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:tableCloseList didSelectRowAtIndexPath:indexPath];
    }*/
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated{
    //生成巡查记录
    if (self.roadInspectVC && [[self.navigationController visibleViewController] isEqual:self.roadInspectVC]) {
        if (![self.inspectionID isEmpty]) {
            [self.roadInspectVC createRecodeByShiGongCheckID:self.constructionID];
            [self setInspectionID:nil];
            [self setRoadInspectVC:nil];
        }
    }
    
    [super viewWillDisappear:animated];
}
- (IBAction)userSelect:(UITextField *)sender {
    if ((self.touchTextTag == sender.tag) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.touchTextTag=sender.tag;
		UserPickerViewController *userPicker=[[UserPickerViewController alloc] init];
        //UserPickerViewController *userPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"userPicker"];
        userPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:userPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.scrollContent permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        userPicker.pickerPopover=self.pickerPopover;
    }
}
- (void)setUser:(NSString *)name andUserID:(NSString *)userID{
    //[(UITextField *)[self.view viewWithTag:self.touchTextTag] setText:name];
    self.textchecker.text=name;
}
- (IBAction)textTouch:(UITextField *)sender {
     self.touchTextTag=sender.tag;
	switch (sender.tag) {
			//巡查时间 tag=1
		case 1:{
			if ([self.pickerPopover isPopoverVisible]) {
				[self.pickerPopover dismissPopoverAnimated:YES];
			} else {
				DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
				datePicker.delegate=self;
				datePicker.pickerType=1;
				NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
				[dateFormatter setLocale:[NSLocale currentLocale]];
				[dateFormatter setDateFormat:@"yyyy年MM月dd日"];
				NSDate *temp=[dateFormatter dateFromString:self.check_date.text];
				[dateFormatter setDateFormat:@"yyyy-MM-dd"];
				[datePicker showdate:[dateFormatter stringFromDate:temp]];
				self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
				[self.pickerPopover presentPopoverFromRect:sender.frame inView:self.scrollContent permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
				datePicker.dateselectPopover=self.pickerPopover;
			}
		}
			self.timeState = kInspectionDate;
			break;
            //巡查项目名称tag=3
		case 3:{
			if ([self.pickerPopover isPopoverVisible]) {
				[self.pickerPopover dismissPopoverAnimated:YES];
			} else {
				MaintainPlanPickerViewController *MaintainPlanPicker=[[ MaintainPlanPickerViewController alloc]init];
                MaintainPlanPicker.pickerType=1;
				MaintainPlanPicker.delegate=self;
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:MaintainPlanPicker];
                [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
				[self.pickerPopover presentPopoverFromRect:sender.frame inView:self.scrollContent permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
				MaintainPlanPicker.pickerPopover=self.pickerPopover;
			}
		}
            //self.timeState = kStartTime1;
			break;
		case 2:{
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                MaintainPlanPickerViewController *MaintainPlanPicker=[[ MaintainPlanPickerViewController alloc]init];
                MaintainPlanPicker.pickerType=2;
                MaintainPlanPicker.delegate=self;
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:MaintainPlanPicker];
                [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
                [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.scrollContent permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                MaintainPlanPicker.pickerPopover=self.pickerPopover;
            }

		}
            //self.timeState = kEndTime1;
			break;
      default:{
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                MaintainPlanPickerViewController *MaintainPlanPicker=[[ MaintainPlanPickerViewController alloc]init];
                MaintainPlanPicker.pickerType=3;
                MaintainPlanPicker.delegate=self;
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:MaintainPlanPicker];
                [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
                [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.scrollContent permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                MaintainPlanPicker.pickerPopover=self.pickerPopover;
            }
            
        }
			break;
	}
}
- (void)setDate:(NSString *)date{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm"];
    NSDate *temp=[dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    NSString *dateString=[dateFormatter stringFromDate:temp];
    self.check_date.text=dateString;
}
-(void)setMaintainPlan:(NSString *)name andID:(NSString *)PlanID{
    if(self.touchTextTag==3){
    self.maintainPlanID=PlanID;
    self.textMaintain.text=name;
    }
    else if (self.touchTextTag==2){
        self.textchecktype.text=name;
    }
    else if (self.touchTextTag==8){
        self.textcheckitem4.text=name;
    }
    else if (self.touchTextTag==5){
        self.textcheckitem1.text=name;
    }
    else if (self.touchTextTag==6){
        self.textcheckitem2.text=name;
    }
    else if (self.touchTextTag==7){
        self.textcheckitem3.text=name;
    }
}

- (IBAction)btnZhengGai:(UISwitch *)sender {
    
    CGFloat alpha=sender.isOn?1.0:0.0;
    [UIView transitionWithView:self.view
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        self.labelZhengGai.alpha=alpha;
                        self.textrectify_no.alpha=alpha;
                        self.buttonZhengGai.alpha=alpha;
                    }
                    completion:nil];
}

- (IBAction)btnTingGong:(UISwitch *)sender {
    CGFloat alpha=sender.isOn?1.0:0.0;
    [UIView transitionWithView:self.view
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        self.labelTingGong.alpha=alpha;
                        self.textstopwork_no.alpha=alpha;
                        self.buttonTingGong.alpha=alpha;
                    
                    }
                    completion:nil];
}
- (IBAction)btnAddNew:(UIButton *)sender {
    for (UITextField *textField in [self.scrollContent subviews]) {
        if ([textField isKindOfClass:[UITextField class]]) {
            textField.text=@"";
        }
    }
    self.textcheck_remark.text=@"";
    [self.switchisTingGong setOn:NO];
    [self.switchisZhengGai setOn:NO];
    [self refeshsomething];
    self.constructionID=@"";
    [self.tableCloseList deselectRowAtIndexPath:[self.tableCloseList indexPathForSelectedRow] animated:YES];
}

- (IBAction)btnSave:(UIButton *)sender {
//    if(![self checkInspectionConstructionInfo]){
//        return;
//    }
    MaintainPlanCheck *checkInfo;
    NSIndexPath *indexPath;
    if ([self.constructionID isEmpty]) {
        //constructionInfo=[InspectionConstruction newDataObjectWithEntityName:inspectionConstruction];
        checkInfo= [MaintainPlanCheck newDataObjectWithEntityName:@"MaintainPlanCheck"];
        self.constructionID = checkInfo.myid;
        indexPath = [NSIndexPath indexPathForRow:[self.constructionList count] inSection:0];
    } else {
        //constructionInfo=[[InspectionConstruction inspectionConstructionInfoForID:self.constructionID] objectAtIndex:0];
        NSArray * checkarray=[MaintainPlanCheck maintainCheckForID:self.constructionID];
        checkInfo= [checkarray objectAtIndex:0];
    }
    checkInfo.myid=self.constructionID;
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    checkInfo.check_date=[formatter dateFromString:self.check_date.text];
    checkInfo.checktype=self.textchecktype.text;
    checkInfo.checker=self.textchecker.text;
    checkInfo.maintainPlan_id= self.maintainPlanID;
    if([self.textcheckitem1.text isEqualToString:@"是"]){checkInfo.checkitem1 = @"1" ;} else {checkInfo.checkitem1=@"0";}
    if([self.textcheckitem2.text isEqualToString:@"是"]){checkInfo.checkitem2 = @"1" ;} else {checkInfo.checkitem2=@"0";}
    if([self.textcheckitem3.text isEqualToString:@"是"]){checkInfo.checkitem3 = @"1" ;} else {checkInfo.checkitem3=@"0";}
    if([self.textcheckitem4.text isEqualToString:@"是"]){checkInfo.checkitem4 = @"1" ;} else {checkInfo.checkitem4=@"0";}
    //checkInfo.checkitem1= [self.textcheckitem1.text isEqualToString:@"是"? @"1":@"0"  ];
    // checkInfo.checkitem2=self.textcheckitem2.text;
    // checkInfo.checkitem3=self.textcheckitem3.text;
    // checkInfo.checkitem4=self.textcheckitem4.text;
    checkInfo.have_stopwork=self.switchisTingGong.isOn?@"1":@"0";
    checkInfo.have_rectify=self.switchisZhengGai.isOn?@"1":@"0";
    checkInfo.rectify_no=self.textrectify_no.text;
    checkInfo.stopwork_no=self.textstopwork_no.text;
    checkInfo.check_remark=self.textcheck_remark.text;
    checkInfo.duty_opinion=self.textduty_opinion.text;
    checkInfo.safety = self.textsafety.text;
    
    [[AppDelegate App] saveContext];
    //self.constructionList=[[InspectionConstruction inspectionConstructionInfoForID:@""] mutableCopy];
    self.constructionList=[[ MaintainPlanCheck maintainCheckForID:@""] mutableCopy];
    [self.tableCloseList reloadData];
    
    //当新增的时候，会在左侧的列表中添加一条新的记录，所以这条新的记录必须高亮
    if(indexPath){
        [self tableView:tableCloseList didSelectRowAtIndexPath:indexPath];
        return;
    }
    
    for (NSInteger i = 0; i < [self.constructionList count]; i++) {
        MaintainPlanCheck *check=[self.constructionList objectAtIndex:i];
        if([check.myid isEqualToString:self.constructionID]){
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self tableView:tableCloseList didSelectRowAtIndexPath:indexPath];
        }
    }
}

//弹出框不调出软键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	if (textField.tag==1 || textField.tag==2 || textField.tag == 4 || textField.tag == 3 || textField.tag == 5 || textField.tag == 6 || textField.tag == 7 || textField.tag == 8 || textField.tag == 17) {
		return NO;
	} else {
		return YES;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.constructionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MaintainCheckCell";
    InspectionConstructionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MaintainPlanCheck *constructionInfo=[self.constructionList objectAtIndex:indexPath.row];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    // cell.textLabel.text=[formatter stringFromDate:constructionInfo.inspectiondate];
     cell.textLabel.text=[formatter stringFromDate:constructionInfo.check_date];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    NSString *local=@"";
   /*
    [formatter setDateFormat:@"HH:mm"];
    local = [local stringByAppendingString:@"检查时间:"];
    if(constructionInfo.timestart1 != nil){
        local = [local stringByAppendingString:[formatter stringFromDate: constructionInfo.timestart1]];
    }
    local = [local stringByAppendingString:@"至"];
    if(constructionInfo.timeend1 != nil){
        local = [local stringByAppendingString:[formatter stringFromDate: constructionInfo.timeend1]];
    }
    local = [local stringByAppendingString:@" 桩号:K"];
    if(constructionInfo.stationstart1 != nil){
        local = [local stringByAppendingString:[NSString stringWithFormat:@"%d", constructionInfo.stationstart1.integerValue/1000]];
    }
    local = [local stringByAppendingString:@"+"];
    if(constructionInfo.stationstart1 != nil){
        local = [local stringByAppendingString:[NSString stringWithFormat:@"%d",constructionInfo.stationstart1.integerValue%1000]];
    }
    local = [local stringByAppendingString:@"至"];
    if(constructionInfo.stationend1 != nil){
        local = [local stringByAppendingString:[NSString stringWithFormat:@"%d",constructionInfo.stationend1.integerValue/1000]];
    }
    local = [local stringByAppendingString:@"+"];
    if(constructionInfo.stationend1 != nil){
        local = [local stringByAppendingString:[NSString stringWithFormat:@"%d",constructionInfo.stationend1.integerValue%1000]];
    }
    */
    cell.detailTextLabel.text=local;
    
    
    
    cell.textLabel.backgroundColor=[UIColor clearColor];
    if (constructionInfo.isuploaded.boolValue) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    id obj;
    if(indexPath){
        obj=[self.constructionList objectAtIndex:indexPath.row];
    }else{
        if(notDeleteIndexPath){
            obj=[self.constructionList objectAtIndex:notDeleteIndexPath.row];
            indexPath = notDeleteIndexPath;
        }
    }
    if(obj){
        [self selectFirstRow:indexPath];
    }else{
        [self selectFirstRow:nil];
    }
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    notDeleteIndexPath = nil;
    return @"删除";
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        id obj=[self.constructionList objectAtIndex:indexPath.row];
        BOOL isPromulgated=[[obj isuploaded] boolValue];
        if (isPromulgated) {
            notDeleteIndexPath = indexPath;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"删除失败" message:@"已上传信息，不能直接删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alert show];
        } else {
            
            
            NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
            [context deleteObject:obj];
            [self.constructionList removeObject:obj];
            
            // InspectionConstruction *inspection = (InspectionConstruction *)obj;
            MaintainPlanCheck *inspection =(MaintainPlanCheck *)obj;
            NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath=[pathArray objectAtIndex:0];
            NSString *photoPath=[NSString stringWithFormat:@"InspectionConstruction/%@",inspection.myid];
            photoPath=[documentPath stringByAppendingPathComponent:photoPath];
            [[NSFileManager defaultManager]removeItemAtPath:photoPath error:nil];
            
            [[AppDelegate App] saveContext];
            
            
            
            self.constructionID = @"";
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MaintainPlanCheck *checkInfo= [self.constructionList objectAtIndex:indexPath.row];
    self.constructionID=checkInfo.myid;
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    self.check_date.text =[formatter stringFromDate:checkInfo.check_date];
    self.constructionID=checkInfo.myid;
    self.textchecktype.text=checkInfo.checktype;
    self.textchecker.text=checkInfo.checker;
    self.maintainPlanID = checkInfo.maintainPlan_id;
    self.textMaintain.text = [MaintainPlan maintainPlanNameForID:checkInfo.maintainPlan_id ];
    if([checkInfo.checkitem1 isEqualToString:@"1"]){self.textcheckitem1.text=@"是";}else{ self.textcheckitem1.text=@"否";}
    if([checkInfo.checkitem2 isEqualToString:@"1"]){self.textcheckitem2.text=@"是";}else{ self.textcheckitem2.text=@"否";}
    if([checkInfo.checkitem3 isEqualToString:@"1"]){self.textcheckitem3.text=@"是";}else{ self.textcheckitem3.text=@"否";}
    if([checkInfo.checkitem4 isEqualToString:@"1"]){self.textcheckitem4.text=@"是";}else{ self.textcheckitem4.text=@"否";}
//    self.textcheckitem1.text = checkInfo.checkitem1;
//    self.textcheckitem2.text = checkInfo.checkitem2;
//    self.textcheckitem3.text = checkInfo.checkitem3;
//    self.textcheckitem4.text = checkInfo.checkitem4;
    [checkInfo.have_stopwork isEqualToString:@"1" ]? [self.switchisTingGong setOn:YES]:[self.switchisTingGong setOn:NO] ;
    [checkInfo.have_rectify isEqualToString:@"1" ]? [self.switchisZhengGai setOn:YES]:[self.switchisZhengGai setOn:NO] ;
    self.textrectify_no.text = checkInfo.rectify_no;
    self.textstopwork_no.text = checkInfo.stopwork_no;
    self.textcheck_remark.text = checkInfo.check_remark;
    self.textduty_opinion.text = checkInfo.duty_opinion;
    self.textsafety.text = checkInfo.safety ;
    [self refeshsomething];
    //所有控制表格中行高亮的代码都只在这里
    [self.tableCloseList deselectRowAtIndexPath:[self.tableCloseList indexPathForSelectedRow] animated:YES];
    [self.tableCloseList selectRowAtIndexPath:indexPath animated:nil scrollPosition:nil];
}
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableCloseList didSelectRowAtIndexPath:indexPath];
}
-(void)selectFirstRow:(NSIndexPath *)indexPath{
    //当UITableView没有内容的时候，选择第一行会报错
    if([self.constructionList count]> 0){
        if (!indexPath) {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        }
        [self performSelector:@selector(selectRowAtIndexPath:)
                   withObject:indexPath
                   afterDelay:0];
    }else{
        [self btnAddNew:nil];
    }
}
- (void)refreshSwitch:(NSNotification *)notify{
    CGFloat alpha=self.switchisTingGong.isOn?1.0:0.0;
    CGFloat pingbi=0.0;
    [UIView transitionWithView:self.view
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        self.labelTingGong.alpha=pingbi;
                        self.textstopwork_no.alpha=pingbi;
                        self.buttonTingGong.alpha=alpha;
                        
                    }
                    completion:nil];
    
    CGFloat alpha2=self.switchisZhengGai.isOn?1.0:0.0;
    [UIView transitionWithView:self.view
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        self.labelZhengGai.alpha=pingbi;
                        self.textrectify_no.alpha=pingbi;
                        self.buttonZhengGai.alpha=alpha2;
                    }
                    completion:nil];
}
-(void)refeshsomething{
    CGFloat alpha=self.switchisTingGong.isOn?1.0:0.0;
    CGFloat pingbi=0.0;
    [UIView transitionWithView:self.view
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        self.labelTingGong.alpha=pingbi;
                        self.textstopwork_no.alpha=pingbi;
                        self.buttonTingGong.alpha=alpha;
                        
                    }
                    completion:nil];
    
    CGFloat alpha2=self.switchisZhengGai.isOn?1.0:0.0;
    [UIView transitionWithView:self.view
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        self.labelZhengGai.alpha=pingbi;
                        self.textrectify_no.alpha=pingbi;
                        self.buttonZhengGai.alpha=alpha2;
                    }
                    completion:nil];
}
//键盘出现和消失时，变动ScrollContent的contentSize;
-(void)keyboardWillShow:(NSNotification *)aNotification{
//    for ( id view in self.secondView.subviews) {
//        if ([view isFirstResponder]) {
//            if ([view tag] >= 100) {
//                [self.scrollContent setContentOffset:CGPointMake(0, 300) animated:YES];
//            }
//        }
//    }
    for ( id view in self.scrollContent.subviews) {
        if ([view isFirstResponder]) {
            if ([view tag] >= 100) {
			 [self.scrollContent setContentOffset:CGPointMake(0, 300) animated:YES];
        }
        }
    }
}

-(void)keyboardWillHide:(NSNotification *)aNotification{
    [self.scrollContent setContentOffset:CGPointMake(0, 0) animated:YES];
}

/*


 */
 @end
