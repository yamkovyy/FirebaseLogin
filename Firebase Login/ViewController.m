//
//  ViewController.m
//  Firebase Login
//
//  Created by viera on 9/2/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import "ViewController.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import "MainViewController.h"
#import "Helper.h"
#import "SignUpViewController.h"
@import Firebase;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FIRUser *user = [FIRAuth auth].currentUser;
    if (user)
    {
        [self signedIn:user animated: false];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden: true];
}

- (IBAction)didTapSignIn:(id)sender
{
    // Sign In with credentials.
    NSString *email = _emailField.text;
    NSString *password = _passwordField.text;
    __weak typeof(self) weakSelf = self;
    
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                             typeof(weakSelf) strongSelf = weakSelf;
                             
                             if (strongSelf)
                             {
                                 if (error) {
                                     NSLog(@"%@", error.localizedDescription);
                                     [Helper showAlerIn: strongSelf title: @"Error" message: error.localizedDescription];
                                     return;
                                 }
                                  [self signedIn:user animated: true];
                             }
                         }];
}

- (IBAction)didTapSignUp:(id)sender
{
    [self.navigationController pushViewController: [Helper loadVCWithIdentifier: NSStringFromClass([SignUpViewController class])] animated: true];
}

- (IBAction)didRequestPasswordReset:(id)sender
{
    UIAlertController *prompt =
    [UIAlertController alertControllerWithTitle:nil
                                        message:@"Email:"
                                 preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *weakPrompt = prompt;
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   UIAlertController *strongPrompt = weakPrompt;
                                   NSString *userInput = strongPrompt.textFields[0].text;
                                   if (!userInput.length)
                                   {
                                       return;
                                   }
                                   [[FIRAuth auth] sendPasswordResetWithEmail:userInput
                                                                   completion:^(NSError * _Nullable error) {
                                                                       if (error) {
                                                                           NSLog(@"%@", error.localizedDescription);
                                                                           return;
                                                                       }
                                                                   }];
                                   
                               }];
    [prompt addTextFieldWithConfigurationHandler:nil];
    [prompt addAction:okAction];
    [self presentViewController:prompt animated:YES completion:nil];
}

- (void)signedIn:(FIRUser *)user animated:(BOOL)animated
{
    [self.navigationController pushViewController: [Helper loadVCWithIdentifier: NSStringFromClass([MainViewController class])] animated: animated];
}

@end
