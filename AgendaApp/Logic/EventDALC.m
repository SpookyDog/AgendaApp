//
//  EventDALC.m
//  AgendaApp
//
//  Created by Daniel Vasquez Fernandez on 11/13/17.
//  Copyright © 2017 Daniel Vasquez Fernandez. All rights reserved.
//

#import "EventDALC.h"

@implementation EventDALC

-(NSArray*)listOrderedEvents:(NSManagedObjectContext*)context{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"eventDate" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    return [context executeFetchRequest:fetchRequest error:nil];
}
-(id)addEvent:(EventModel*)objEvent withContext:(NSManagedObjectContext*)context{
    NSManagedObject* objDM = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
    
    NSString* strTemp = [NSString stringWithFormat:@"%@ %@", objEvent.eventDate, objEvent.eventTime];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm"];
    NSDate* eventDate = [dateFormatter dateFromString:strTemp];
    
    [objDM setValue:objEvent.eventName forKey:@"eventName"];
    [objDM setValue:objEvent.eventDescription forKey:@"eventDescription"];
    [objDM setValue:eventDate forKey:@"eventDate"];
    [objDM setValue:objEvent.eventReminder forKey:@"eventReminder"];
    
    
    
    return objDM;
}


-(EventObject*)editEventObject:(EventObject*)objEvent withContext:(NSManagedObjectContext*)context{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventName == %@", objEvent.eventName];
    [fetchRequest setPredicate:predicate];
    
    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    
    EventObject *objDM = [array objectAtIndex:0];
    
    objDM.eventName = objEvent.eventName;
    objDM.eventDescription = objEvent.eventDescription;
    objDM.eventDate = objEvent.eventDate;
    objDM.eventReminder = objEvent.eventReminder;
    
    return objDM;
}

@end
