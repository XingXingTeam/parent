//
//  XHJAddressBook.h
//  RCIM
//
//  Created by codeDing on 16/2/26.
//  Copyright © 2016年 codeDing. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
@class PersonModel;
typedef void (^PersonsBlock)(NSMutableArray *personArr);
@interface XHJAddressBook : NSObject
{
    NSArray *_addressArr;
    NSMutableArray *_persons;
    NSMutableArray *_listContent;
    NSMutableArray *_list2Content;
}

@property (nonatomic,strong) NSMutableArray *perArr;
@property (nonatomic,strong) UILocalizedIndexedCollation *localCollation;
//@property (nonatomic,strong) PersonsBlock getPersons;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

-(NSMutableArray*)getAllPerson;
@end
