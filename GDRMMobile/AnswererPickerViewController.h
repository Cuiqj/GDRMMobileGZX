//
//  AnswererPickerViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Citizen.h"
#import "UserInfo.h"

@protocol setAnswererDelegate;

@interface AnswererPickerViewController : UITableViewController
@property (nonatomic,weak) id<setAnswererDelegate> delegate;
//@property (nonatomic,copy) NSString *caseID;
@property (nonatomic,weak) UIPopoverController *pickerPopover;
@property (nonatomic,assign) NSInteger pickerType;
@end

@protocol setAnswererDelegate <NSObject>
-(void)setNexusDelegate:(NSString *)aText;
-(void)setAnswererDelegate:(NSString *)aText;

@optional
-(NSString *)getCaseIDDelegate;
-(NSString *)getNexusDelegate;
-(NSString *)getAskIDDelegate;
- (NSString *)caseDescription;
- (NSString *)GeRenOrGongSi;
-(void)setAskSentence:(NSString *)askSentence withAskID:(NSString *)askID;
-(void)setMuban:(NSString *)MubanMing withMubanType_Value:(NSString *)Type_Value;
-(void)setAnswerSentence:(NSString *)answerSentence;
@end