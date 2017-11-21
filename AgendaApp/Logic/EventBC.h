//
//  EventBC.h
//  AgendaApp
//
//  Created by Daniel Vasquez Fernandez on 11/13/17.
//  Copyright © 2017 Daniel Vasquez Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventModel.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "EventDALC.h"
#import "EventObject.h"

@interface EventBC : NSObject
-(NSArray*)listOrderedEvents;
-(void)addEvent:(EventModel*)objEvent Completion:(void (^)(id))completionBlock withError:(void (^)(NSString*))errorBlock;
-(void)editEvent:(EventObject*)objEvent Completion:(void (^)(EventObject*))completionBlock withError:(void (^)(NSString*))errorBlock;
@end
