//
//  InitUser.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitUser.h"
#import "UserInfo.h"

@implementation InitUser

- (void)downLoadUserInfo:(NSString *)orgID{
    WebServiceInit;
    //[service downloadDataSet:@"select * from UserInfo" orgid:orgID];
    [service downloadDataSet:[@"select * from UserInfo where org_id = " stringByAppendingString:orgID]];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"UserInfo" andInXMLString:webString];
}

@end

@implementation InitOrgInfo

- (void)downLoadOrgInfo:(NSString *)orgID{
    WebServiceInit;
    [service downloadDataSet:@"select * from OrgInfo" orgid:orgID];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"OrgInfo" andInXMLString:webString];
}
@end
