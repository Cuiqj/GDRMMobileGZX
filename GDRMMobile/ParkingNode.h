//
//  ParkingNode.h
//  GDRMMobile
//
//  Created by Sniper One on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface ParkingNode : BaseManageObject

@property (nonatomic, retain) NSString * offic_address;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * citizen_name;   //被扣车牌号码
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSDate * date_end;
@property (nonatomic, retain) NSDate * date_send;
@property (nonatomic, retain) NSDate * date_start;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSNumber * isuploaded;

@property (nonatomic, retain) NSString * limitday;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * instrument_name;    //扣留工具名称
@property (nonatomic, retain) NSString * name;              //路政人员姓名
@property (nonatomic, retain) NSString * nameNo;            //路政人员编号
@property (nonatomic, retain) NSString * telephone;       //联系电话
@property (nonatomic, retain) NSString * car_choose;      //选择扣留车辆的“√”
@property (nonatomic, retain) NSString * instrument_choose;  //选择扣留工具的“√”
@property (nonatomic, retain) NSString * car_number;     
@property (nonatomic, retain) NSString * car_type;         //被扣车辆类型

//1 扣留车辆  2扣留工具
@property (nonatomic, retain) NSNumber *case_disposal;


+ (void)deleteAllParkingNodeForCase:(NSString *)caseID;
+ (ParkingNode *)parkingNodesForCase:(NSString *)caseID;
+ (ParkingNode *)parkingNodesForCase:(NSString *)caseID withCitizenName:(NSString*)citizen_name;
@end
