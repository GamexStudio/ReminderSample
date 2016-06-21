//
//  ViewController.m
//  ReminderDemo
//
//  Created by Volansys_MACMINI on 16/06/16.
//  Copyright © 2016 Volansys_MACMINI. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSString *saveEventId;
@property (nonatomic, strong) NSDateComponents *dateComponentsStart;
@property (nonatomic, strong) NSDateComponents *dateComponentsEnd;

@property (nonatomic, strong) UIDatePicker *startDatePicker;

@property (nonatomic, strong) UIDatePicker *endDatePicker;
@property (nonatomic, strong) UIBarButtonItem *doneBtn;

@property (nonatomic, strong) NSArray *arrRepeatOptions;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dateComponentsStart = [[NSDateComponents alloc] init];
    _dateComponentsStart.day = 17;
    _dateComponentsStart.month = 6;
    _dateComponentsStart.year = 2016;
    _dateComponentsStart.hour = 21;
    _dateComponentsStart.minute = 40;
    _dateComponentsStart.second = 0;
    
    _dateComponentsEnd = [[NSDateComponents alloc] init];
    _dateComponentsEnd.day = 18;
    _dateComponentsEnd.month = 6;
    _dateComponentsEnd.year = 2016;
    _dateComponentsEnd.hour = 22;
    _dateComponentsEnd.minute = 10;
    _dateComponentsEnd.second = 0;
    

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)eventTapped:(id)sender {
    EKEventStore *store = [EKEventStore new];
    [_startDatePicker removeFromSuperview];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
        if (!granted) {
            return ;
        }else{
            /* The event starts after 5 minutes from selected Start Date */
            NSDate *startDate = [[NSDate date] dateByAddingTimeInterval:300];
            
            /* For the sake of our need we have taken a static date */
            NSString *dateString = @"2016-08-30";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // this is imporant - we set our input date format to match our input string
            // if format doesn't match you'll get nil from your string, so be careful
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:dateString];
            NSDate *endDate = _startDatePicker.date;
            /* Created the object of EKAlarm */
            EKEvent *eventWithAlarm = [EKEvent eventWithEventStore:store];
            
            eventWithAlarm.calendar = [store defaultCalendarForNewEvents];
            /*Here start date is the date on which the event should occur*/
            eventWithAlarm.startDate = startDate;
            /*And Event's end date is at what time the event should close.As in the event should be of 5 minutes or 10 minutes.According to our need we have to set the time interval after startDate*/
            eventWithAlarm.endDate = [startDate dateByAddingTimeInterval:300];
            
            /* The alarm goes off two seconds before the event happens */
            EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:-2.0f];
            eventWithAlarm.title = @"Event with Alarm";
            [eventWithAlarm addAlarm:alarm];
            
            
            // Specify the recurrence frequency and interval values based on the respective selected option.
            EKRecurrenceFrequency frequency;
            NSInteger interval;
            //We can set the switch Case according to our need. for example we can use arrRepeatOptions mentioned in viewDidload method
            switch (1) {
                case 1:
                    frequency = EKRecurrenceFrequencyDaily;
                    interval = 1;
                    break;
                case 2:
                    frequency = EKRecurrenceFrequencyWeekly;
                    interval = 1;
                    break;
                case 3:
                    frequency = EKRecurrenceFrequencyMonthly;
                    interval = 1;
                    break;
                case 4:
                    frequency = EKRecurrenceFrequencyYearly;
                    interval = 1;
                    break;
                default:
                    interval = 0;
                    frequency = EKRecurrenceFrequencyDaily;
                    break;
            }
            
            // Create a rule and assign it to the reminder object if the interval is greater than 0.
            if (interval > 0) {
                /*Here recurrence end date should be the event's end date..Like our event is started on 20th of June and we need this event to occure till July then we need to set end date acoording to our need*/
                EKRecurrenceEnd *recurrenceEnd = [EKRecurrenceEnd recurrenceEndWithEndDate:endDate];
                EKRecurrenceRule *rule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:frequency interval:interval end:recurrenceEnd];
                eventWithAlarm.recurrenceRules = @[rule];
            }
            else{
                eventWithAlarm.recurrenceRules = nil;
            }
        
            [store saveEvent:eventWithAlarm span:EKSpanFutureEvents commit:YES error:&error];
            if (error == nil) {
                NSLog(@"Event created");
            }else{
                NSLog(@"Error description --- %@",error.localizedDescription);
            }
        }
    
    }];
}

- (IBAction)eventCreated:(id)sender {
    NSLog(@"dfgsbhs");
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
        if (!granted) {
            return ;
        }else{
            EKEvent *event = [EKEvent eventWithEventStore:store];
            event.title = @"First Event";
            event.calendar = [store defaultCalendarForNewEvents];
            event.startDate = [NSDate date];
            event.endDate = [NSDate date];
            NSTimeInterval alarmOffset = -1*60*60;//1 hour
            EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:alarmOffset];
            [event addAlarm:alarm];
            NSError *error = nil;
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
            if (error == nil) {
                NSLog(@"Event created");
            }
        }
        
    }];
    
}


- (IBAction)startDate:(id)sender {
    _startDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 350.0, self.view.frame.size.width, 150)];
    _startDatePicker.datePickerMode = UIDatePickerModeDate;
    _startDatePicker.hidden = NO;
    _startDatePicker.date = [NSDate date];
    [_startDatePicker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_startDatePicker];
    
    _doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
    
}

- (IBAction)endDate:(id)sender {
}

-(void)save:(id)sender
{
    
}

-(void)LabelTitle:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:_startDatePicker.date]];
    //assign text to label
    _dateValue.text=str;
}
@end
