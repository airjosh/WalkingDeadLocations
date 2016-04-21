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
#import "Location.h"
#import "LocationSingleton.h"


@interface SpotsList () <DataRetrieverDelegate, LocationSingletonDelegate>


@property (nonatomic,strong) NSArray * data;

@property (strong, nonatomic) NSDictionary *dictSeasonsList;
@property (strong, nonatomic) NSArray *arrSeasons;
@property (strong, nonatomic) NSArray *arrCurrentSeason;
@property (strong, nonatomic) DataRetriever *dataRetriever;
@property (strong, nonatomic) NSMutableDictionary *dictShowingSeciton;
@property (assign, nonatomic) BOOL isShowingList;
@property (strong, nonatomic) LocationSingleton *locationManager;


@end

@implementation SpotsList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.dataRetriever = [[DataRetriever alloc] init];
//    self.dictSeasonsList = [[NSDictionary alloc] init];
    self.arrSeasons = [[NSArray alloc] init];
    self.arrCurrentSeason = [[NSArray alloc] init];
    self.dictShowingSeciton = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    self.dataRetriever.delegate = self;
    [self.dataRetriever setUpInformation];
//    self.locationManager = [LocationSingleton sharedManager];
//    self.locationManager.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated {
    self.locationManager = [LocationSingleton sharedManager];
    self.locationManager.delegate = self;
    NSLog(@"Locations appear");
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

-(void)dataRetriever:(DataRetriever *)dataRetriever didNotRetrieveInformationWithError:(NSError *)error{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error!" message:@"No data was retrieved, please try again later" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       [alert dismissViewControllerAnimated:YES completion:nil];
        exit(0);
    }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(void)dataRetriever:(DataRetriever *)dataRetriever didRetrieveInformationWithDictionary:(NSDictionary *)dictionary{
    self.dictSeasonsList = [[NSDictionary alloc] initWithDictionary:dictionary];
    self.arrSeasons = [NSMutableArray arrayWithArray:[self.dictSeasonsList allKeys]];
    
    self.arrSeasons = [self.arrSeasons sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSString *season in self.arrSeasons) {
        [self.dictShowingSeciton setObject:@NO forKey:season];
    }
    
    [self.tableView reloadData];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
// #warning Incomplete implementation, return the number of sections
    return [self.arrSeasons count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
// #warning Incomplete implementation, return the number of rows
    
    if ([[self.dictShowingSeciton objectForKey:[self.arrSeasons objectAtIndex:section]] boolValue]) {
        self.arrCurrentSeason = [self.dictSeasonsList objectForKey:[self.arrSeasons objectAtIndex:section]];
        return [self.arrCurrentSeason count];
    }
    else{
        return 0;
    }
    
//    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"customDetailCell";
    SpotDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //
    // NSString   *string     = self.data[indexPath.row];
    //
    // cell.spotNameLbl.text = string;
    
    
    self.arrCurrentSeason = [self.dictSeasonsList objectForKey:[self.arrSeasons objectAtIndex:indexPath.section]];
    
    Location *currLocation = [self.arrCurrentSeason objectAtIndex:indexPath.row];
    
    cell.spotNameLbl.text = currLocation.name;
    
    
    return cell;
    
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [self.arrSeasons objectAtIndex:section];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    
    cellView.tag = section;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, tableView.frame.size.width - 50, cellView.frame.size.height)];
//    headerLabel.tag = section;
    cellView.userInteractionEnabled = YES;
    cellView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.9];
    headerLabel.text = [self.arrSeasons objectAtIndex:section];
    [headerLabel setTextAlignment:NSTextAlignmentLeft];
//    headerLabel.frame = CGRectMake(25, 0, tableView.tableHeaderView.frame.size.width - 50, tableView.tableHeaderView.frame.size.height);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerClicked:)];
    tapGesture.cancelsTouchesInView = NO;
    [cellView addGestureRecognizer:tapGesture];
    [cellView addSubview:headerLabel];
    
    return cellView;
}

- (void)headerClicked:(UITapGestureRecognizer *)sender
{
    UIView *view = (UIView *)sender.view;
    self.isShowingList = [[self.dictShowingSeciton objectForKey:[self.arrSeasons objectAtIndex:view.tag]] boolValue];
    
    if (!self.isShowingList) {
        [self.dictShowingSeciton setObject:@YES forKey:[self.arrSeasons objectAtIndex:view.tag]];
        self.arrCurrentSeason = [self.dictSeasonsList objectForKey:[self.arrSeasons objectAtIndex:view.tag]];
        NSMutableArray *arrSectionsIndexPaths = [[NSMutableArray alloc] initWithCapacity:10];

        for (NSInteger i=0; i<[self.arrCurrentSeason count]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:view.tag];
            [arrSectionsIndexPaths addObject:indexPath];
        }
        [self.tableView insertRowsAtIndexPaths:arrSectionsIndexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
    else{
        [self.dictShowingSeciton setObject:@NO forKey:[self.arrSeasons objectAtIndex:view.tag]];
        self.arrCurrentSeason = [self.dictSeasonsList objectForKey:[self.arrSeasons objectAtIndex:view.tag]];
        NSMutableArray *arrSectionsIndexPaths = [[NSMutableArray alloc] initWithCapacity:10];
        
        for (NSInteger i=0; i<[self.arrCurrentSeason count]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:view.tag];
            [arrSectionsIndexPaths addObject:indexPath];
        }
        [self.tableView deleteRowsAtIndexPaths:arrSectionsIndexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    if ([segue.identifier isEqualToString:@"toSpotDetail"]) {
        SpotDetail *view = segue.destinationViewController;
        
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        self.arrCurrentSeason = [self.dictSeasonsList objectForKey:[self.arrSeasons objectAtIndex:indexPath.section]];
        view.location = [self.arrCurrentSeason objectAtIndex:indexPath.row];
    }
//    SpotDetail *detailViewController = (SpotDetail *)segue.destinationViewController;
//    
//    // Get the index of the selected cell
//    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
//    
//    // Set the title of the destination view controller
//    // detailViewController.navigationItem.title = self.data[indexPath.row];
//    NSString* string = self.data[indexPath.row];
//    
//    
//    detailViewController.navigationItem.title = string;
    
}


#pragma  mark - LocationSingletonDelegate

-(void) locationSingletonDelegate: (LocationSingleton *) locationDelegate didUpdateLocationWhitLocation:(CLLocation *)location {
    NSLog(@"New location updated %@", [location description]);
}



@end
