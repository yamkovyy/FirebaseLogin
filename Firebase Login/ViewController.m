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

- (IBAction)didTapSignIn:(id)sender {
    // Sign In with credentials.
    NSString *email = _emailField.text;
    NSString *password = _passwordField.text;
    
    if (email && password)
    {
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                             if (error) {
                                 NSString *errorCode = error.localizedDescription;
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                                                 message:errorCode
                                                                                delegate:self cancelButtonTitle:@"Try again!" otherButtonTitles:nil, nil];
                                 [alert show];
                                 NSLog(@"%@", error.localizedDescription);
                                 return;
                             }
                             [self signedIn:user animated: true];
                         }];
    }
    else
    {
        return;
    }
}

- (IBAction)didTapSignUp:(id)sender {
    NSString *email = _emailField.text;
    NSString *password = _passwordField.text;
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                 if (error) {
                                     NSLog(@"%@", error.localizedDescription);
                                     return;
                                 }
                                 [self setDisplayName:user];
                             }];
}

- (void)setDisplayName:(FIRUser *)user {
    FIRUserProfileChangeRequest *changeRequest =
    [user profileChangeRequest];
    // Use first part of email as the default display name
    changeRequest.displayName = [[user.email componentsSeparatedByString:@"@"] objectAtIndex:0];
    [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        [self signedIn:user animated: true];
    }];
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
