//
//  StopNotice.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/1/9.
//
//

#import "StopNotice.h"
#import "MaintainPlanCheck.h"
#import "MaintainPlan.h"
@interface StopNotice ()
@property (nonatomic, retain, setter = setmaintianPlan:) MaintainPlan  * _maintianPlan;
@property (nonatomic, retain, setter = setcheckplan:) MaintainPlanCheck  * _checkplan;
@end
@implementation StopNotice

@dynamic chinese_money;
@dynamic citizen;
@dynamic disobey_item;
@dynamic maintainPlanCheck_id;
@dynamic money;
@dynamic myid;
@dynamic number;
@dynamic obey_kuan;
@dynamic obey_tiao;
@dynamic recorder;
@dynamic send_date;
@dynamic isuploaded;

@synthesize _maintianPlan;
@synthesize _checkplan;
+( StopNotice* )stopNoticeInfoForCheckID:(NSString *)checkID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"StopNotice" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"maintainPlanCheck_id==%@",checkID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        return [fetchResult objectAtIndex:0];
    } else {
        return nil;
    }

}
- (NSString *) construct_org{
    MaintainPlan *maintianPlan=nil;
    if (!_maintianPlan) {
        MaintainPlanCheck *checkplan = [[MaintainPlanCheck maintainCheckForID:self.maintainPlanCheck_id] objectAtIndex:0];
        maintianPlan= [MaintainPlan maintainPlanInfoForID:checkplan.maintainPlan_id];
    }
    return maintianPlan.construct_org;
}
- (NSString *) project_address{
    MaintainPlan *maintianPlan=nil;
    if (!_maintianPlan) {
        MaintainPlanCheck *checkplan = [[MaintainPlanCheck maintainCheckForID:self.maintainPlanCheck_id] objectAtIndex:0];
        maintianPlan= [MaintainPlan maintainPlanInfoForID:checkplan.maintainPlan_id];
    }
    return maintianPlan.project_address;
}
@end
