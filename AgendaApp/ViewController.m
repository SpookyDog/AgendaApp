//
//  ViewController.m
//  AgendaApp
//
//  Created by Daniel Vasquez Fernandez on 11/13/17.
//  Copyright © 2017 Daniel Vasquez Fernandez. All rights reserved.
//

#import "ViewController.h"
#import "EventBC.h"
#import "EventTableViewCell.h"
#import "AddEventViewController.h"
#import "EventDetailViewController.h"

@interface ViewController ()

@property(strong, nonatomic)NSArray* arrayOfEvents;
@property(strong, nonatomic)UITableView* tableView;

@end

static NSString* kCellIdentifier = @"CellIdentifier";

@implementation ViewController

-(UITableView*)tableView{
    if(!_tableView) {
        //_tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView = [UITableView new];
    }
    return _tableView;
}

-(NSArray *)arrayOfEvents{
    if(!_arrayOfEvents){
        EventBC* eventBC = [EventBC new];
        _arrayOfEvents = [eventBC listOrderedEvents];
    }
    return _arrayOfEvents;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    EventBC* bc = [EventBC new];
    self.arrayOfEvents = [bc listOrderedEvents];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(navigateToAddEventView)];
    
    self.title = @"List";
    
    [self.view addSubview:self.tableView];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    if(self.view.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable){
        [self registerForPreviewingWithDelegate:self sourceView:self.tableView];
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfEvents.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EventTableViewCell* cell = (EventTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if(cell == nil){
        cell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    cell.objDM = self.arrayOfEvents[indexPath.row];
    [cell setupData];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EventDetailViewController *detailVC = [[EventDetailViewController alloc] init];
    detailVC.eventObj = self.arrayOfEvents[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)navigateToAddEventView{
    AddEventViewController* addEventVC = [AddEventViewController new];
    [self.navigationController pushViewController:addEventVC animated:YES];
}

-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    [self.navigationController pushViewController:viewControllerToCommit animated:TRUE];
}

-(UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    EventTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    EventDetailViewController *detailVC = [[EventDetailViewController alloc] init];
    detailVC.eventObj = cell.objDM;
    
    previewingContext.sourceRect = cell.frame;
    
    return detailVC;
}

@end
