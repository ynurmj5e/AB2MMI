//
//  AppDelegate.m
//  AB2MMI
//
//  Created by 小田隆宏 on 2014/04/13.
//  Copyright (c) 2014年 小田隆宏. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    adBook = [ABAddressBook addressBook];
    groups = [adBook groups];
    gNames = [NSMutableArray arrayWithCapacity:0];
    for (ABGroup * group in groups) {
        [gNames addObject:[group valueForProperty:kABGroupNameProperty]];
    }
    [self.cmbBox addItemsWithObjectValues:gNames];
}

- (IBAction)Show_Push:(id)sender {
    ABGroup *group = [groups objectAtIndex:[self.cmbBox indexOfSelectedItem]];
    NSArray *members = [group members];
    NSMutableString *text = [NSMutableString stringWithCapacity:0];
    for (ABPerson *person in members) {
        [text appendString:@"BEGIN:VCARD\n"];
        [text appendString:@"VERSION:3.0\n"];
        [text appendFormat:@"N;CHARSET=UTF-8:%@;%@;;;\n",
         [self firstName:person],
         [self lastName:person]];
        [text appendFormat:@"SOUND;X-IRMC-N;CHARSET=UTF-8:%@;%@;;;\n",
         [self firstNamePhonetic:person],
         [self lastNamePhonetic:person]];
        [text appendFormat:@"ORG;CHARSET=UTF-8:%@\n",
         [self organization:person]];
        [text appendFormat:@"TITLE;CHARSET=UTF-8:%@\n",
         [self title:person]];
        ABMultiValue *mValue = [person valueForProperty:kABEmailProperty];
        [text appendFormat:@"EMAIL;CHARSET=UTF-8;TYPE=INTERNET:%@\n", [self primaryValue:mValue]];
        mValue = [person valueForProperty:kABURLsProperty];
        [text appendFormat:@"URL;CHARSET=UTF-8:%@\n", [self primaryValue:mValue]];
        mValue = [person valueForProperty:kABPhoneProperty];
        NSInteger pref = [mValue indexForIdentifier:[mValue primaryIdentifier]];
        [text appendFormat:@"TEL;CHARSET=UTF-8;TYPE=PREF;%@%@:%@\n",
         [[self labelToType:[mValue labelAtIndex:pref]] objectAtIndex:0],
         [[self labelToType:[mValue labelAtIndex:pref]] objectAtIndex:1],
         [mValue valueAtIndex:pref]];
        for (int i = 0; i <[mValue count]; i++) {
            if (i != pref) {
                [text appendFormat:@"TEL;CHARSET=UTF-8;%@%@:%@\n",
                 [[self labelToType:[mValue labelAtIndex:i]] objectAtIndex:0],
                 [[self labelToType:[mValue labelAtIndex:i]] objectAtIndex:1],
                 [mValue valueAtIndex:i]];
            }
        }
        [text appendString:@"END:VCARD\n"];
    }
    [self.txtView insertText:text];
}

- (IBAction)Write_Push:(id)sender {
    [[self.txtView string] writeToURL:[NSURL fileURLWithPath:@"/Users/ynurmj5e/Documents/VCards/ab2mmi.vcf"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (IBAction)Clear_Push:(id)sender {
    [self.txtView setString:@""];
}

- (NSArray *)labelToType:(NSString *)label
{
    if ([label isEqualTo:kABPhoneHomeFAXLabel]) {
        return @[@"TYPE=HOME;", @"TYPE=FAX"];
    } else if ([label isEqualTo:kABPhoneHomeLabel]) {
        return @[@"TYPE=HOME;", @"TYPE=VOICE"];
    } else if ([label isEqualTo:kABPhoneiPhoneLabel]) {
        return @[@"", @"TYPE=CELL"];
    } else if ([label isEqualTo:kABPhoneMainLabel]) {
        return @[@"", @""];
    } else if ([label isEqualTo:kABPhoneMobileLabel]) {
        return @[@"", @"TYPE=CELL"];
    } else if ([label isEqualTo:kABPhonePagerLabel]) {
        return @[@"", @""];
    } else if ([label isEqualTo:kABPhoneWorkFAXLabel]) {
        return @[@"TYPE=WORK;", @"TYPE=FAX"];
    } else if ([label isEqualTo:kABPhoneWorkLabel]) {
        return @[@"TYPE=WORK;", @"TYPE=VOICE"];
    } else {
        return @[@"", @""];
    }
}

- (NSString *)firstName:(ABPerson *)person
{
    NSString *str = [person valueForProperty:kABFirstNameProperty];
    if ([str length] > 0) {
        return str;
    } else {
        return @"";
    }
}

- (NSString *)lastName:(ABPerson *)person
{
    NSString *str = [person valueForProperty:kABLastNameProperty];
    if ([str length] > 0) {
        return str;
    } else {
        return [self organization:person];
    }
}

- (NSString *)firstNamePhonetic:(ABPerson *)person
{
    NSString *str = [person valueForProperty:kABFirstNamePhoneticProperty];
    if ([str length] > 0) {
        return str;
    } else {
        return @"";
    }
}

- (NSString *)lastNamePhonetic:(ABPerson *)person
{
    NSString *str = [person valueForProperty:kABLastNamePhoneticProperty];
    if ([str length] > 0) {
        return str;
    } else {
        return @"";
    }
}

- (NSString *)organization:(ABPerson *)person
{
    NSString *str = [person valueForProperty:kABOrganizationProperty];
    if ([str length] > 0) {
        return str;
    } else {
        return @"";
    }
}

- (NSString *)title:(ABPerson *)person
{
    NSString *str = [person valueForProperty:kABTitleProperty];
    if ([str length] > 0) {
        return str;
    } else {
        return @"";
    }
}

- (NSString *)primaryValue:(ABMultiValue *)mValue
{
    NSString *str = [mValue valueForIdentifier:[mValue primaryIdentifier]];
    if ([str length] > 0) {
        return str;
    } else {
        return @"";
    }
}

@end
