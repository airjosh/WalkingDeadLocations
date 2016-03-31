//
//  ViewController.m
//  WalkingDeadLocations
//
//  Created by MCS on 3/30/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import "ViewController.h"
#import "SpotDetailCell.h"
#import "SpotDetail.h"

@interface ViewController ()

@property (nonatomic,strong) NSArray * data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.data = @[@"monday",@"friday",@"sunday"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // #warning Incomplete implementation, return the number of sections
    return 1;
}// end of numberOfSectionsInTableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // #warning Incomplete implementation, return the number of rows
    
    return self.data.count;
}// end of numberOfRowsInSection

//delete this
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // the table view cell at indexpath got selected
    // NSLog(@"Selected %@", self.data[indexPath.row]);
    // NSLog(@"Selected %@", self.principalArray[indexPath.row]);
}// end of didSelectRowAtIndexPath

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    
    static NSString *CellIdentifier = @"customDetailCell";
    
    SpotDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString   *string     = self.data[indexPath.row];
    
    cell.spotNameLbl.text = string;
    
    return cell;
    
}// end of cellForRowAtIndexPath


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // #warning make sure that you connect source and destination by segue
    
    SpotDetail *detailViewController = (SpotDetail *)segue.destinationViewController;
    
    // Get the index of the selected cell
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    
    // Set the title of the destination view controller
    // detailViewController.navigationItem.title = self.data[indexPath.row];
    NSString* string = self.data[indexPath.row];
    
    
    detailViewController.navigationItem.title = string;
    
    
    
    
}// end of prepareForSegue




@end
