//
//  StopNotice.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/1/9.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StopNotice : NSManagedObject

@property (nonatomic, retain) NSString * chinese_money;
@property (nonatomic, retain) NSString * citizen;
@property (nonatomic, retain) NSString * disobey_item;
@property (nonatomic, retain) NSString * maintainPlanCheck_id;
@property (nonatomic, retain) NSString * money;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * obey_kuan;
@property (nonatomic, retain) NSString * obey_tiao;
@property (nonatomic, retain) NSString * recorder;
@property (nonatomic, retain) NSDate * send_date;
@property (nonatomic, retain) NSNumber * isuploaded;
+( StopNotice* )stopNoticeInfoForCheckID:(NSString *)checkID;
-(NSString *)construct_org;
-(NSString *)project_address;
@end
