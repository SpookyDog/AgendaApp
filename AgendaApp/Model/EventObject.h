//
//  EventObject.h
//  AgendaApp
//
//  Created by Daniel Vasquez Fernandez on 11/17/17.
//  Copyright © 2017 Daniel Vasquez Fernandez. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface EventObject : NSManagedObject

@property(strong, nonatomic)NSString *eventName;
@property(strong, nonatomic)NSString *eventDescription;
@property(strong, nonatomic)NSDate *eventDate;
@property(strong, nonatomic)NSString *eventReminder;

@end
