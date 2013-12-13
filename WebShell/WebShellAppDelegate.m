/*
 * Copyright (C) 2013 Tek Counsel LLC
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#import "WebShellAppDelegate.h"

@implementation WebShellAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
        
        self.window.clipsToBounds =YES;
        
        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
    }

    
    
    // Override point for customization after application launch.
    
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    
    application.applicationSupportsShakeToEdit = YES;
    [ZBarReaderView class];
    
    self.window.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        UIStoryboard *storyBoard;
        storyBoard = [UIStoryboard storyboardWithName:@"iPadStoryBoard" bundle:nil];
        UIViewController *initViewController = [storyBoard instantiateInitialViewController];
        [self.window setRootViewController:initViewController];
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSString *url = [userInfo getString:@"url"];
    if(![url isEqualToString:@""]){
        NSString *scriptfunction = [userInfo getString:@"scriptfunction"];
        NSString *customdata = [userInfo getString:@"customdata"];
        
        NSMutableDictionary *navaction = [[NSMutableDictionary alloc] initWithObjectsAndKeys:CMD_NAVIGATE,@"action",url,@"url",@"",@"title",[NSDate date],@"date",@"GET",@"httpMethod",nil];
        
        if([scriptfunction isEqualToString:@""] == FALSE){
            [navaction setObjectSafely:scriptfunction forKey:@"scriptfunction"];
            
            if([customdata isEqualToString:@""]==FALSE){
                [navaction setObjectSafely:customdata forKey:@"customdata"];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ON_NAVIGATE object:navaction];
        return;
    }
    
    
    NSDictionary *aps =(NSDictionary*) [userInfo objectForKey:@"aps"];
    NSString *strAlert = [aps getString:@"alert"];
    if (![strAlert isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]
                            initWithTitle:@""
                            message:strAlert
                            delegate:nil cancelButtonTitle:nil
                            otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    NSString *badge = [userInfo getString:@"badge"];
    if(![badge isEqualToString:@""]){
        application.applicationIconBadgeNumber = [[userInfo objectForKey:@"badge"] integerValue];
    }
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    UIView *view = [self.window.subviews objectAtIndex:0];
    [UIHelper fadeInMessage:view text:[error localizedDescription]];
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    NSString *tokenStr = [deviceToken description];
    NSString *pushToken = [[[tokenStr
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSCache *appCache =[CacheManager appCache];
    
    NSMutableDictionary *action =(NSMutableDictionary*)[appCache objectForKey:CACHE_CURRENT_ACTION];
    
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] initWithObjectsAndKeys:pushToken,@"pushToken", nil];
    
    HTTPUtils *http = [[HTTPUtils alloc] init];
    
    http.callBack=@selector(onResponse:);
    
    http.callBackOwner=self;
    
   // NSLog(@"didRegisterForRemoteNotification action is %@", [action description]);
    
    [http executeAction:action postdata:postdata];
    
}


-(void) onResponse:(NSData*)jsondata{
    NSString *json = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    
    //NSLog(@"json response to push call is %@", [json description]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ON_RESPONSE object:json];
}





- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
	
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
   // NSLog(@"purging sharedURLCache");
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


@end
