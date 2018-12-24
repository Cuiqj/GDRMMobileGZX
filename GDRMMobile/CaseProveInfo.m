//
//  CaseProveInfo.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-29.
//
//

#import "CaseProveInfo.h"
#import "CaseInfo.h"
#import "RoadSegment.h"
#import "Citizen.h"
#import "CaseDeformation.h"
#import "UserInfo.h"
#import "CaseInfo.h"

@interface CaseProveInfo ()
@property (nonatomic, retain, setter = setCaseInfo:) CaseInfo *_caseInfo;
@end

@implementation CaseProveInfo

@dynamic case_desc_id;
@dynamic case_short_desc;
@dynamic caseinfo_id;
@dynamic citizen_name;
@dynamic end_date_time;
@dynamic event_desc;
@dynamic invitee;
@dynamic invitee_org_duty;
@dynamic isuploaded;
@dynamic myid;
@dynamic organizer;
@dynamic organizer_org_duty;
@dynamic party;
@dynamic party_org_duty;
@dynamic prover;
@dynamic recorder;
//@dynamic recorder_org_duty;
@dynamic start_date_time;
@dynamic remark;
@dynamic secondProver;
@dynamic case_long_desc;

@synthesize _caseInfo;

- (NSString *) signStr{
    if (![self.caseinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"caseinfo_id == %@", self.caseinfo_id];
    }else{
        return @"";
    }
}

//读取案号对应的勘验记录
+(CaseProveInfo *)proveInfoForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseProveInfo" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        return [fetchResult objectAtIndex:0];
    } else {
        return nil;
    }
}
+ (NSString *)generateEventDescForInquire:(NSString *)caseID{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:caseID];
    NSString *roadName = [RoadSegment roadNameFromSegment:caseInfo.roadsegment_id];
    
    
    NSString *caseDescString = @"";
    
    //案件发生时间
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年M月d日HH时mm分"];
    NSString *happenDate = [dateFormatter stringFromDate:caseInfo.happen_date];
    
    //桩号
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setPositiveFormat:@"000"];
    NSString *stationStartKMString = [NSString stringWithFormat:@"%02d", caseInfo.station_start.integerValue / 1000];
    NSString *stationStartMString = [numFormatter stringFromNumber:[NSNumber numberWithInteger:caseInfo.station_start.integerValue % 1000]];
    NSString *stationString;
    if (caseInfo.station_end.integerValue == 0 || caseInfo.station_end.integerValue == caseInfo.station_start.integerValue  ) {
        stationString=[NSString stringWithFormat:@"K%@+%@m处",stationStartKMString,stationStartMString];
        if ([stationString isEqualToString:@"K00+000M处"]) {
            stationString=@"";
        }
        
    } else {
        NSInteger stationEndM = caseInfo.station_end.integerValue % 1000;
        NSString *stationEndKMString = [NSString stringWithFormat:@"%02d",caseInfo.station_end.integerValue / 1000];
        NSString *stationEndMString = [numFormatter stringFromNumber:[NSNumber numberWithInteger:stationEndM]];
        stationString = [NSString stringWithFormat:@"K%@+%@m至K%@+%@m处",stationStartKMString,stationStartMString,stationEndKMString,stationEndMString];
    }
    
    
    NSArray *citizenArray = [Citizen allCitizenNameForCase:caseID];
    if (citizenArray.count > 0) {
        if (citizenArray.count == 1) {
            Citizen *citizen = [citizenArray objectAtIndex:0];
            
            caseDescString = [caseDescString stringByAppendingFormat:@"我于%@驾驶%@%@行至%@%@%@%@，因%@发生交通事故，导致损坏公路路产。",happenDate,citizen.automobile_number,citizen.automobile_pattern,roadName,caseInfo.side,stationString,caseInfo.place,caseInfo.case_reason];
        }
        if (citizenArray.count > 1) {
            Citizen *citizen = [citizenArray objectAtIndex:0];
            caseDescString = [caseDescString stringByAppendingFormat:@"我%@于%@驾驶%@%@行至%@%@%@，与",citizen.party,happenDate,citizen.automobile_number,citizen.automobile_pattern,roadName,caseInfo.side,stationString];
            for (int i = 1;i < citizenArray.count;i++) {
                citizen = [citizenArray objectAtIndex:i];
                if (i == 1) {
                    caseDescString = [caseDescString stringByAppendingFormat:@"%@驾驶的%@%@",citizen.party,citizen.automobile_number,citizen.automobile_pattern];
                } else {
                    caseDescString = [caseDescString stringByAppendingFormat:@"、%@驾驶的%@%@",citizen.party,citizen.automobile_number,citizen.automobile_pattern];
                }
            }
            caseDescString = [caseDescString stringByAppendingFormat:@"因%@发生碰撞，发生交通事故，导致损坏公路路产。",caseInfo.case_reason];
            
        }
    }
    return caseDescString;
}



