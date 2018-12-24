//
//  InitMaintianPlan.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/1/12.
//
//
#import "InitMaintainPlan.h"
//#import "UserInfo.h"
#import "TBXML.h"
@implementation InitMaintainPlan

- (void)downMaintainPlan:(NSString *)orgID{
    WebServiceInit;
    [service downloadDataSet:@"select * from MaintainPlan" ];
    //[service downloadDataSet:[@"select * from MaintianPlan where org_id = " stringByAppendingString:orgID]];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"MaintainPlan" andInXMLString:webString];
}

@end