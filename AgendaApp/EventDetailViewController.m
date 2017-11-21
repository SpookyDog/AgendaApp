//
//  EventDetailViewController.m
//  AgendaApp
//
//  Created by Daniel Vasquez Fernandez on 11/16/17.
//  Copyright © 2017 Daniel Vasquez Fernandez. All rights reserved.
//

#import "EventDetailViewController.h"
#import "EventBC.h"
#import <CoreData/CoreData.h>
@import UserNotifications;

@interface EventDetailViewController ()

@property(strong, nonatomic)UITextField* txtEventName;
@property(strong, nonatomic)UITextView* txvEventDescription;
@property(strong, nonatomic)UIButton* btnEventDate;
@property(strong, nonatomic)UIDatePicker* dtpEventTime;
@property(strong, nonatomic)UIPickerView* pickerView;

@property(strong, nonatomic)NSDate* eventDate;

@property(strong, nonatomic)NSDateFormatter* dateFormatter;
@property(strong, nonatomic)NSDateFormatter* timeFormatter;
@property(strong, nonatomic)NSString *oldEventName;

@property(strong, nonatomic)UIScrollView *scrollView;


@end

static NSInteger kKeyboardOffset = 260;

@implementation EventDetailViewController

#pragma mark - lazy inits

-(UITextField *)txtEventName{
    if(!_txtEventName){
        _txtEventName = [UITextField new];
        _txtEventName.backgroundColor = [UIColor whiteColor];
    }
    return _txtEventName;
}

-(UITextView *)txvEventDescription{
    if(!_txvEventDescription){
        _txvEventDescription = [UITextView new];
    }
    return _txvEventDescription;
}

-(UIButton *)btnEventDate{
    if(!_btnEventDate){
        _btnEventDate = [[UIButton alloc] init];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigateToCalendar)];
        [_btnEventDate addGestureRecognizer:tap];
        _btnEventDate.backgroundColor = [UIColor blackColor];
        _btnEventDate.titleLabel.textColor = [UIColor whiteColor];
    }
    return _btnEventDate;
}

-(UIDatePicker *)dtpEventTime{
    if(!_dtpEventTime){
        _dtpEventTime = [UIDatePicker new];
        [_dtpEventTime setDatePickerMode:UIDatePickerModeTime];
        
    }
    return _dtpEventTime;
}

-(UIPickerView *)pickerView{
    if(!_pickerView){
        _pickerView = [UIPickerView new];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor lightGrayColor];
    }
    return _pickerView;
}

-(NSDate *)eventDate{
    if(!_eventDate){
        _eventDate = [NSDate new];
    }
    return _eventDate;
}

-(NSDateFormatter *)dateFormatter{
    if(!_dateFormatter){
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setDateFormat:@"MM-dd-yyyy"];
    }
    return _dateFormatter;
}

-(NSDateFormatter *)timeFormatter{
    if(!_timeFormatter){
        _timeFormatter = [NSDateFormatter new];
        [_dateFormatter setDateFormat:@"HH:mm"];
    }
    return _timeFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)loadView{
    [super loadView];
    
    self.title = @"Event Details";
    [self.btnEventDate setTitle:@"Select Date" forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.txtEventName.text = self.eventObj.eventName;
    self.txvEventDescription.text = self.eventObj.eventDescription;
    [self.btnEventDate setTitle:[self.dateFormatter stringFromDate:self.eventObj.eventDate] forState:UIControlStateNormal];
    [self.dtpEventTime setDate:self.eventObj.eventDate];
    self.eventDate = self.eventObj.eventDate;
    
    
    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [self setupConstraints];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveData)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillAppear{
    [self.scrollView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom).offset(-kKeyboardOffset);
    }];
}