+ (NSString *)generateWoundDesc:(NSString *)caseID{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:caseID];
    
    //伤亡情况
    NSString *caseStatusString = @"";
    if (caseInfo.fleshwound_sum.integerValue == 0 && caseInfo.badwound_sum.integerValue == 0 && caseInfo.death_sum.integerValue == 0) {
        //caseStatusString = [caseStatusString stringByAppendingString:@"无人员伤亡。"];
        caseStatusString = [caseStatusString stringByAppendingString:@""];
    } else {
        if (caseInfo.fleshwound_sum.integerValue != 0) {
            caseStatusString = [caseStatusString stringByAppendingFormat:@"轻伤%@人。",caseInfo.fleshwound_sum];
        }
        if (caseInfo.badwound_sum.integerValue != 0) {
            caseStatusString = [caseStatusString stringByAppendingFormat:@"重伤%@人。",caseInfo.badwound_sum];
        }
        if (caseInfo.death_sum.integerValue != 0) {
            caseStatusString = [caseStatusString stringByAppendingFormat:@"死亡%@人。",caseInfo.death_sum];
        }
    }
    return caseStatusString;
}



+ (NSString*)generateDefaultPayReason:(NSString *)caseID{
    CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:caseID];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MatchLaw" ofType:@"plist"];
    NSDictionary *matchLaws = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSString *payReason = @"";
    if (matchLaws) {
        NSString *breakStr = @"";
        NSString *matchStr = @"";
        NSString *payStr = @"";
        NSDictionary *matchInfo = [[matchLaws objectForKey:@"case_desc_match_law"] objectForKey:proveInfo.case_desc_id];
        if (matchInfo) {
            if ([matchInfo objectForKey:@"breakLaw"]) {
                breakStr = [(NSArray *)[matchInfo objectForKey:@"breakLaw"] componentsJoinedByString:@"、"];
            }
            if ([matchInfo objectForKey:@"matchLaw"]) {
                matchStr = [(NSArray *)[matchInfo objectForKey:@"matchLaw"] componentsJoinedByString:@"、"];
            }
            if ([matchInfo objectForKey:@"payLaw"]) {
                payStr = [(NSArray *)[matchInfo objectForKey:@"payLaw"] componentsJoinedByString:@"、"];
            }
        }
        
        payReason = [NSString stringWithFormat:@"你违反了%@规定，根据%@规定，我们依法向你收取路产赔偿，赔偿标准为广东省交通厅、财政厅和物价局联合颁发的%@文件的规定，请问你有无异议？",breakStr, matchStr, payStr];
        
    }
    return payReason;
}

