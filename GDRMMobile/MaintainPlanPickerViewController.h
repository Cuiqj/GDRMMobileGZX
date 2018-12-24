//
//  MaintainPlanPickerViewController.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/1/18.
//
//

#import <UIKit/UIKit.h>
#import "MaintainPlan.h"

@protocol MaintainPlanPickerDelegate;

@interface MaintainPlanPickerViewController : UITableViewController

@property (nonatomic,weak) id<MaintainPlanPickerDelegate> delegate;
@property (nonatomic,weak) UIPopoverController *pickerPopover;
@property (assign,nonatomic) NSInteger pickerType;
@end

@protocol MaintainPlanPickerDelegate <NSObject>

-(void)setMaintainPlan:(NSString *)name andID:(NSString *)PlanID;

@end