-(void)keyboardWillHide{
    [self.scrollView remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)dismissKeyboard{
    [self.view endEditing:YES];
}

#pragma mark - setupConstraints

-(void)setupConstraints{
    self.scrollView = [UIScrollView new];
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *contentView = [UIView new];
    [self.scrollView addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView.width);
    }];
    
    UILabel* lblEventName = [UILabel new];
    [lblEventName setText:@"Event Name"];
    [contentView addSubview:lblEventName];
    
    UILabel *lblEventDescription = [UILabel new];
    [lblEventDescription setText:@"Event Description"];
    [contentView addSubview:lblEventDescription];
    
    UILabel *lblEventDate = [UILabel new];
    [lblEventDate setText:@"Event Date"];
    [contentView addSubview:lblEventDate];
    
    UILabel *lblEventTime = [UILabel new];
    [lblEventTime setText:@"Event Time"];
    [contentView addSubview:lblEventTime];
    
    UILabel *lblEventReminder = [UILabel new];
    [lblEventReminder setText:@"Event Reminder"];
    [contentView addSubview:lblEventReminder];
    
    [contentView addSubview:self.txtEventName];
    [contentView addSubview:self.txvEventDescription];
    [contentView addSubview:self.btnEventDate];
    [contentView addSubview:self.dtpEventTime];
    [contentView addSubview:self.pickerView];
    
    [lblEventName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.top).offset(20);
        make.left.equalTo(contentView.left).offset(10);
        make.width.equalTo(125);
        make.height.equalTo(55);
    }];
    
    
    [self.txtEventName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblEventName.bottom).offset(10);
        make.left.equalTo(contentView.left).offset(10);
        make.right.equalTo(contentView.right).offset(-10);
        make.height.equalTo(35);
    }];
    
    
    [lblEventDescription makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtEventName.bottom).offset(10);
        make.left.equalTo(contentView.left).offset(10);
        make.width.equalTo(125);
        make.height.equalTo(55);
    }];
    
    
    [self.txvEventDescription makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblEventDescription.bottom).offset(10);
        make.left.equalTo(contentView.left).offset(10);
        make.right.equalTo(contentView.right).offset(-10);
        make.height.equalTo(100);
    }];
    
    
    [lblEventDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txvEventDescription.bottom).offset(10);
        make.left.equalTo(contentView.left).offset(10);
        make.right.equalTo(contentView.right).offset(-10);
        make.height.equalTo(55);
    }];
    
    
    [self.btnEventDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblEventDate.bottom).offset(10);
        make.centerX.equalTo(contentView.centerX);
        make.width.equalTo(150);
        make.height.equalTo(55);
    }];
    
    
    [lblEventTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnEventDate.bottom).offset(10);
        make.left.equalTo(contentView.left).offset(10);
        make.width.equalTo(125);
        make.height.equalTo(55);
    }];
    
    
    [self.dtpEventTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblEventTime.bottom).offset(10);
        make.centerX.equalTo(contentView.centerX);
        make.width.equalTo(250);
        make.height.equalTo(200);
    }];
    
    
    [lblEventReminder makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dtpEventTime.bottom).offset(10);
        make.left.equalTo(contentView.left).offset(10);
        make.width.equalTo(125);
        make.height.equalTo(55);
    }];
    
    
    [self.pickerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblEventReminder.bottom).offset(10);
        make.left.equalTo(contentView.left).offset(10);
        make.width.equalTo(125);
        make.height.equalTo(125);
    }];
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pickerView).offset(-10);
    }];
}

#pragma mark - UIPickerView Datasource and Delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 4;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* columnView = [UILabel new];
    long reminderTime = row * 5;
    columnView.text = [NSString stringWithFormat:@"%lu",reminderTime];
    
    return columnView;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSInteger timer = row * 5;
    return [NSString stringWithFormat:@"%ld", timer];
}

#pragma mark - Save Data

-(void)saveData{
    self.eventObj.eventName = self.txtEventName.text;
    self.eventObj.eventDescription = self.txvEventDescription.text;
    NSDateFormatter *dateMerger = [NSDateFormatter new];
    [dateMerger setDateFormat:@"MM-dd-yyyy"];
    NSString *tempDate = [dateMerger stringFromDate:self.eventDate];
    
    [dateMerger setDateFormat:@"HH:mm"];
    NSString *tempTime = [dateMerger stringFromDate:self.dtpEventTime.date];
    
    [dateMerger setDateFormat:@"MM-dd-yyyy HH:mm"];
    self.eventObj.eventDate = [dateMerger dateFromString:[NSString stringWithFormat:@"%@ %@", tempDate, tempTime]];
    self.eventObj.eventReminder = [[self.pickerView delegate] pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:0] forComponent:0];
    
    [self removeNotification];
    [self handleEventScheduleWithEvent:self.eventObj];
    
    
    EventBC *eventBC = [EventBC new];
    [eventBC editEvent:self.eventObj Completion:^(EventObject *event) {
        [self.navigationController popViewControllerAnimated:YES];
    } withError:^(NSString *message) {
        NSLog(@"%@", message);
    }];
}

#pragma mark - Handle schedule event

-(void)removeNotification{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:@[self.eventObj.eventName]];
}

-(void)handleEventScheduleWithEvent:(EventObject*)event{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = self.txtEventName.text;
    content.body = self.txvEventDescription.text;
    content.sound = [UNNotificationSound defaultSound];
    
    NSDate *eventDate = event.eventDate;
    
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSCalendarUnitYear +
                                    NSCalendarUnitMonth + NSCalendarUnitDay +
                                    NSCalendarUnitHour + NSCalendarUnitMinute
                                    fromDate:eventDate];
    [components setTimeZone:[NSTimeZone defaultTimeZone]];
    components.minute = components.minute - [event.eventReminder integerValue];
    NSLog(@"%lu", components.minute);
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:event.eventName content:content trigger:trigger];
    
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error in creating notification request");
        }else{
            NSLog(@"Success");
        }
    }];
    
}

#pragma mark - Navigate to Calendar and Delegate

-(void)navigateToCalendar{
    CalenderViewController* calendarVC = [[CalenderViewController alloc] init];
    calendarVC.delegate = self;
    [self.navigationController pushViewController:calendarVC animated:YES];
}

-(void)selectedDateFromView:(CalenderViewController *)vController date:(NSDate *)selectedDate{
    [self.btnEventDate setTitle:[self.dateFormatter stringFromDate:selectedDate] forState:UIControlStateNormal];
    self.eventDate = selectedDate;
}

@end
