//
//  ViewController.h
//  ReminderDemo
//
//  Created by Volansys_MACMINI on 16/06/16.
//  Copyright © 2016 Volansys_MACMINI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *eventFired;
- (IBAction)eventTapped:(id)sender;

- (IBAction)eventCreated:(id)sender;
- (IBAction)startDate:(id)sender;

- (IBAction)endDate:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *dateValue;

@end

