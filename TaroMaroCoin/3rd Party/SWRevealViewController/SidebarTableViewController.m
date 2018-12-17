//
//  SidebarTableViewController.m
//  SidebarDemo
//
//  Created by Simon Ng on 10/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

#import "SidebarTableViewController.h"
#import "SWRevealViewController.h"
#import "SidebarTableViewCell.h"


@interface SidebarTableViewController ()

@end

@implementation SidebarTableViewController {
    NSArray *menuItems;
    NSUserDefaults *isLogin;
    NSUserDefaults *ColorCode, *Userprofileimg,*UserData;
    NSString *strColor;
    NSMutableDictionary *userDictData;
    NSUserDefaults *userLanguage;
    NSString *strLang;
    NSString *port ;
    MFMailComposeViewController *mailCont;
    NSString *osVersion ,*deviceName ,*appVersion;
    NSString *strTheme;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isLogin = [NSUserDefaults standardUserDefaults];
    
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    
    menuItems = @[@"logo",@"home", @"herozero", @"news", @"icos", @"settings", @"support", @"share", @"rateus"];
    
    Userprofileimg = [NSUserDefaults standardUserDefaults];
    UserData = [NSUserDefaults standardUserDefaults];
    userDictData = [[NSMutableDictionary alloc]init];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    userLanguage = [NSUserDefaults standardUserDefaults];
    strLang = [userLanguage valueForKey:@"AppleLanguages"];
    
    //  Day/Night Mode Setting
    strTheme = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"theme"];
    
    if ([strTheme isEqualToString:@"1"]) {
        [self.tableView setBackgroundColor:[UIColor blackColor]];
        self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    }
    else{
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    [self.revealViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    strTheme = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"theme"];
    
    if ([strTheme isEqualToString:@"1"]) {
        [self.tableView setBackgroundColor:[UIColor blackColor]];
        self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    }
    else{
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
    }
    
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    SidebarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    userDictData = [UserData valueForKey:@"UserData"];

    //  Day/Night Mode Setting
    strTheme = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"theme"];
    
    if ([strTheme isEqualToString:@"1"]) {
        [cell.contentView setBackgroundColor:[UIColor blackColor]];
        self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
        [cell.lblStatic1 setTextColor:[UIColor whiteColor]];
        [cell.lblStatic2 setTextColor:[UIColor whiteColor]];
        [cell.lblStatic3 setTextColor:[UIColor whiteColor]];
        [cell.lblStatic4 setTextColor:[UIColor whiteColor]];
        [cell.lblStatic5 setTextColor:[UIColor whiteColor]];
        [cell.lblStatic6 setTextColor:[UIColor whiteColor]];
        [cell.lblStatic7 setTextColor:[UIColor whiteColor]];
        [cell.lblStatic8 setTextColor:[UIColor whiteColor]];
        [cell.lblStatic9 setTextColor:[UIColor whiteColor]];
        [cell.lblName setTextColor:[UIColor whiteColor]];
        [cell.lblSubName setTextColor:[UIColor whiteColor]];
        
        cell.imgHome.image = [UIImage imageNamed:@"dark_btn_home.png"];
        cell.imgGlobal.image = [UIImage imageNamed:@"dark_btn_global.png"];
        cell.imgICOs.image = [UIImage imageNamed:@"dark_btn_ico.png"];
        cell.imgNews.image = [UIImage imageNamed:@"dark_btn_news.png"];
        cell.imgSettings.image = [UIImage imageNamed:@"dark_btn_settings.png"];
        cell.imgSupport.image = [UIImage imageNamed:@"dark_btn_support.png"];
        cell.imgAboutUs.image = [UIImage imageNamed:@"dark_btn_about.png"];
        cell.imgShare.image = [UIImage imageNamed:@"dark_btn_share.png"];
        cell.imgRateUs.image = [UIImage imageNamed:@"dark_btn_rate.png"];
        
    }
    else{
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0f/255.0f green:181.0f/255.0f blue:201.0f/255.0f alpha:1.0];
        [cell.lblStatic1 setTextColor:[UIColor blackColor]];
        [cell.lblStatic2 setTextColor:[UIColor blackColor]];
        [cell.lblStatic3 setTextColor:[UIColor blackColor]];
        [cell.lblStatic4 setTextColor:[UIColor blackColor]];
        [cell.lblStatic5 setTextColor:[UIColor blackColor]];
        [cell.lblStatic6 setTextColor:[UIColor blackColor]];
        [cell.lblStatic7 setTextColor:[UIColor blackColor]];
        [cell.lblStatic8 setTextColor:[UIColor blackColor]];
        [cell.lblStatic9 setTextColor:[UIColor blackColor]];
        [cell.lblName setTextColor:[UIColor blackColor]];
        [cell.lblSubName setTextColor:[UIColor blackColor]];
        
        cell.imgHome.image = [UIImage imageNamed:@"btn_home.png"];
        cell.imgGlobal.image = [UIImage imageNamed:@"btn_global.png"];
        cell.imgICOs.image = [UIImage imageNamed:@"btn_ico.png"];
        cell.imgNews.image = [UIImage imageNamed:@"btn_news.png"];
        cell.imgSettings.image = [UIImage imageNamed:@"btn_settings.png"];
        cell.imgSupport.image = [UIImage imageNamed:@"btn_support.png"];
        cell.imgAboutUs.image = [UIImage imageNamed:@"btn_about.png"];
        cell.imgShare.image = [UIImage imageNamed:@"btn_share.png"];
        cell.imgRateUs.image = [UIImage imageNamed:@"btn_rate.png"];
    }
    
    NSString *strName = [NSString stringWithFormat:@"%@",[userDictData valueForKey:@"child_name"]];
    
    if ([strName isEqualToString:@""]) {
       cell.lbl_name.text = @"Welcome";
        cell.lbl_email.text = @"GUEST";
    }
    else{
        cell.lbl_name.text = strName;
        cell.lbl_email.text = [NSString stringWithFormat:@"%@",[userDictData valueForKey:@"email"]];
    }
    
    NSString *str_image = [NSString stringWithFormat:@"%@",[Userprofileimg valueForKey:@"user_profile_image"]];
    
    [cell.user_profile sd_setImageWithURL:[NSURL URLWithString:str_image] placeholderImage:[UIImage imageNamed:@"user_image.png"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [cell.user_profile updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell.user_profile reveal];
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 10) {
        
        NSString *strLogout = NSLocalizedString(@"Are you sure you want to logout?", @"");
        NSString *strLogoutAtt = NSLocalizedString(@"Attention!!", @"");
        NSString *strYES = NSLocalizedString(@"YES", @"");
        NSString *strNO = NSLocalizedString(@"NO", @"");
        
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:strLogoutAtt
                                     message:strLogout
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:strYES
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [isLogin setInteger:0 forKey:@"LoggedIn"];
                                        [isLogin synchronize];
                                        
                                        [userLanguage setValue:@"EN" forKey:@"AppleLanguages"];
                                        
                                        [Userprofileimg setObject:@"" forKey:@"user_profile_image"];
                                        [Userprofileimg synchronize];
                                        
                                        [self performSegueWithIdentifier:@"OutToLogin" sender:self];
                                       
                                    }];
        UIAlertAction* noButton = [UIAlertAction
                                    actionWithTitle:strNO
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                             
                                    }];
        [alert addAction:yesButton];
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else if (indexPath.row == 7){
    
        NSString *str = @"https://itunes.apple.com/us/app/cryptocurrency-coinmarketcap/id1376008786?ls=1&mt=8";
        NSArray * shareItems = @[str];
        NSLog(@"%@",shareItems);
        
        UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
        avc.excludedActivityTypes = nil;
            [self presentViewController:avc animated:YES completion:nil];
        
    }
    else if(indexPath.row == 8){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://itunes.apple.com/us/app/cryptocurrency-coinmarketcap/id1376008786?ls=1&mt=8"]];
    }
    else if (indexPath.row == 6){
        osVersion = [NSString stringWithFormat:@"iOS %@", [[UIDevice currentDevice] systemVersion] ];
        deviceName = [self deviceModelName];
        appVersion = [NSString stringWithFormat:@"App Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        if([MFMailComposeViewController canSendMail]) {
            mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;
            [mailCont setSubject:@"Feedback"];
            [mailCont setToRecipients:[NSArray arrayWithObject:@"http://www.nestcodeinfo.com/"]];
            [mailCont setMessageBody:[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n%@\n%@\n%@",osVersion,deviceName,appVersion] isHTML:NO];
            [self presentViewController:mailCont animated:YES completion:NULL];
        }
        else{
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Aleart"
                                         message:@"No Mail Account has been set!! Please set Mail Account first in order to send Support Mail"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                       }];
            [alert addAction:noButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // CGFloat height;
    if(indexPath.row==0)
    {
        return   140;
    }
    else
    {
        return 50;
    }

}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString*)deviceModelName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //MARK: More official list is at
    //http://theiphonewiki.com/wiki/Models
    //MARK: You may just return machineName. Following is for convenience
    
    NSDictionary *commonNamesDictionary =
    @{
      @"i386":     @"i386 Simulator",
      @"x86_64":   @"x86_64 Simulator",
      
      @"iPhone1,1":    @"iPhone",
      @"iPhone1,2":    @"iPhone 3G",
      @"iPhone2,1":    @"iPhone 3GS",
      @"iPhone3,1":    @"iPhone 4",
      @"iPhone3,2":    @"iPhone 4(Rev A)",
      @"iPhone3,3":    @"iPhone 4(CDMA)",
      @"iPhone4,1":    @"iPhone 4S",
      @"iPhone5,1":    @"iPhone 5(GSM)",
      @"iPhone5,2":    @"iPhone 5(GSM+CDMA)",
      @"iPhone5,3":    @"iPhone 5c(GSM)",
      @"iPhone5,4":    @"iPhone 5c(GSM+CDMA)",
      @"iPhone6,1":    @"iPhone 5s(GSM)",
      @"iPhone6,2":    @"iPhone 5s(GSM+CDMA)",
      
      @"iPhone7,1":    @"iPhone 6+(GSM+CDMA)",
      @"iPhone7,2":    @"iPhone 6(GSM+CDMA)",
      
      @"iPhone8,1":    @"iPhone 6S(GSM+CDMA)",
      @"iPhone8,2":    @"iPhone 6S+(GSM+CDMA)",
      @"iPhone8,4":    @"iPhone SE(GSM+CDMA)",
      @"iPhone9,1":    @"iPhone 7(GSM+CDMA)",
      @"iPhone9,2":    @"iPhone 7+(GSM+CDMA)",
      @"iPhone9,3":    @"iPhone 7(GSM+CDMA)",
      @"iPhone9,4":    @"iPhone 7+(GSM+CDMA)",
      
      @"iPhone10,1":    @"iPhone 8",
      @"iPhone10,2":    @"iPhone 8+",
      @"iPhone10,3":    @"iPhone X",
      @"iPhone10,4":    @"iPhone 8",
      @"iPhone10,5":    @"iPhone 8+",
      @"iPhone10,6":    @"iPhone X",
      
      @"iPad1,1":  @"iPad",
      @"iPad2,1":  @"iPad 2(WiFi)",
      @"iPad2,2":  @"iPad 2(GSM)",
      @"iPad2,3":  @"iPad 2(CDMA)",
      @"iPad2,4":  @"iPad 2(WiFi Rev A)",
      @"iPad2,5":  @"iPad Mini 1G (WiFi)",
      @"iPad2,6":  @"iPad Mini 1G (GSM)",
      @"iPad2,7":  @"iPad Mini 1G (GSM+CDMA)",
      @"iPad3,1":  @"iPad 3(WiFi)",
      @"iPad3,2":  @"iPad 3(GSM+CDMA)",
      @"iPad3,3":  @"iPad 3(GSM)",
      @"iPad3,4":  @"iPad 4(WiFi)",
      @"iPad3,5":  @"iPad 4(GSM)",
      @"iPad3,6":  @"iPad 4(GSM+CDMA)",
      
      @"iPad4,1":  @"iPad Air(WiFi)",
      @"iPad4,2":  @"iPad Air(GSM)",
      @"iPad4,3":  @"iPad Air(GSM+CDMA)",
      
      @"iPad5,3":  @"iPad Air 2 (WiFi)",
      @"iPad5,4":  @"iPad Air 2 (GSM+CDMA)",
      
      @"iPad4,4":  @"iPad Mini 2G (WiFi)",
      @"iPad4,5":  @"iPad Mini 2G (GSM)",
      @"iPad4,6":  @"iPad Mini 2G (GSM+CDMA)",
      
      @"iPad4,7":  @"iPad Mini 3G (WiFi)",
      @"iPad4,8":  @"iPad Mini 3G (GSM)",
      @"iPad4,9":  @"iPad Mini 3G (GSM+CDMA)",
      
      @"iPod1,1":  @"iPod 1st Gen",
      @"iPod2,1":  @"iPod 2nd Gen",
      @"iPod3,1":  @"iPod 3rd Gen",
      @"iPod4,1":  @"iPod 4th Gen",
      @"iPod5,1":  @"iPod 5th Gen",
      @"iPod7,1":  @"iPod 6th Gen",
      };
    
    deviceName = commonNamesDictionary[machineName];
    if (deviceName == nil) {
        deviceName = machineName;
    }
    return deviceName;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    // Set the title of navigation bar by using the menu items
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
//    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
//    
//    // Set the photo if it navigates to the PhotoView
//   
//}


@end
