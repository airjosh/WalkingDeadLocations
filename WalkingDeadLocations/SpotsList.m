//
//  SpotsList.m
//  WalkingDeadLocations
//
//  Created by MCS on 3/30/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import "SpotsList.h"
#import "SpotDetailCell.h"
#import "SpotDetail.h"
#import "DataRetriever.h"

@interface SpotsList () <DataRetrieverDelegate>


@property (nonatomic,strong) NSArray * data;


@end

@implementation SpotsList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
   
    
    DataRetriever * dataRetriever = [[DataRetriever alloc] init];
    dataRetriever.delegate = self;
    [dataRetriever setUpInformation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark: - Data Retriever Delegate
- (void) dataRetriever: (DataRetriever *) dataRetriever didFinishSetUpInformation:(NSArray *)dataArray{
    self.data = dataArray;
    NSLog(@"data from method : %@",dataArray);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
// #warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
// #warning Incomplete implementation, return the number of rows
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"customDetailCell";
 
 SpotDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
 
 NSString   *string     = self.data[indexPath.row];
 
 cell.spotNameLbl.text = string;
 
 return cell;
 
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SpotDetail *detailViewController = (SpotDetail *)segue.destinationViewController;
    
    // Get the index of the selected cell
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    
    // Set the title of the destination view controller
    // detailViewController.navigationItem.title = self.data[indexPath.row];
    NSString* string = self.data[indexPath.row];
    
    
    detailViewController.navigationItem.title = string;
    
}


@end