//现场平面图
+ (NSString *)generateEventMapForCase:(NSString *)caseID{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:caseID];
    NSString *roadName=[RoadSegment roadNameFromSegment:caseInfo.roadsegment_id];
    
    
    NSString *caseDescString=@"";
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    //案发时间字符串
    NSString *happenDate=[dateFormatter stringFromDate:caseInfo.happen_date];
    
    NSNumberFormatter *numFormatter=[[NSNumberFormatter alloc] init];
    [numFormatter setPositiveFormat:@"000"];
    NSInteger stationStartM=caseInfo.station_start.integerValue%1000;
    NSString *stationStartKMString=[NSString stringWithFormat:@"%02d", caseInfo.station_start.integerValue/1000];
    NSString *stationStartMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
    //桩号描述
    NSString *stationString;
    if (caseInfo.station_end.integerValue == 0 || caseInfo.station_end.integerValue == caseInfo.station_start.integerValue  ) {
        stationString=[NSString stringWithFormat:@"K%@+%@米处",stationStartKMString,stationStartMString];
    } else {
        NSInteger stationEndM=caseInfo.station_end.integerValue%1000;
        NSString *stationEndKMString=[NSString stringWithFormat:@"%02d",caseInfo.station_end.integerValue/1000];
        NSString *stationEndMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationEndM]];
        stationString=[NSString stringWithFormat:@"K%@+%@米至K%@+%@米之间",stationStartKMString,stationStartMString,stationEndKMString,stationEndMString ];
    }
    //伤亡人数描述
    NSString *caseStatusString=@"";
    if (caseInfo.fleshwound_sum.integerValue==0 && caseInfo.badwound_sum.integerValue==0 && caseInfo.death_sum.integerValue==0) {
        //caseStatusString=[caseStatusString stringByAppendingString:@"无人员伤亡，"];
        caseStatusString=[caseStatusString stringByAppendingString:@"无人员伤亡"];
    } else {
        caseStatusString=@"造成";
        if (caseInfo.fleshwound_sum.integerValue!=0) {
            caseStatusString=[caseStatusString stringByAppendingFormat:@"轻伤%@人",caseInfo.fleshwound_sum];
        }
        if (caseInfo.badwound_sum.integerValue!=0) {
            caseStatusString=[caseStatusString stringByAppendingFormat:@"重伤%@人",caseInfo.badwound_sum];
        }
        if (caseInfo.death_sum.integerValue!=0) {
            caseStatusString=[caseStatusString stringByAppendingFormat:@"死亡%@人",caseInfo.death_sum];
        }
    }
    
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSArray *citizenArray=[Citizen allCitizenNameForCase:caseID];
    //1个当事人的勘验检查结果和描述
    if (citizenArray.count>0) {
        if (citizenArray.count==1) {
            Citizen *citizen=[citizenArray objectAtIndex:0];
            // modified by cjl
            if (caseInfo.badcar_sum.integerValue!=0) {
                //        caseStatusString=[caseStatusString stringByAppendingFormat:@"损坏%@辆车",caseInfo.badcar_sum];
                caseStatusString=[caseStatusString stringByAppendingFormat:@"车辆%@损坏",citizen.bad_desc];
            } else {
                //caseStatusString=[caseStatusString stringByAppendingString:@"未造成车辆损坏"];
                caseStatusString=[caseStatusString stringByAppendingFormat:@""];
            }
            //公路路产描述
            NSString *Luchan=@"";
            
            caseDescString=[caseDescString stringByAppendingFormat:@"   %@于%@驾驶%@%@行至%@%@%@因%@导致%@撞向%@，车辆%@在%@，车头%@， 车身在%@，车尾在%@， 现场可见车辆%@。%@。",citizen.party,happenDate,citizen.automobile_number,citizen.automobile_pattern,roadName,caseInfo.side,stationString, caseInfo.case_reason, caseInfo.car_bump_part,caseInfo.bump_object,caseInfo.car_stop_status,caseInfo.car_stop_side,caseInfo.head_side,caseInfo.body_side,caseInfo.tail_side,caseInfo.car_looks,caseStatusString];
            NSEntityDescription *deformEntity=[NSEntityDescription entityForName:@"CaseDeformation" inManagedObjectContext:context];
            NSPredicate *deformPredicate=[NSPredicate predicateWithFormat:@"proveinfo_id ==%@ && citizen_name==%@",caseID,citizen.automobile_number];
            [fetchRequest setEntity:deformEntity];
            [fetchRequest setPredicate:deformPredicate];
            NSArray *deformArray=[context executeFetchRequest:fetchRequest error:nil];
            if (deformArray.count>0) {
                NSString *deformsString=@"";
                NSInteger  i=1;
                for (CaseDeformation *deform in deformArray) {
                    //i=1;
                    NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([roadSizeString isEmpty]) {
                        roadSizeString=@"";
                    } else {
                        roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
                    }
                    NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([remarkString isEmpty]) {
                        remarkString=@"";
                    } else {
                        
                        remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
                    }
                    NSString *quantity=[[NSString alloc] initWithFormat:@"%ld",deform.quantity.integerValue];
                    //                    NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
                    //                    quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
                    deformsString=[deformsString stringByAppendingFormat:@"    %d、%@%@%@%@%@；\n",i,deform.roadasset_name, roadSizeString,quantity,deform.unit,remarkString];
                    Luchan=[Luchan stringByAppendingFormat:@",%@%@%@",deform.roadasset_name, roadSizeString,deform.destory_degree];
                    i+=1;
                }
                NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
                deformsString=[deformsString stringByTrimmingCharactersInSet:charSet];
                NSCharacterSet *charSet2=[NSCharacterSet characterSetWithCharactersInString:@","];
                Luchan=[Luchan stringByTrimmingCharactersInSet:charSet2];
                caseDescString=[caseDescString stringByAppendingFormat:@"经现场勘验检查认定，损坏公路路产的事实为：%@",Luchan];
            } else {
                caseDescString=[caseDescString stringByAppendingString:@"经现场勘验检查认定，损坏公路路产的事实为：\n没有路产损坏。"];
            }
        }
        //多个当事人的勘验检查结果和描述
        if (citizenArray.count>1) {
            Citizen *citizen=[citizenArray objectAtIndex:0];
            caseDescString=[caseDescString stringByAppendingFormat:@"%@于%@驾驶%@%@行至%@%@%@，与",citizen.party,happenDate,citizen.automobile_number,citizen.automobile_pattern,roadName,caseInfo.side,stationString];
            for (int i=1;i<citizenArray.count;i++) {
                citizen=[citizenArray objectAtIndex:i];
                if (i==1) {
                    caseDescString=[caseDescString stringByAppendingFormat:@"%@驾驶的%@%@",citizen.party,citizen.automobile_number,citizen.automobile_pattern];
                } else {
                    caseDescString=[caseDescString stringByAppendingFormat:@"、%@驾驶的%@%@",citizen.party,citizen.automobile_number,citizen.automobile_pattern];
                }
            }
            caseDescString=[caseDescString stringByAppendingFormat:@"在公路%@由于%@发生碰撞，造成交通事故，%@，经与当事人现场勘查，",caseInfo.place,caseInfo.case_reason,caseStatusString];
            
            NSArray *deformArray=[CaseDeformation deformationsForCase:caseID];
            NSString *roadAssetString=@"";
            NSString *deformsString=@"";
            NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
            for (int i=0; i<citizenArray.count; i++) {
                roadAssetString=@"";
                for (CaseDeformation *deform in deformArray) {
                    if ([deform.citizen_name isEqualToString:[[citizenArray objectAtIndex:i] automobile_number]]) {
                        NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if ([roadSizeString isEmpty]) {
                            roadSizeString=@"";
                        } else {
                            roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
                        }
                        NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if ([remarkString isEmpty]) {
                            remarkString=@"";
                        } else {
                            remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
                        }
                        NSString *quantity=[[NSString alloc] initWithFormat:@"%ld",deform.quantity.integerValue];
                        //                    NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
                        //                    quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
                        roadAssetString=[roadAssetString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
                    }
                }
                roadAssetString=[roadAssetString stringByTrimmingCharactersInSet:charSet];
                if (![roadAssetString isEmpty]) {
                    deformsString=[deformsString stringByAppendingFormat:@"%@损坏路产：%@，",[[citizenArray objectAtIndex:i] automobile_number],roadAssetString];
                }
            }
            roadAssetString=@"";
            for (CaseDeformation *deform in deformArray) {
                if ([deform.citizen_name isEqualToString:@"共同"]) {
                    NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([roadSizeString isEmpty]) {
                        roadSizeString=@"";
                    } else {
                        roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
                    }
                    NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([remarkString isEmpty]) {
                        remarkString=@"";
                    } else {
                        remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
                    }
                    NSString *quantity=[[NSString alloc] initWithFormat:@"%ld",deform.quantity.integerValue];
                    //                    NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
                    //                    quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
                    roadAssetString=[roadAssetString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
                }
            }
            roadAssetString=[roadAssetString stringByTrimmingCharactersInSet:charSet];
            if (![roadAssetString isEmpty]) {
                NSString *citizenString=@"";
                for (int i=0; i<citizenArray.count; i++) {
                    citizenString=[citizenString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    citizenString=[citizenString stringByAppendingFormat:@"%@%@",([citizenString isEmpty]?@"":@"、"),[[citizenArray objectAtIndex:i] automobile_number]];
                }
                citizenString=[citizenString stringByTrimmingTrailingCharactersInSet:charSet];
                deformsString=[deformsString stringByAppendingFormat:@"%@共同损坏路产：%@，",[citizenString stringByTrimmingTrailingCharactersInSet:charSet],roadAssetString];
            }
            if (![deformsString isEmpty]) {
                NSCharacterSet *commaSet=[NSCharacterSet characterSetWithCharactersInString:@"，"];
                caseDescString=[caseDescString stringByAppendingFormat:@"%@。",[deformsString stringByTrimmingTrailingCharactersInSet:commaSet]];
            } else {
                caseDescString=[caseDescString stringByAppendingString:@"没有路产损坏。"];
            }
        }
    }
    return caseDescString;
}

+ (NSString *)generateEventDescForCase:(NSString *)caseID{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:caseID];
    NSString *roadName=[RoadSegment roadNameFromSegment:caseInfo.roadsegment_id];
    
    
    NSString *caseDescString=@"";
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    //案发时间字符串
    NSString *happenDate=[dateFormatter stringFromDate:caseInfo.happen_date];
    
    NSNumberFormatter *numFormatter=[[NSNumberFormatter alloc] init];
    [numFormatter setPositiveFormat:@"000"];
    NSInteger stationStartM=caseInfo.station_start.integerValue%1000;
    NSString *stationStartKMString=[NSString stringWithFormat:@"%02d", caseInfo.station_start.integerValue/1000];
    NSString *stationStartMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
    //桩号描述
    NSString *stationString;
    if (caseInfo.station_end.integerValue == 0 || caseInfo.station_end.integerValue == caseInfo.station_start.integerValue  ) {
        stationString=[NSString stringWithFormat:@"K%@+%@米处",stationStartKMString,stationStartMString];
    } else {
        NSInteger stationEndM=caseInfo.station_end.integerValue%1000;
        NSString *stationEndKMString=[NSString stringWithFormat:@"%02d",caseInfo.station_end.integerValue/1000];
        NSString *stationEndMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationEndM]];
        stationString=[NSString stringWithFormat:@"K%@+%@米至K%@+%@米之间",stationStartKMString,stationStartMString,stationEndKMString,stationEndMString ];
    }
    //伤亡人数描述
    NSString *caseStatusString=@"";
    if (caseInfo.fleshwound_sum.integerValue==0 && caseInfo.badwound_sum.integerValue==0 && caseInfo.death_sum.integerValue==0) {
        //caseStatusString=[caseStatusString stringByAppendingString:@"无人员伤亡，"];
        caseStatusString=[caseStatusString stringByAppendingString:@"无人员伤亡"];
    } else {
        caseStatusString=@"造成";
        if (caseInfo.fleshwound_sum.integerValue!=0) {
            caseStatusString=[caseStatusString stringByAppendingFormat:@"轻伤%@人",caseInfo.fleshwound_sum];
        }
        if (caseInfo.badwound_sum.integerValue!=0) {
            caseStatusString=[caseStatusString stringByAppendingFormat:@"重伤%@人",caseInfo.badwound_sum];
        }
        if (caseInfo.death_sum.integerValue!=0) {
            caseStatusString=[caseStatusString stringByAppendingFormat:@"死亡%@人",caseInfo.death_sum];
        }
    }
    
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSArray *citizenArray=[Citizen allCitizenNameForCase:caseID];
    //1个当事人的勘验检查结果和描述
    if (citizenArray.count>0) {
        if (citizenArray.count==1) {
            Citizen *citizen=[citizenArray objectAtIndex:0];
            // modified by cjl
            if (caseInfo.badcar_sum.integerValue!=0) {
                //        caseStatusString=[caseStatusString stringByAppendingFormat:@"损坏%@辆车",caseInfo.badcar_sum];
                caseStatusString=[caseStatusString stringByAppendingFormat:@"车辆%@损坏",citizen.bad_desc];
            } else {
                //caseStatusString=[caseStatusString stringByAppendingString:@"未造成车辆损坏"];
                caseStatusString=[caseStatusString stringByAppendingFormat:@""];
            }
            //公路路产描述
            NSString *Luchan=@"";
            
            caseDescString=[caseDescString stringByAppendingFormat:@"   %@于%@驾驶%@%@行至%@%@%@因%@导致%@撞向%@，车辆%@在%@，车头%@， 车身在%@，车尾在%@， 现场可见车辆%@。%@。",citizen.party,happenDate,citizen.automobile_number,citizen.automobile_pattern,roadName,caseInfo.side,stationString, caseInfo.case_reason, caseInfo.car_bump_part,caseInfo.bump_object,caseInfo.car_stop_status,caseInfo.car_stop_side,caseInfo.head_side,caseInfo.body_side,caseInfo.tail_side,caseInfo.car_looks,caseStatusString];
            NSEntityDescription *deformEntity=[NSEntityDescription entityForName:@"CaseDeformation" inManagedObjectContext:context];
            NSPredicate *deformPredicate=[NSPredicate predicateWithFormat:@"proveinfo_id ==%@ && citizen_name==%@",caseID,citizen.automobile_number];
            [fetchRequest setEntity:deformEntity];
            [fetchRequest setPredicate:deformPredicate];
            NSArray *deformArray=[context executeFetchRequest:fetchRequest error:nil];
            if (deformArray.count>0) {
                NSString *deformsString=@"";
                NSInteger  i=1;
                for (CaseDeformation *deform in deformArray) {
                    //i=1;
                    NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([roadSizeString isEmpty]) {
                        roadSizeString=@"";
                    } else {
                        roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
                    }
                    NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([remarkString isEmpty]) {
                        remarkString=@"";
                    } else {
                        
                        remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
                    }
                    NSString *quantity=[[NSString alloc] initWithFormat:@"%ld",deform.quantity.integerValue];
//                    NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
//                    quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
                    deformsString=[deformsString stringByAppendingFormat:@"    %d、%@%@%@%@%@；\n",i,deform.roadasset_name, roadSizeString,quantity,deform.unit,remarkString];
                    Luchan=[Luchan stringByAppendingFormat:@",%@%@%@",deform.roadasset_name, roadSizeString,deform.destory_degree];
                    i+=1;
                }
                NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
                deformsString=[deformsString stringByTrimmingCharactersInSet:charSet];
                NSCharacterSet *charSet2=[NSCharacterSet characterSetWithCharactersInString:@","];
                Luchan=[Luchan stringByTrimmingCharactersInSet:charSet2];
                caseDescString=[caseDescString stringByAppendingFormat:@"经现场勘验检查认定，损坏公路路产的事实为：\n%@",deformsString];
//                 caseDescString=[caseDescString stringByAppendingFormat:@"公路路产%@。经现场勘验检查认定，损坏公路路产的事实为：\n%@",Luchan,deformsString];
            } else {
                caseDescString=[caseDescString stringByAppendingString:@"经现场勘验检查认定，损坏公路路产的事实为：\n没有路产损坏。"];
            }
        }
        //多个当事人的勘验检查结果和描述
        if (citizenArray.count>1) {
            Citizen *citizen=[citizenArray objectAtIndex:0];
            caseDescString=[caseDescString stringByAppendingFormat:@"%@于%@驾驶%@%@行至%@%@%@，与",citizen.party,happenDate,citizen.automobile_number,citizen.automobile_pattern,roadName,caseInfo.side,stationString];
            for (int i=1;i<citizenArray.count;i++) {
                citizen=[citizenArray objectAtIndex:i];
                if (i==1) {
                    caseDescString=[caseDescString stringByAppendingFormat:@"%@驾驶的%@%@",citizen.party,citizen.automobile_number,citizen.automobile_pattern];
                } else {
                    caseDescString=[caseDescString stringByAppendingFormat:@"、%@驾驶的%@%@",citizen.party,citizen.automobile_number,citizen.automobile_pattern];
                }
            }
            caseDescString=[caseDescString stringByAppendingFormat:@"在公路%@由于%@发生碰撞，造成交通事故，%@，经与当事人现场勘查，",caseInfo.place,caseInfo.case_reason,caseStatusString];
            
            NSArray *deformArray=[CaseDeformation deformationsForCase:caseID];
            NSString *roadAssetString=@"";
            NSString *deformsString=@"";
            NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
            for (int i=0; i<citizenArray.count; i++) {
                roadAssetString=@"";
                for (CaseDeformation *deform in deformArray) {
                    if ([deform.citizen_name isEqualToString:[[citizenArray objectAtIndex:i] automobile_number]]) {
                        NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if ([roadSizeString isEmpty]) {
                            roadSizeString=@"";
                        } else {
                            roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
                        }
                        NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if ([remarkString isEmpty]) {
                            remarkString=@"";
                        } else {
                            remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
                        }
                        NSString *quantity=[[NSString alloc] initWithFormat:@"%ld",deform.quantity.integerValue];
                        //                    NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
                        //                    quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
                        roadAssetString=[roadAssetString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
                    }
                }
                roadAssetString=[roadAssetString stringByTrimmingCharactersInSet:charSet];
                if (![roadAssetString isEmpty]) {
                    deformsString=[deformsString stringByAppendingFormat:@"%@损坏路产：%@，",[[citizenArray objectAtIndex:i] automobile_number],roadAssetString];
                }
            }
            roadAssetString=@"";
            for (CaseDeformation *deform in deformArray) {
                if ([deform.citizen_name isEqualToString:@"共同"]) {
                    NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([roadSizeString isEmpty]) {
                        roadSizeString=@"";
                    } else {
                        roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
                    }
                    NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([remarkString isEmpty]) {
                        remarkString=@"";
                    } else {
                        remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
                    }
                    NSString *quantity=[[NSString alloc] initWithFormat:@"%ld",deform.quantity.integerValue];
                    //                    NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
                    //                    quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
                    roadAssetString=[roadAssetString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
                }
            }
            roadAssetString=[roadAssetString stringByTrimmingCharactersInSet:charSet];
            if (![roadAssetString isEmpty]) {
                NSString *citizenString=@"";
                for (int i=0; i<citizenArray.count; i++) {
                    citizenString=[citizenString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    citizenString=[citizenString stringByAppendingFormat:@"%@%@",([citizenString isEmpty]?@"":@"、"),[[citizenArray objectAtIndex:i] automobile_number]];
                }
                citizenString=[citizenString stringByTrimmingTrailingCharactersInSet:charSet];
                deformsString=[deformsString stringByAppendingFormat:@"%@共同损坏路产：%@，",[citizenString stringByTrimmingTrailingCharactersInSet:charSet],roadAssetString];
            }
            if (![deformsString isEmpty]) {
                NSCharacterSet *commaSet=[NSCharacterSet characterSetWithCharactersInString:@"，"];
                caseDescString=[caseDescString stringByAppendingFormat:@"%@。",[deformsString stringByTrimmingTrailingCharactersInSet:commaSet]];
            } else {
                caseDescString=[caseDescString stringByAppendingString:@"没有路产损坏。"];
            }
        }
    }
    return caseDescString;
}
+ (NSString *)generateEventDescForNotices:(NSString *)caseID{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:caseID];
    CaseProveInfo *caseProveInfo= [self proveInfoForCase:caseID];
    NSString *roadName=[RoadSegment roadNameFromSegment:caseInfo.roadsegment_id];
    
    
    NSString *caseDescString=@"";
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    NSString *happenDate=[dateFormatter stringFromDate:caseInfo.happen_date];
    
    NSNumberFormatter *numFormatter=[[NSNumberFormatter alloc] init];
    [numFormatter setPositiveFormat:@"000"];
    NSInteger stationStartM=caseInfo.station_start.integerValue%1000;
    NSString *stationStartKMString=[NSString stringWithFormat:@"%02d", caseInfo.station_start.integerValue/1000];
    NSString *stationStartMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
    NSString *stationString;
    if (caseInfo.station_end.integerValue == 0 || caseInfo.station_end.integerValue == caseInfo.station_start.integerValue  ) {
        stationString=[NSString stringWithFormat:@"K%@+%@米处",stationStartKMString,stationStartMString];
    } else {
        NSInteger stationEndM=caseInfo.station_end.integerValue%1000;
        NSString *stationEndKMString=[NSString stringWithFormat:@"%02d",caseInfo.station_end.integerValue/1000];
        NSString *stationEndMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationEndM]];
        stationString=[NSString stringWithFormat:@"K%@+%@米至K%@+%@米之间",stationStartKMString,stationStartMString,stationEndKMString,stationEndMString ];
    }
    
    NSString *caseStatusString=@"";//伤亡和车辆损坏情况
    if (caseInfo.fleshwound_sum.integerValue==0 && caseInfo.badwound_sum.integerValue==0 && caseInfo.death_sum.integerValue==0) {
        //caseStatusString=[caseStatusString stringByAppendingString:@"无人员伤亡，"];
        caseStatusString=[caseStatusString stringByAppendingString:@""];
    } else {
        caseStatusString=@"造成";
        if (caseInfo.fleshwound_sum.integerValue!=0) {
            caseStatusString=[caseStatusString stringByAppendingFormat:@"轻伤%@人，",caseInfo.fleshwound_sum];
        }
        if (caseInfo.badwound_sum.integerValue!=0) {
            caseStatusString=[caseStatusString stringByAppendingFormat:@"重伤%@人，",caseInfo.badwound_sum];
        }
        if (caseInfo.death_sum.integerValue!=0) {
            caseStatusString=[caseStatusString stringByAppendingFormat:@"死亡%@人，",caseInfo.death_sum];
        }
    }
    
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSArray *citizenArray=[Citizen allCitizenNameForCase:caseID];
    if (citizenArray.count>0) {
        if (citizenArray.count==1) {
            Citizen *citizen=[citizenArray objectAtIndex:0];
            // modified by cjl
            if (caseInfo.badcar_sum.integerValue!=0) {
                //        caseStatusString=[caseStatusString stringByAppendingFormat:@"损坏%@辆车",caseInfo.badcar_sum];
                caseStatusString=[caseStatusString stringByAppendingFormat:@"车辆%@损坏",citizen.bad_desc];
            } else {
                //caseStatusString=[caseStatusString stringByAppendingString:@"未造成车辆损坏"];
                caseStatusString=[caseStatusString stringByAppendingString:@""];
            }
            NSString *anyoufornotice=caseProveInfo.case_short_desc;
            if([anyoufornotice isEqualToString:@"损坏公路路产"]){
             anyoufornotice=@"公路路产损坏";
            }
            else if ([anyoufornotice isEqualToString:@"污染公路路产"]){
            anyoufornotice=@"公路路产污染";
            }else;
            caseDescString=[caseDescString stringByAppendingFormat:@"于%@驾驶%@%@行至%@%@%@, 因%@%@，造成%@，经现场勘验检查认定",happenDate,citizen.automobile_number,citizen.automobile_pattern,roadName,caseInfo.side,stationString, caseInfo.case_reason,caseInfo.case_type,anyoufornotice];
            NSEntityDescription *deformEntity=[NSEntityDescription entityForName:@"CaseDeformation" inManagedObjectContext:context];
            NSPredicate *deformPredicate=[NSPredicate predicateWithFormat:@"proveinfo_id ==%@ && citizen_name==%@",caseID,citizen.automobile_number];
            [fetchRequest setEntity:deformEntity];
            [fetchRequest setPredicate:deformPredicate];
            NSArray *deformArray=[context executeFetchRequest:fetchRequest error:nil];
            if (deformArray.count>0) {
                NSString *deformsString=@"";
                for (CaseDeformation *deform in deformArray) {
                    NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([roadSizeString isEmpty]) {
                        roadSizeString=@"";
                    } else {
                        roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
                    }
                    NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([remarkString isEmpty]) {
                        remarkString=@"";
                    } else {
                        
                        remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
                    }
                    NSString *quantity=[[NSString alloc] initWithFormat:@"%ld",deform.quantity.integerValue];
                    //                    NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
                    //                    quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
                    deformsString=[deformsString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name, roadSizeString,quantity,deform.unit,remarkString];//deform.destory_degree,
                }
                NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
                deformsString=[deformsString stringByTrimmingCharactersInSet:charSet];
                caseDescString=[caseDescString stringByAppendingFormat:@"损坏的事实为：%@。",deformsString];
            } else {
                caseDescString=[caseDescString stringByAppendingString:@"损坏的事实为：没有路产损坏。"];
            }
        }
        if (citizenArray.count>1) {
            Citizen *citizen=[citizenArray objectAtIndex:0];
            caseDescString=[caseDescString stringByAppendingFormat:@"%@于%@驾驶%@%@行至%@%@%@，与",citizen.party,happenDate,citizen.automobile_number,citizen.automobile_pattern,roadName,caseInfo.side,stationString];
            for (int i=1;i<citizenArray.count;i++) {
                citizen=[citizenArray objectAtIndex:i];
                if (i==1) {
                    caseDescString=[caseDescString stringByAppendingFormat:@"%@驾驶的%@%@",citizen.party,citizen.automobile_number,citizen.automobile_pattern];
                } else {
                    caseDescString=[caseDescString stringByAppendingFormat:@"、%@驾驶的%@%@",citizen.party,citizen.automobile_number,citizen.automobile_pattern];
                }
            }
            caseDescString=[caseDescString stringByAppendingFormat:@"在公路%@由于%@发生碰撞，造成交通事故，%@，经与当事人现场勘查，",caseInfo.place,caseInfo.case_reason,caseStatusString];
            
            NSArray *deformArray=[CaseDeformation deformationsForCase:caseID];
            NSString *roadAssetString=@"";
            NSString *deformsString=@"";
            NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
            for (int i=0; i<citizenArray.count; i++) {
                roadAssetString=@"";
                for (CaseDeformation *deform in deformArray) {
                    if ([deform.citizen_name isEqualToString:[[citizenArray objectAtIndex:i] automobile_number]]) {
                        NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if ([roadSizeString isEmpty]) {
                            roadSizeString=@"";
                        } else {
                            roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
                        }
                        NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if ([remarkString isEmpty]) {
                            remarkString=@"";
                        } else {
                            remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
                        }
                        NSString *quantity=[[NSString alloc] initWithFormat:@"%ld",deform.quantity.integerValue];
                        //                    NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
                        //                    quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
                        roadAssetString=[roadAssetString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
                    }
                }
                roadAssetString=[roadAssetString stringByTrimmingCharactersInSet:charSet];
                if (![roadAssetString isEmpty]) {
                    deformsString=[deformsString stringByAppendingFormat:@"%@损坏路产：%@，",[[citizenArray objectAtIndex:i] automobile_number],roadAssetString];
                }
            }
            roadAssetString=@"";
            for (CaseDeformation *deform in deformArray) {
                if ([deform.citizen_name isEqualToString:@"共同"]) {
                    NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([roadSizeString isEmpty]) {
                        roadSizeString=@"";
                    } else {
                        roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
                    }
                    NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([remarkString isEmpty]) {
                        remarkString=@"";
                    } else {
                        remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
                    }
                    NSString *quantity=[[NSString alloc] initWithFormat:@"%ld",deform.quantity.integerValue];
                    //                    NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
                    //                    quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
                    roadAssetString=[roadAssetString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
                }
            }
            roadAssetString=[roadAssetString stringByTrimmingCharactersInSet:charSet];
            if (![roadAssetString isEmpty]) {
                NSString *citizenString=@"";
                for (int i=0; i<citizenArray.count; i++) {
                    citizenString=[citizenString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    citizenString=[citizenString stringByAppendingFormat:@"%@%@",([citizenString isEmpty]?@"":@"、"),[[citizenArray objectAtIndex:i] automobile_number]];
                }
                citizenString=[citizenString stringByTrimmingTrailingCharactersInSet:charSet];
                deformsString=[deformsString stringByAppendingFormat:@"%@共同损坏路产：%@，",[citizenString stringByTrimmingTrailingCharactersInSet:charSet],roadAssetString];
            }
            if (![deformsString isEmpty]) {
                NSCharacterSet *commaSet=[NSCharacterSet characterSetWithCharactersInString:@"，"];
                caseDescString=[caseDescString stringByAppendingFormat:@"%@。",[deformsString stringByTrimmingTrailingCharactersInSet:commaSet]];
            } else {
                caseDescString=[caseDescString stringByAppendingString:@"没有路产损坏。"];
            }
        }
    }
    return caseDescString;
}

- (NSString *) case_mark2{
    if (!_caseInfo) {
        [self setCaseInfo:[CaseInfo caseInfoForID:self.caseinfo_id]];
    }
    return _caseInfo.case_mark2;
}

- (NSString *) full_case_mark3{
    if (!_caseInfo) {
        [self setCaseInfo:[CaseInfo caseInfoForID:self.caseinfo_id]];
    }
    return _caseInfo.full_case_mark3;
}

- (NSString *) weater{
    if (!_caseInfo) {
        [self setCaseInfo:[CaseInfo caseInfoForID:self.caseinfo_id]];
    }
    return _caseInfo.weater;
}

- (NSString *) prover1{
    NSArray *chunks = [self.prover componentsSeparatedByString: @","];
    if([chunks count]==2)
    {
        //勘验人1 单位职务
        return [chunks objectAtIndex:0];
    }else{
        return self.prover;
    }
}

- (NSString *) prover1_org_duty{
    NSArray *chunks = [self.prover componentsSeparatedByString: @","];
    if([chunks count]==2)
    {
        //勘验人1 单位职务
        return [[[UserInfo orgAndDutyForUserName:[chunks objectAtIndex:0]]
                 stringByReplacingOccurrencesOfString: @"一中队" withString: @"" ] stringByReplacingOccurrencesOfString: @"二中队" withString: @"" ];
    }
    else
    {
        return [[[UserInfo orgAndDutyForUserName:self.prover]
    stringByReplacingOccurrencesOfString: @"一中队" withString: @"" ] stringByReplacingOccurrencesOfString: @"二中队" withString: @"" ];
    }
}

- (NSString *) prover2{
    NSArray *chunks = [self.prover componentsSeparatedByString: @","];
    if(chunks && [chunks count]>=2)
    {
        //勘验人2 单位职务
        return [chunks objectAtIndex:1];
    }else{
        return self.secondProver;
        return @"";
    }
}

- (NSString *) prover2_org_duty{
    NSArray *chunks = [self.prover componentsSeparatedByString: @","];
    if(chunks && [chunks count]>=2)
    {
        //勘验人1 单位职务
        return [[[UserInfo orgAndDutyForUserName:[chunks objectAtIndex:1]]
        stringByReplacingOccurrencesOfString: @"一中队" withString: @"" ] stringByReplacingOccurrencesOfString: @"二中队" withString: @"" ];
        
    }
    else if ([self.secondProver length] > 0)
    {
        return [[[UserInfo orgAndDutyForUserName:self.secondProver]
    stringByReplacingOccurrencesOfString: @"一中队" withString: @"" ] stringByReplacingOccurrencesOfString: @"二中队" withString: @"" ];
    }else {
        return @"";
    }
}
- (NSString *) citizen_org_duty{
    Citizen *citizen = [Citizen citizenForCitizenName:self.citizen_name nexus:@"当事人" case:self.caseinfo_id];
    return [NSString stringWithFormat:@"%@%@", citizen.org_name, citizen.org_principal_duty];
}

- (NSString *) recorder_org_duty{
    //return [UserInfo orgAndDutyForUserName:self.recorder];
     return  [[ [UserInfo orgAndDutyForUserName:self.recorder] stringByReplacingOccurrencesOfString: @"二中队" withString: @""] stringByReplacingOccurrencesOfString: @"一中队" withString: @""];
}

@end
