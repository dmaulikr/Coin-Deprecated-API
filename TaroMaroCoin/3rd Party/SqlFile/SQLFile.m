 //
//  SQLFile.m
//  MEDICINES
//
//  Created by R on 11/06/2015.
//  Copyright (c) 2015 Redixbit. All rights reserved.
//

#import "SQLFile.h"


@implementation SQLFile
@synthesize appd;
-(id)init
{
    if (self=[super init])
    {
        appd =(UIApplication *)[[UIApplication sharedApplication]delegate];
        strdbname  =[[NSString alloc]initWithString:appd.strdbpath];
        
    }
    return self;
}

-(BOOL)operationdb:(NSString *)str
{
    BOOL y=NO;
    
    if (sqlite3_open([strdbname UTF8String], &database)==SQLITE_OK)
    {
        NSString *strq =[NSString stringWithString:str];
        
        sqlite3_stmt *cstmt;
        
        NSLog(@"%@",strdbname);
//        NSInteger lastRowId = sqlite3_last_insert_rowid(@"DBMedicine1.sqlite");
//        
//        NSLog(@"%ld",(long)lastRowId);

        
        
        if (sqlite3_prepare_v2(database, [strq UTF8String], -1, &cstmt, NULL)==SQLITE_OK)
        {
            sqlite3_step(cstmt);
            y=YES;
            
            long long lastRowId1 = sqlite3_last_insert_rowid(database);
            NSString *rowId = [NSString stringWithFormat:@"%d", (int)lastRowId1];
            NSLog(@"%@",rowId);
            
           
            self.appd=[[UIApplication sharedApplication] delegate];
//            appd.last_row_id=rowId;
//            
//            NSLog(@"%@",appd.last_row_id);
//            
//            AddMedicines *add=[[AddMedicines alloc]init];
//            add.str_rem_id=rowId;
            

        }
        sqlite3_finalize(cstmt);
        sqlite3_close(database);
        
    }
    
    
    return y;
}

-(BOOL)updatedb:(NSString *)strupdate
{
    BOOL y=NO;
    if (sqlite3_open([strdbname UTF8String], &database) == SQLITE_OK)
    {
        NSString *strq =[NSString stringWithString:strupdate];
        
        sqlite3_stmt *cstmt;
       // sqlite3_bind_int(cstmt, 1,[NSString stringWithFormat:@"%d",med_id]);
        if (sqlite3_prepare_v2(database, [strq UTF8String], -1, &cstmt, NULL)==SQLITE_OK)
        {
            sqlite3_step(cstmt);
            y=YES;
        }
        sqlite3_finalize(cstmt);
        sqlite3_close(database);
    }
    return y;
}

-(NSMutableArray *)selectrecord:(NSString *)strqr
{
    NSMutableArray *marr = [[NSMutableArray alloc]init];
 //   cls_medicine *cls_data =[cls_medicine new];
    
    if (sqlite3_open([strdbname UTF8String], &database)==SQLITE_OK)
    {
        NSString *userstr =[NSString stringWithString:strqr];
        sqlite3_stmt *cstmt;
        if(sqlite3_prepare_v2(database, [userstr UTF8String], -1, &cstmt, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(cstmt)==SQLITE_ROW)
            {
                NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];

                NSString *n0=[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt, 0)];
                [dic setValue:n0 forKey:@"id"];
                
             //   NSLog(@"%@",dic);
                
                NSString *n1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt, 1)];
                [dic setValue:n1 forKey:@"cate_id"];

             //    NSLog(@"%@",dic);
             
                NSString *n2 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt, 2)];
                [dic setValue:n2 forKey:@"cate_title"];
                
            //     NSLog(@"%@",dic);
                
                NSString *n3 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt, 3)];
                [dic setValue:n3 forKey:@"cate_sub"];

               

               
                [marr addObject:dic];
            }
          //  NSLog(@"ARR =%@",marr);
        }
        sqlite3_finalize(cstmt);
        sqlite3_close(database);
        
    }
    return marr;
}

