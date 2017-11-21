//
//  CalenderViewController.m
//  AgendaApp
//
//  Created by Daniel Vasquez Fernandez on 11/15/17.
//  Copyright © 2017 Daniel Vasquez Fernandez. All rights reserved.
//

#import "CalenderViewController.h"



@interface CalenderViewController ()

@property(nonatomic, weak) CKCalendarView* calendar;
@property(nonatomic, strong) NSDateFormatter* dateFormatter;
@property(nonatomic, strong) NSDate* minimumDate;


@end

@implementation CalenderViewController

-(id)init{
    self = [super init];
    if(self){
        CKCalendarView* calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
        self.calendar = calendar;
        calendar.delegate = self;
        
        
        self.dateFormatter = [NSDateFormatter new];
        [self.dateFormatter setDateFormat:@"MM-dd-yyyy"];
        self.minimumDate = [self.dateFormatter dateFromString:@"01/01/2015"];
        
        calendar.onlyShowCurrentMonth = NO;
        calendar.adaptHeightToNumberOfWeeksInMonth = YES;
        
        [self.view addSubview:calendar];
        
        [calendar makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.centerX);
            make.centerY.equalTo(self.view.centerY);
            make.height.equalTo(400);
            make.width.equalTo(300);
        }];
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date{
    NSString* tempString = [self.dateFormatter stringFromDate:date];
    NSLog(@"%@", tempString);
    [self.delegate selectedDateFromView:self date:date];
    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
