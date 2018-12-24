//
//  BridgePickerViewController.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 16/12/21.
//
//

#import "BridgePickerViewController.h"
#import "Systype.h"
#import "Table101.h"

@interface BridgePickerViewController ()
@property (nonatomic,retain) NSArray *data;
@end

@implementation BridgePickerViewController
@synthesize data = _data;
@synthesize pickerPopover = _pickerPopover;
@synthesize pickerState = _pickerState;

- (void)viewWillAppear:(BOOL)animated{
    switch (self.pickerState) {
        case kBridgeName:
            self.data=[Table101 allBridge];
            break;
        case kBridgeDesc:
            self.data=[Systype typeValueForCodeName:@"巡查桥下空间描述"];
            break;
        default:
            break;
    }
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setData:nil];
    [self setPickerPopover:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (self.pickerState==kBridgeName) {
        cell.textLabel.text=[[self.data objectAtIndex:indexPath.row] valueForKey:@"name"];
    } else {
        cell.textLabel.text=[self.data objectAtIndex:indexPath.row];
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.pickerState) {
        case kBridgeName:
            [self.delegate setBridge: [[self.data objectAtIndex:indexPath.row] valueForKey:@"myid"] roadName: [[self.data objectAtIndex:indexPath.row] valueForKey:@"name"]];
            break;
        case kBridgeDesc:
            [self.delegate setBridgeDesc:[self.data objectAtIndex:indexPath.row]];
            break;
        default:
            break;
    }
    [self.pickerPopover dismissPopoverAnimated:YES];
}

@end
