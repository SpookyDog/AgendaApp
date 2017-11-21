//
//  EventDetailViewController.h
//  AgendaApp
//
//  Created by Daniel Vasquez Fernandez on 11/16/17.
//  Copyright © 2017 Daniel Vasquez Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalenderViewController.h"
#import "EventModel.h"
#import "EventObject.h"

@interface EventDetailViewController : UIViewController <CalenderViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property(strong, nonatomic)EventObject *eventObj;

@end
