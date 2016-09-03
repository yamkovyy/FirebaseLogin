//
//  Helper.m
//  Firebase Login
//
//  Created by viera on 9/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (UIViewController*)loadVCWithIdentifier:(NSString*)identifier
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName: @"Main" bundle: [NSBundle mainBundle]];
    return [sb instantiateViewControllerWithIdentifier: identifier];
    
}

+ (void)showAlerIn:(UIViewController*)vc title:(NSString*)title message:(NSString*)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: title message: message preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

+(BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
