//
//  EventDALC.h
//  AgendaApp
//
//  Created by Daniel Vasquez Fernandez on 11/13/17.
//  Copyright © 2017 Daniel Vasquez Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EventModel.h"
#import "EventObject.h"


@interface EventDALC : NSObject

-(NSArray*)listOrderedEvents:(NSManagedObjectContext*)context;
-(id)addEvent:(EventModel*)objEvent withContext:(NSManagedObjectContext*)context;
-(NSManagedObject*)editEventObject:(EventObject*)objEvent withContext:(NSManagedObjectContext*)context;
//+(id)sharedManager;
@end
