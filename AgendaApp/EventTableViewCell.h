//
//  EventTableViewCell.h
//  AgendaApp
//
//  Created by Daniel Vasquez Fernandez on 11/13/17.
//  Copyright © 2017 Daniel Vasquez Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EventObject.h"

@interface EventTableViewCell : UITableViewCell

@property(strong, nonatomic)UILabel* lblEventName;
@property(strong, nonatomic)UILabel* lblDate;
@property(strong, nonatomic)EventObject* objDM;

-(void)setupData;

@end
