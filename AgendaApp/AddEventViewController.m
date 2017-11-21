//
//  AddEventViewController.m
//  AgendaApp
//
//  Created by Daniel Vasquez Fernandez on 11/14/17.
//  Copyright © 2017 Daniel Vasquez Fernandez. All rights reserved.
//

#import "AddEventViewController.h"
#import "CalenderViewController.h"
#import "EventModel.h"
#import "EventObject.h"
#import "EventBC.h"
@import UserNotifications;

@interface AddEventViewController ()

@property(strong, nonatomic)UITextField* txtEventName;
@property(strong, nonatomic)UITextView* txvEventDescription;
@property(strong, nonatomic)UIButton* btnEventDate;
@property(strong, nonatomic)UIDatePicker* dtpEventTime;
@property(strong, nonatomic)UIPickerView* pickerView;

@property(strong, nonatomic)NSDate* eventDate;

@property(strong, nonatomic)NSDateFormatter* dateFormatter;
@property(strong, nonatomic)NSDateFormatter* timeFormatter;

@property(strong, nonatomic)UIScrollView *scrollView;
@property(strong, nonatomic)UIView *contentView;

@property(strong, nonatomic)NSArray *arrayOfTime;

@end

static NSInteger kKeyboardOffset = 250;

@implementation AddEventViewController{
    NSInteger reminder;
}

#pragma mark - Lazy inits

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
        _btnEventDate = [UIButton new];
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
        _dtpEventTime.datePickerMode = UIDatePickerModeTime;
        
    }
    return _dtpEventTime;
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
        [_timeFormatter setDateFormat:@"HH:mm"];
    }
    return _timeFormatter;
}

-(UIPickerView *)pickerView{
    if(!_pickerView){
        _pickerView = [UIPickerView new];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

-(NSArray *)arrayOfTime{
    if(!_arrayOfTime){
        _arrayOfTime = @[@"0", @"5", @"10", @"15"];
    }
    return _arrayOfTime;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor redColor];
}


-(void)loadView{
    [super loadView];
    self.title = @"Create Event";
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.btnEventDate setTitle:@"Select Date" forState:UIControlStateNormal];
    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [self setupConstraints];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveData)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}


-(void)dismissKeyboard {
    [self.view endEditing:YES];
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

#pragma mark - setupConstraints

-(void)setupConstraints{
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.self.contentView = [UIView new];
    [self.scrollView addSubview:self.self.contentView];
    
    [self.self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    UILabel* lblEventName = [UILabel new];
    lblEventName.text = @"Event Name";
    UILabel* lblEventDescription = [UILabel new];
    lblEventDescription.text = @"Event Description";
    UILabel* lblEventDate = [UILabel new];
    lblEventDate.text = @"Event Date";
    UILabel* lblEventTime = [UILabel new];
    lblEventTime.text = @"Event Time";
    UILabel* lblEventReminder = [UILabel new];
    lblEventReminder.text = @"Reminder Time";
    
    [self.contentView addSubview:lblEventName];
    [self.contentView addSubview:lblEventDescription];
    [self.contentView addSubview:lblEventDate];
    [self.contentView addSubview:lblEventTime];
    [self.contentView addSubview:lblEventReminder];
    [self.contentView addSubview:self.btnEventDate];
    [self.contentView addSubview:self.txtEventName];
    [self.contentView addSubview:self.txvEventDescription];
    [self.contentView addSubview:self.dtpEventTime];
    [self.contentView addSubview:self.pickerView];
    

    
    [lblEventName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(20);
        make.left.equalTo(self.contentView.left).offset(20);
        make.centerX.equalTo(self.contentView.centerX);
        make.right.equalTo(self.contentView.right).offset(-20);
    }];
    
    [self.txtEventName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblEventName.bottom).offset(20);
        make.left.equalTo(self.contentView.left).offset(20);
        make.centerX.equalTo(self.contentView.centerX);
        make.right.equalTo(self.contentView.right).offset(-20);
        make.height.equalTo(35);
    }];
    
    [lblEventDescription makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtEventName.bottom).offset(20);
        make.left.equalTo(self.contentView.left).offset(20);
        make.centerX.equalTo(self.contentView.centerX);
        make.right.equalTo(self.contentView.right).offset(-20);
    }];
    
    [self.txvEventDescription makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblEventDescription.bottom).offset(20);
        make.left.equalTo(self.contentView.left).offset(20);
        make.centerX.equalTo(self.contentView.centerX);
        make.right.equalTo(self.contentView.right).offset(-20);
        make.height.equalTo(50);
    }];
    
    [lblEventDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txvEventDescription.bottom).offset(20);
        make.left.equalTo(self.contentView.left).offset(20);
        make.centerX.equalTo(self.contentView.centerX);
        make.right.equalTo(self.contentView.right).offset(-20);
    }];
    
    [self.btnEventDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblEventDate.bottom).offset(20);
        make.left.equalTo(self.contentView.left).offset(20);
        make.centerX.equalTo(self.contentView.centerX);
        make.right.equalTo(self.contentView.right).offset(-20);
    }];
    
    [lblEventTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnEventDate.bottom).offset(20);
        make.left.equalTo(self.contentView.left).offset(20);
        make.centerX.equalTo(self.contentView.centerX);
        make.right.equalTo(self.contentView.right).offset(-20);
        
    }];
    [self.dtpEventTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblEventTime.bottom).offset(20);
        make.width.equalTo(250);
        make.centerX.equalTo(self.contentView.centerX);
        
    }];
    
    [lblEventReminder makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dtpEventTime.bottom).offset(20);
        make.left.equalTo(self.contentView.left).offset(20);
        make.centerX.equalTo(self.contentView.centerX);
        make.right.equalTo(self.contentView.right).offset(-20);
    }];
    
    [self.pickerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblEventReminder.bottom).offset(10);
        make.left.equalTo(self.contentView.left).offset(20);
        make.width.equalTo(100);
        make.height.equalTo(200);
    }];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pickerView.bottom).offset(20);
    }];
}

