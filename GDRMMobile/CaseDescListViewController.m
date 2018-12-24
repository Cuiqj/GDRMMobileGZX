//
//  CaseDescListViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CaseDescListViewController.h"
#import "Systype.h"
#import "NSArray+NewCaseDescArray.h"
@interface CaseDescListViewController ()
@property (nonatomic,retain) NSArray *data;
@property (nonatomic,retain) NSArray *carLooksArray;
@end

@implementation CaseDescListViewController
@synthesize data=_data;
@synthesize popOver=_popOver;
@synthesize delegate=_delegate;
@synthesize poptype=_poptype;
@synthesize caseID=_caseID;

- (void)viewDidLoad
{   
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    if([self.poptype isEqual:@"2"]){
        self.data=self.carLooksArray;
    }else{
    self.data=[self.delegate getCaseDescArrayDelegate];
    }
}
-(NSArray *)carLooksArray{
    if (_carLooksArray==nil) {
        _carLooksArray=[NSArray newCarLookDescArray];
    }
    return _carLooksArray;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    CaseDescString *temp=[self.data objectAtIndex:indexPath.row];
    cell.textLabel.text=temp.caseDesc;
    if (temp.isSelected) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    CaseDescString *temp=[self.data objectAtIndex:indexPath.row];
    temp.isSelected=YES;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryNone;
    CaseDescString *temp=[self.data objectAtIndex:indexPath.row];
    temp.isSelected=NO;
}    

- (IBAction)btnCancel:(id)sender {
    [self.popOver dismissPopoverAnimated:YES];
}

- (IBAction)btnConfirm:(id)sender {
    [self.delegate setCaseDescArrayDelegate:self.data];
    [self.popOver dismissPopoverAnimated:YES];
}
@end

