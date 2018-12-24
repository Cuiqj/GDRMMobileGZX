//
//  MaintianPlanCheck.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/1/12.
//
//

#import "MaintainPlanCheck.h"


@implementation MaintainPlanCheck

@dynamic myid;
@dynamic inspection_id;
@dynamic maintainPlan_id;
@dynamic checktype;
@dynamic check_date;
@dynamic checkitem1;
@dynamic checkitem2;
@dynamic checkitem3;
@dynamic checkitem4;
@dynamic have_rectify;
@dynamic rectify_no;
@dynamic have_stopwork;
@dynamic stopwork_no;
@dynamic check_remark;
@dynamic isphoto;
@dynamic isreport;
@dynamic checker;
@dynamic safety;
@dynamic duty_opinion;
@dynamic org_id;
@dynamic classe;
@dynamic isuploaded;
+ (NSArray *)maintainCheckForID:(NSString *)maintainCheckID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if ([maintainCheckID isEmpty]) {
        [fetchRequest setPredicate:nil];
    } else {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myid == %@ ",maintainCheckID]];
    }
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
