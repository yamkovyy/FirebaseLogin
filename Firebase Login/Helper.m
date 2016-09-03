//
//  Helper.m
//  Firebase Login
//
//  Created by viera on 9/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+(UIViewController*)loadVCWithIdentifier:(NSString*)identifier
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName: @"Main" bundle: [NSBundle mainBundle]];
    return [sb instantiateViewControllerWithIdentifier: identifier];
    
}

@end
