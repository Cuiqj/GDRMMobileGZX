//
//  NSArray+NewCaseDescArray.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSArray+NewCaseDescArray.h"
#import "LawbreakingAction.h"
#import "CaseInfo.h"
#import "Systype.h"

@implementation NSArray(NewCaseDescArray)

+(NSArray *)newCaseDescArray{
    NSArray *actionArray = [LawbreakingAction LawbreakingActionsForCasetype:CaseTypeIDDefault];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[actionArray count]];
    for (LawbreakingAction *action in actionArray) {
        CaseDescString *cds = [[CaseDescString alloc] init];
        cds.caseDesc = action.caption;
        cds.caseDescID = action.myid;
        cds.isSelected = NO;
        [tempArray addObject:cds];
    }
    
    if (tempArray.count > 3) {
        [tempArray removeObjectAtIndex:3];
    }
    ((CaseDescString*)tempArray[0]).caseDesc = @"损坏公路路产";
    ((CaseDescString*)tempArray[1]).caseDesc = @"损坏、污染公路路产";
    ((CaseDescString*)tempArray[2]).caseDesc = @"污染公路路产";
    return [NSArray arrayWithArray:tempArray];
}
+(NSArray *)newAdministrativePenaltyCaseDescArray{
    NSArray *actionArray = [LawbreakingAction LawbreakingActionsForCasetype:CaseTypeIDFa];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[actionArray count]];
    for (LawbreakingAction *action in actionArray) {
        CaseDescString *cds = [[CaseDescString alloc] init];
        cds.caseDesc = action.caption;
        cds.caseDescID = action.myid;
        cds.isSelected = NO;
        [tempArray addObject:cds];
    }
    return [NSArray arrayWithArray:tempArray];
}
+(NSArray*)newCarLookDescArray{

    NSArray *carLooks = [Systype sysTypeArrayForCodeName:@"车辆外观描述"];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[carLooks count]];
    for( NSString *adesc in carLooks){
    CaseDescString *cds = [[CaseDescString alloc] init];
        cds.caseDesc=adesc;
        cds.caseDescID=adesc;
        cds.isSelected=NO;
        [tempArray addObject:cds];
    }
    return [NSArray arrayWithArray:tempArray];
}
@end
