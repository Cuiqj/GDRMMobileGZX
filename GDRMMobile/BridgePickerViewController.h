//
//  BridgePickerViewController.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 16/12/21.
//
//

#import <UIKit/UIKit.h>
#import "RoadSegment.h"
#import "Table101.h"

typedef enum {
    kBridgeName = 0,
    kBridgeDesc
} BridgePickerState;

@protocol BridgePickerDelegate;

@interface BridgePickerViewController : UITableViewController
@property (assign, nonatomic) BridgePickerState pickerState;
@property (weak, nonatomic) UIPopoverController *pickerPopover;
@property (weak, nonatomic) id<BridgePickerDelegate> delegate;

@end

@protocol BridgePickerDelegate <NSObject>
@optional


- (void)setBridge:(NSString *)aBridgeID roadName:(NSString *)raBridgeName;
- (void)setBridgeDesc:(NSString *)aBridgeDesc;

@end