//
//  CNSCoin.h
//  Coinstatus
//
//  Created by nestcode on 3/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNSCoin : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *coinName;
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, copy) NSString *symbol;

@end
