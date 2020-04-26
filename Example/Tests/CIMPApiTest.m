//
//  CIMPApiTest.m
//  CIMiniProgram_Tests
//
//  Created by 袁鑫 on 2020/4/17.
//  Copyright © 2020 jasonyuan1986. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CIMPApiTest : XCTestCase

@end

@implementation CIMPApiTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testUI {
    
}

@end
