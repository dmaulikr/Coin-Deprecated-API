//
//  SQLFile.h
//  MEDICINES
//
//  Created by R on 11/06/2015.
//  Copyright (c) 2015 Redixbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "AppDelegate.h"


@interface SQLFile : NSObject
{
    sqlite3 *database;
    AppDelegate *appd;
    NSString *strdbname;
    
}

@property(strong,nonatomic)AppDelegate *appd;


-(BOOL)operationdb:(NSString *)str;
-(NSMutableArray *)selectrecord:(NSString *)strqr;
-(NSMutableArray *)select_cate:(NSString *)strqr;
-(NSMutableArray *)note:(NSString *)strqr;
-(NSMutableArray *)select_favou:(NSString *)strqr;
-(NSMutableArray *)select_currency:(NSString *)strqr;
-(NSMutableArray *)select_allcurrency:(NSString *)strqr;

-(BOOL)updatedb:(NSString *)strupdate;
@end