#pragma mark - UIPickerView datasource and delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.arrayOfTime.count;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [NSString stringWithFormat:@"%@", self.arrayOfTime[row]];
}

#pragma mark - handle save data

-(void)saveData{

    EventModel* event = [[EventModel alloc] init];
    event.eventName = self.txtEventName.text;
    event.eventDescription = self.txvEventDescription.text;
    event.eventDate = [self.dateFormatter stringFromDate:self.eventDate];
    event.eventTime = [self.timeFormatter stringFromDate:self.dtpEventTime.date];
    event.eventReminder = [[self.pickerView delegate] pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:0] forComponent:0];
    
    [self handleEventScheduleWithEvent:event];
    
    
    EventBC* eventBC = [[EventBC alloc] init];
    [eventBC addEvent:event Completion:^(id object) {
        [self.navigationController popViewControllerAnimated:YES];
    } withError:^(NSString *message) {
        [self.btnEventDate setTitle:message forState:UIControlStateNormal];
    }];
    
}


-(void)selectedDateFromView:(CalenderViewController *)vController date:(NSDate *)selectedDate{
    self.eventDate = selectedDate;
    [self.btnEventDate setTitle:[self.dateFormatter stringFromDate:selectedDate] forState:UIControlStateNormal];
}

-(void)navigateToCalendar{
    CalenderViewController* calenderViewController = [[CalenderViewController alloc] init];
    calenderViewController.delegate = self;
    [self.navigationController pushViewController:calenderViewController animated:YES];
}

#pragma mark - handle Event Scheduling

-(void)handleEventScheduleWithEvent:(EventModel*)event{
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = self.txtEventName.text;
    content.body = self.txvEventDescription.text;
    content.sound = [UNNotificationSound defaultSound];
    
    NSDateFormatter *dateMerger = [NSDateFormatter new];
    [dateMerger setDateFormat:@"MM-dd-yyyy HH:mm"];
    NSDate *eventDate = [dateMerger dateFromString:[NSString stringWithFormat:@"%@ %@", event.eventDate, event.eventTime]];
    
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSCalendarUnitYear +
                                    NSCalendarUnitMonth + NSCalendarUnitDay +
                                    NSCalendarUnitHour + NSCalendarUnitMinute
                                    fromDate:eventDate];
    [components setTimeZone:[NSTimeZone defaultTimeZone]];
    components.minute = components.minute - [event.eventReminder integerValue];
    NSLog(@"%lu", components.minute);
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:self.txtEventName.text content:content trigger:trigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error in creating notification request");
        }else{
            NSLog(@"Success");
        }
    }];

}


@end
