//
//  CalenderViewController.h
//  AgendaApp
//
//  Created by Daniel Vasquez Fernandez on 11/15/17.
//  Copyright © 2017 Daniel Vasquez Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CKCalendarView.h>
@protocol CalenderViewControllerDelegate;

@interface CalenderViewController : UIViewController <CKCalendarDelegate>

@property(nonatomic, strong) id<CalenderViewControllerDelegate> delegate;

@end

@protocol CalenderViewControllerDelegate <NSObject>

-(void)selectedDateFromView:(CalenderViewController*)vController date:(NSDate*)selectedDate;

@end
