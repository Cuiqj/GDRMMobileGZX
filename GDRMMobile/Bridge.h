//
//  Bridge.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 16/12/20.
//
//

@interface Bridge : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * road_segment;
@property (nonatomic, retain) NSNumber * station_start;
@property (nonatomic, retain) NSNumber * station_end;
@property (nonatomic, retain) NSString * org_id;

+ (NSArray *)allBridge;
+ (NSArray *)bridgeNameForId:(NSString *)bridge_id;
@end