-(NSMutableArray *)note:(NSString *)strqr
{
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    //   cls_medicine *cls_data =[cls_medicine new];
    
    if (sqlite3_open([strdbname UTF8String], &database)==SQLITE_OK)
    {
        NSString *userstr =[NSString stringWithString:strqr];
        sqlite3_stmt *cstmt;
        if(sqlite3_prepare_v2(database, [userstr UTF8String], -1, &cstmt, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(cstmt)==SQLITE_ROW)
            {
                NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
                
                NSString *n0=[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt, 0)];
                [dic setValue:n0 forKey:@"id"];
                
              
                
                NSString *n1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt, 1)];
                [dic setValue:n1 forKey:@"detail"];
                
                
                NSString *n2 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt, 2)];
                [dic setValue:n2 forKey:@"date"];
                
              
                
                [marr addObject:dic];
            }
          //  NSLog(@"ARR =%@",marr);
        }
        sqlite3_finalize(cstmt);
        sqlite3_close(database);
        
    }
    return marr;
}

-(NSMutableArray *)select_cate:(NSString *)strqr
{
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    //   cls_medicine *cls_data =[cls_medicine new];
    
    if (sqlite3_open([strdbname UTF8String], &database)==SQLITE_OK)
    {
        NSString *userstr =[NSString stringWithString:strqr];
        sqlite3_stmt *cstmt;
        if(sqlite3_prepare_v2(database, [userstr UTF8String], -1, &cstmt, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(cstmt)==SQLITE_ROW)
            {
                
                NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
                
                NSString *n0=[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt, 0)];
                [dic setValue:n0 forKey:@"cate_title"];
                
            //    NSLog(@"%@",dic);
                
                [marr addObject:dic];
            }
          //  NSLog(@"ARR =%@",marr);
        }
        sqlite3_finalize(cstmt);
        sqlite3_close(database);
        
    }
    return marr;
}

-(NSMutableArray *)select_favou:(NSString *)strqr
{
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    //   cls_medicine *cls_data =[cls_medicine new];
    
    if (sqlite3_open([strdbname UTF8String], &database)==SQLITE_OK)
    {
        NSString *userstr =[NSString stringWithString:strqr];
        sqlite3_stmt *cstmt;
        if(sqlite3_prepare_v2(database, [userstr UTF8String], -1, &cstmt, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(cstmt)==SQLITE_ROW)
            {
                NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
                
                NSString *n=[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt,1)];
                [dic setValue:n forKey:@"CoinID"];

                [marr addObject:dic];
            }
          //  NSLog(@"ARR =%@",marr);
        }
        sqlite3_finalize(cstmt);
        sqlite3_close(database);
        
    }
    return marr;
}

-(NSMutableArray *)select_currency:(NSString *)strqr
{
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    NSString *n;
    //   cls_medicine *cls_data =[cls_medicine new];
    
    if (sqlite3_open([strdbname UTF8String], &database)==SQLITE_OK)
    {
        NSString *userstr =[NSString stringWithString:strqr];
        sqlite3_stmt *cstmt;
        if(sqlite3_prepare_v2(database, [userstr UTF8String], -1, &cstmt, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(cstmt)==SQLITE_ROW)
            {
                NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
                
                n=[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt,0)];
              //  [dic setValue:n forKey:@"CSymbol"];
                
                [marr addObject:n];
            }
            //  NSLog(@"ARR =%@",marr);
        }
        sqlite3_finalize(cstmt);
        sqlite3_close(database);
        
    }
    return marr;
}

-(NSMutableArray *)select_allcurrency:(NSString *)strqr
{
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    NSString  *name, *fullname;
    //   cls_medicine *cls_data =[cls_medicine new];
    
    if (sqlite3_open([strdbname UTF8String], &database)==SQLITE_OK)
    {
        NSString *userstr =[NSString stringWithString:strqr];
        sqlite3_stmt *cstmt;
        if(sqlite3_prepare_v2(database, [userstr UTF8String], -1, &cstmt, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(cstmt)==SQLITE_ROW)
            {
                NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
 
                name=[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt,1)];
                [dic setValue:name forKey:@"CName"];
                
                fullname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(cstmt,3)];
                [dic setValue:fullname forKey:@"CFullName"];
                
                [marr addObject:dic];
            }
            //  NSLog(@"ARR =%@",marr);
        }
        sqlite3_finalize(cstmt);
        sqlite3_close(database);
        
    }
    return marr;
}

@end
