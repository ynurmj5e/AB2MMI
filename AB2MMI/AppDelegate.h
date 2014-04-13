//
//  AppDelegate.h
//  AB2MMI
//
//  Created by 小田隆宏 on 2014/04/13.
//  Copyright (c) 2014年 小田隆宏. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/AddressBook.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    ABAddressBook *adBook;
    NSArray *groups;
    NSMutableArray *gNames;
}

- (NSArray *)labelToType:(NSString *)label;

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSComboBox *cmbBox;
@property (strong) IBOutlet NSTextView *txtView;

- (IBAction)Show_Push:(id)sender;
- (IBAction)Write_Push:(id)sender;
- (IBAction)Clear_Push:(id)sender;

@end
