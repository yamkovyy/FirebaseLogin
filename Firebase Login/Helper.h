//
//  Helper.h
//  Firebase Login
//
//  Created by viera on 9/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper : NSObject

+(UIViewController*)loadVCWithIdentifier:(NSString*)identifier;
+(void)showAlerIn:(UIViewController*)vc title:(NSString*)title message:(NSString*)message;
+(BOOL)isValidEmail:(NSString *)checkString;

@end
