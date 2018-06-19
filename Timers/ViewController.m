//
//  ViewController.m
//  Timers
//
//  Created by Zaur Giyasov on 19/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "ViewController.h"
#import "Timer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Timer *t = [[Timer alloc] init];
    
    [t run];
    
    //[t cancelTimer];
    
}



@end
