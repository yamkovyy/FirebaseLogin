//
//  SignUpViewController.m
//  Firebase Login
//
//  Created by viera on 9/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import "SignUpViewController.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import "Helper.h"
#import "MainViewController.h"
#import "TextFieldTVC.h"
#import "ButtonTVC.h"

@interface SignUpViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSString *test;
}

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *confirmPassword;
@property (nonatomic, strong) NSString *name;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerNib: [UINib nibWithNibName:@"TextFieldTVC" bundle:nil] forCellReuseIdentifier: NSStringFromClass([TextFieldTVC class])];
    [self.tableView registerNib: [UINib nibWithNibName:@"ButtonTVC" bundle:nil] forCellReuseIdentifier: NSStringFromClass([ButtonTVC class])];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden: false];
}

- (void)didTapSignUp:(id)sender
{
    if ([self isEmailAndPasswordValid])
    {
        __weak typeof(self) weakSelf = self;
        [[FIRAuth auth] createUserWithEmail:self.email
                                   password:self.password
                                 completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                     typeof(weakSelf) strongSelf = weakSelf;
                                     
                                     if (strongSelf)
                                     {
                                         if (error) {
                                             NSLog(@"%@", error.localizedDescription);
                                             [Helper showAlerIn: strongSelf title: @"Error" message: error.localizedDescription];
                                             return;
                                         }
                                         [self setDisplayName:user];
                                     }
                                     
                                 }];
    }
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

- (void)signedIn:(FIRUser *)user animated:(BOOL)animated
{
    [self.navigationController pushViewController: [Helper loadVCWithIdentifier: NSStringFromClass([MainViewController class])] animated: animated];
}

- (BOOL)isEmailAndPasswordValid
{
    BOOL valid = true;
    NSString *title;
    NSString *message;
    
    if (self.email.length == 0)
    {
        title = @"Empty Email";
        message = @"Email field cannot be empty.";
        valid = false;
    }
    else if (self.password.length == 0)
    {
        title = @"Empty Password";
        message = @"Password field cannot be empty.";
        valid = false;
    }
    else if (self.name.length == 0)
    {
        title = @"Empty Name";
        message = @"Name field cannot be empty.";
        valid = false;
    }
    else if ([self.confirmPassword isEqualToString: self.password])
    {
        title = @"Password Mismatch";
        message = @"Entered passwords are different.";
        valid = false;
    }
    else if (![Helper isValidEmail: self.email])
    {
        title = @"Wrong Email Format";
        message = @"Please enter valid email adress.";
        valid = false;
    }
    
    if (!valid)
    {
        [Helper showAlerIn: self title: title message: message];
    }
    
    return valid;
}




#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    switch (indexPath.row)
    {
        case 0:
        case 1:
        case 2:
        case 3:
        {
            TextFieldTVC *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([TextFieldTVC class])];
            cell.textField.tag = indexPath.row;
            cell.textField.delegate = self;
            returnCell = cell;
            break;
        }
        case 4:
        {
            ButtonTVC *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([ButtonTVC class])];
            returnCell = cell;
            break;
        }
        default:
            break;
    }
    
    return returnCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0;
    
    switch (indexPath.row)
    {
        case 0:
        case 1:
        case 2:
        case 3:
            height = 44;
            break;
        case 4:
            height = 50;
            break;
        default:
            break;
    }
    
    return 50;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

@end
