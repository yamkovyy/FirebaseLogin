//
//  MainViewController.m
//  Firebase Login
//
//  Created by viera on 9/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import "MainViewController.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import "ViewController.h"
#import "Helper.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden: true];
}


- (IBAction)didTapLogOut:(id)sender
{
    FIRAuth *firebaseAuth = [FIRAuth auth];
    NSError *signOutError;
    BOOL status = [firebaseAuth signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }

    [self.navigationController pushViewController: [Helper loadVCWithIdentifier: NSStringFromClass([ViewController class])] animated: true];
}

@end
