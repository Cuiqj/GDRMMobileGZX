//
//  OrgSyncViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-15.
//
//

#import <UIKit/UIKit.h>
#import "WebServiceHandler.h"
#import "OrgInfo.h"
#import "TBXML.h"
#import "DataDownLoad.h"

@protocol OrgSetDelegate;

@interface OrgSyncViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,WebServiceReturnString, UIAlertViewDelegate>
@property (retain, nonatomic) DataDownLoad *dataDownLoader;
//@property (weak, nonatomic) IBOutlet UITableView *tableOrgList;
@property (weak, nonatomic) IBOutlet UITextField *textServerAddress;
@property (weak, nonatomic) id<OrgSetDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableOrgList;
//@property (weak, nonatomic) int MyOrg_id;
//@property (weak, nonatomic) IBOutlet UILabel *versionName;
//@property (weak, nonatomic) IBOutlet UILabel *versionTime;

//确定当前服务器地址
- (IBAction)setCurrentOrg:(UIBarButtonItem *)sender;
- (IBAction)showServerAddress:(UIBarButtonItem *)sender;


@end

@protocol OrgSetDelegate <NSObject>

- (void)pushLoginView;
@end