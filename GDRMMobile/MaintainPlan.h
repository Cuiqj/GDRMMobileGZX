//
//  MaintianPlan.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/1/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MaintainPlan : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * project_name;
@property (nonatomic, retain) NSString * construct_org;
@property (nonatomic, retain) NSString * org_principal;
@property (nonatomic, retain) NSDate * date_start;
@property (nonatomic, retain) NSDate * date_end;
@property (nonatomic, retain) NSString * project_address;
@property (nonatomic, retain) NSString * close_desc;
@property (nonatomic, retain) NSString * tel_number;
@property (nonatomic, retain) NSString * remark;
+(NSArray*) allMaintainPlan;
+(NSString*)maintainPlanNameForID:(NSString*)maintainID;
+(MaintainPlan*)maintainPlanInfoForID:(NSString*)maintainID;
@end
