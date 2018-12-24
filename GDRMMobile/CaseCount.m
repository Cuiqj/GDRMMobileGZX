//
//  CaseCount.m
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-7.
//
//

#import "CaseCount.h"
#import "NSNumber+NumberConvert.h"


@implementation CaseCount

@dynamic caseinfo_id;
@dynamic citizen_name;
@dynamic sum;
@dynamic chinese_sum;
@dynamic happenTime;
@synthesize case_count_list;

-(NSString *) chinese_sum_sw{
    if (![self.chinese_sum isEmpty]) {
        double num = [self.sum doubleValue]/10000;
        NSString *chinese = [[NSNumber numberWithDouble:num] numberConvertToChineseCapitalNumberString];
        if (![chinese isEmpty]) {
            NSRange found = [chinese rangeOfString:@"拾"];
            if (found.location != NSNotFound) {
                NSString *result = [chinese substringWithRange:NSMakeRange(found.location-1, 1)];
                return result;
            }
        }
    }
    return @"零";
}
-(NSString *) chinese_sum_w{
//    if (![self.chinese_sum isEmpty]) {
//        if (![self.chinese_sum isEmpty]) {
//            NSRange found = [self.chinese_sum rangeOfString:@"万"];
//            if (found.location != NSNotFound) {
//                NSString *result = [self.chinese_sum substringToIndex:found.location];
//                return result;
//            }
//        }
//    }
//    return @"零";
    if (![self.chinese_sum isEmpty]) {
        double numdou = [self.sum doubleValue]/10000;
        NSString * str =  @"玖捌柒陆伍肆叁贰壹";
        NSString * numstring = [NSString stringWithFormat:@"%f",numdou];
        NSInteger num = [numstring integerValue];
        num = num % 10;
        if (num > 0 &&  num < 10) {
            for (int i = 9; i>0; i--) {
                if ( i- num == 0) {
                  return [str substringWithRange:NSMakeRange(9-i, 1)];
                }
            }
        }
    }
    return @"零";
}
-(NSString *) chinese_sum_q{
    if (![self.chinese_sum isEmpty]) {
        double num = fmod([self.sum doubleValue], 10000);
        NSString *chinese = [[NSNumber numberWithDouble:num] numberConvertToChineseCapitalNumberString];
        if (![chinese isEmpty]) {
            NSRange found = [chinese rangeOfString:@"仟"];
            if (found.location != NSNotFound) {
                NSString *result = [chinese substringWithRange:NSMakeRange(found.location-1, 1)];
                return result;
            }
        }
    }
    return @"零";
}
-(NSString *) chinese_sum_b{
    if (![self.chinese_sum isEmpty]) {
        double num = fmod([self.sum doubleValue], 10000);
        NSString *chinese = [[NSNumber numberWithDouble:num] numberConvertToChineseCapitalNumberString];
        if (![chinese isEmpty]) {
            NSRange found = [chinese rangeOfString:@"佰"];
            if (found.location != NSNotFound) {
                NSString *result = [chinese substringWithRange:NSMakeRange(found.location-1, 1)];
                return result;
            }
        }
    }
    return @"零";
}
-(NSString *) chinese_sum_s{
    if (![self.chinese_sum isEmpty]) {
        double num = fmod([self.sum doubleValue], 10000);
        NSString *chinese = [[NSNumber numberWithDouble:num] numberConvertToChineseCapitalNumberString];
        if (![chinese isEmpty]) {
            NSRange found = [chinese rangeOfString:@"拾"];
            if (found.location != NSNotFound) {
                NSString *result = [chinese substringWithRange:NSMakeRange(found.location-1, 1)];
                return result;
            }
        }
    }
    return @"零";
}
-(NSString *) chinese_sum_y{
    if (![self.chinese_sum isEmpty]) {
        double num = fmod([self.sum doubleValue], 10000);
        NSString *chinese = [[NSNumber numberWithDouble:num] numberConvertToChineseCapitalNumberString];
        if (![chinese isEmpty]) {
            NSRange single = [chinese rangeOfString:@"元"];
            if (single.location != NSNotFound) {
                NSRange ten = [chinese rangeOfString:@"拾"];
                if (ten.location == NSNotFound || abs(ten.location - single.location) > 1) {
                    NSString *result = [chinese substringWithRange:NSMakeRange(single.location-1, 1)];
                    NSString * str =  @"玖捌柒陆伍肆叁贰壹";
                    if([str containsString:result]){
                        return result;
                    }
                    return @"零";
                }
            }
        }
    }
    return @"零";
}
-(NSString *) chinese_sum_j{
    if (![self.chinese_sum isEmpty]) {
        if (![self.chinese_sum isEmpty]) {
            NSRange found = [self.chinese_sum rangeOfString:@"角"];
            if (found.location != NSNotFound) {
                NSString *result = [self.chinese_sum substringWithRange:NSMakeRange(found.location-1, 1)];
                return result;
            }
        }
    }
    return @"零";
}
-(NSString *) chinese_sum_f{
    if (![self.chinese_sum isEmpty]) {
        if (![self.chinese_sum isEmpty]) {
            NSRange found = [self.chinese_sum rangeOfString:@"分"];
            if (found.location != NSNotFound) {
                NSString *result = [self.chinese_sum substringWithRange:NSMakeRange(found.location-1, 1)];
                return result;
            }
        }
    }
    return @"零";
}
+(CaseCount*) caseCountForCaseInfoId:(NSString*) caseinfoID{
    NSManagedObjectContext *context =[[AppDelegate App ] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CaseCount" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"caseinfo_id = %@", caseinfoID];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    // NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid" ascending:YES];
    //[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil||fetchedObjects.count==0) {
        return  nil;
    }
    return [fetchedObjects objectAtIndex:0];
}
@end
