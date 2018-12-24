//
//  MaintianPlanCheck.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/1/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MaintainPlanCheck : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * inspection_id;
@property (nonatomic, retain) NSString * maintainPlan_id;
@property (nonatomic, retain) NSString * checktype;
@property (nonatomic, retain) NSDate * check_date;
@property (nonatomic, retain) NSString * checkitem1;
@property (nonatomic, retain) NSString * checkitem2;
@property (nonatomic, retain) NSString * checkitem3;
@property (nonatomic, retain) NSString * checkitem4;
@property (nonatomic, retain) NSString * have_rectify;
@property (nonatomic, retain) NSString * rectify_no;
@property (nonatomic, retain) NSString * have_stopwork;
@property (nonatomic, retain) NSString * stopwork_no;
@property (nonatomic, retain) NSString * check_remark;
@property (nonatomic, retain) NSString * isphoto;
@property (nonatomic, retain) NSString * isreport;
@property (nonatomic, retain) NSString * checker;
@property (nonatomic, retain) NSString * safety;
@property (nonatomic, retain) NSString * duty_opinion;
@property (nonatomic, retain) NSString * org_id;
@property (nonatomic, retain) NSString * classe;
@property (nonatomic, retain) NSNumber * isuploaded;
+ (NSArray *)maintainCheckForID:(NSString *)maintainCheckID;
@end
