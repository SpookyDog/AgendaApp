//
//  EventModel.h
//  AgendaApp
//
//  Created by Daniel Vasquez Fernandez on 11/13/17.
//  Copyright © 2017 Daniel Vasquez Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventModel : NSObject

@property(strong, nonatomic)NSString* eventName;
@property(strong, nonatomic)NSString* eventDescription;
@property(strong, nonatomic)NSString* eventDate;
@property(strong, nonatomic)NSString* eventTime;
@property(nonatomic)NSString* eventReminder;

@end
