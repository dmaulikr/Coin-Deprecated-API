//
//  Constants.h
//
//  Created by nestcode on 3/1/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_ZOOMED (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

#define iPhoneVersion ([[UIScreen mainScreen] bounds].size.height == 568 ? 5 : ([[UIScreen mainScreen] bounds].size.height == 812 ? 10 : ([[UIScreen mainScreen] bounds].size.height == 667 ? 6 : ([[UIScreen mainScreen] bounds].size.height == 736 ? 61 : 999))))


#define URL_BASE    @"https://api.coinmarketcap.com/"

#define URL_ROOT_API    URL_BASE@"v1/ticker/"
#define API_GET_CURRENCY URL_ROOT_API@"?convert="
#define API_GET_CURRENCY_DETAIL   URL_ROOT_API@"%@/?convert=%@"
#define URL_IMAGE   @"http://coinmarketapp.co.uk/data/images/"
#define ICO_URL    @"https://api.icowatchlist.com/public/v1/"
#define URL_NEWS    @"https://min-api.cryptocompare.com/data/news/?lang=EN"
#define URL_GLOBAL    @"https://api.coinmarketcap.com/v1/global/?convert="
#define URL_MINING    @"https://www.cryptocompare.com/api/data/miningequipment/"
#define URL_GRAPH     @"https://graphs2.coinmarketcap.com/currencies/"


#define AD_BASE    @"http://adp.nestcodeinfo.com/api/advDetail"

typedef enum
{
    CALL_TYPE_NONE,
    CALL_TYPE_GET_CURRENCY,
    CALL_TYPE_GET_CURRENCY_DETAIL,
    CALL_TYPE_ICO_URL,
    CALL_TYPE_URL_NEWS,
    CALL_TYPE_URL_GLOBAL,
    CALL_TYPE_AD_BASE,
    }CallTypeEnum;

#endif
