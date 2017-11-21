//
//  EventBC.m
//  AgendaApp
//
//  Created by Daniel Vasquez Fernandez on 11/13/17.
//  Copyright © 2017 Daniel Vasquez Fernandez. All rights reserved.
//

#import "EventBC.h"
#import "EventObject.h"

typedef void (^ correctBlock)(id);

@implementation EventBC

-(NSArray*)listOrderedEvents{
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = delegate.persistentContainer.viewContext;
    EventDALC* eventDALC = [[EventDALC alloc] init];
    
    return [eventDALC listOrderedEvents:context];
}

-(void)addEvent:(EventModel*)objEvent Completion:(correctBlock)completionBlock withError:(void (^)(NSString*))errorBlock{
    
    if(objEvent.eventName == nil || objEvent.eventName.length == 0){
        errorBlock(@"Please enter event name");
        return;
    }
    if(objEvent.eventDescription == nil || objEvent.eventDescription.length == 0){
        errorBlock(@"Please enter event description");
        return;
    }
    if(objEvent.eventDate == nil || objEvent.eventDate.length == 0){
        errorBlock(@"Please enter event date");
        return;
    }
    if(objEvent.eventTime == nil || objEvent.eventTime.length == 0){
        errorBlock(@"Please enter event time");
        return;
    }
    if(objEvent.eventReminder == nil || objEvent.eventReminder.length == 0){
        errorBlock(@"Please enter reminder time");
        return;
    }
    
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = delegate.persistentContainer.viewContext;

    EventDALC* eventDALC = [[EventDALC alloc] init];
    
    id objDM = [eventDALC addEvent:objEvent withContext:context];
    
    [delegate saveContext];
    
    completionBlock(objDM);
    
}


-(void)editEvent:(EventObject*)objEvent Completion:(void (^)(EventObject*))completionBlock withError:(void (^)(NSString*))errorBlock{
    if(objEvent.eventName == nil || objEvent.eventName.length == 0){
        errorBlock(@"Please enter event name");
        return;
    }
    if(objEvent.eventDescription == nil || objEvent.eventDescription.length == 0){
        errorBlock(@"Please enter event description");
        return;
    }
    if(objEvent.eventDate == nil){
        errorBlock(@"Please enter event date");
        return;
    }
    
    if(objEvent.eventReminder == nil || objEvent.eventReminder.length == 0){
        errorBlock(@"Please enter reminder time");
        return;
    }
    
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = delegate.persistentContainer.viewContext;
    
    EventDALC* eventDALC = [[EventDALC alloc] init];
    
    id objDM = [eventDALC editEventObject:objEvent withContext:context];
    
    [delegate saveContext];
    
    completionBlock(objDM);
}
@end
