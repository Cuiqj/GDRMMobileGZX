//
//  ParkingNode.m
//  GDRMMobile
//
//  Created by Sniper One on 12-11-15.
//
//

#import "ParkingNode.h"


@implementation ParkingNode

@dynamic offic_address;
@dynamic caseinfo_id;
@dynamic citizen_name;
@dynamic code;
@dynamic date_end;
@dynamic date_send;
@dynamic date_start;
@dynamic myid;
@dynamic isuploaded;
@dynamic limitday;
@dynamic department;
@dynamic name;
@dynamic telephone;
@dynamic case_disposal;
@dynamic instrument_name;
@dynamic instrument_choose;
@dynamic car_choose;
@dynamic car_number;
@dynamic car_type;
@dynamic nameNo;

- (NSString *) signStr{
    if (![self.caseinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"caseinfo_id == %@", self.caseinfo_id];
    }else{
        return @"";
    }
}

+ (void)deleteAllParkingNodeForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"ParkingNode" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id == %@",caseID];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    for (NSManagedObject *obj in temp) {
        [context deleteObject:obj];
    }
    [[AppDelegate App] saveContext];
}

+ (ParkingNode *)parkingNodesForCase:(NSString *)caseID
{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    if (results && [results count]>0) {
        return [results objectAtIndex:0];
    }else{
        return nil;
    }
}

+ (ParkingNode *)parkingNodesForCase:(NSString *)caseID withCitizenName:(NSString*)citizen_name
{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@ AND citizen_name==%@",caseID,citizen_name];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    if (results && [results count]>0) {
        return [results objectAtIndex:0];
    }else{
        return nil;
    }
}

@end
