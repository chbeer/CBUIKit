//
//  UIDevice+Machine.m
//  CBUIKit
//
//  Created by Christian Beer on 09.03.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "UIDevice+Machine.h"

#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice (Machine)

- (NSString *)cbuiMachine
{
    size_t size;
    
    // Set 'oldp' parameter to NULL to get the size of the data
    // returned so we can allocate appropriate amount of space
    sysctlbyname("hw.machine", NULL, &size, NULL, 0); 
    
    // Allocate the space to store name
    char *name = malloc(size);
    
    // Get the platform name
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    // Place name into a string
    NSString *machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    
    // Done with this
    free(name);
    
    return machine;
}

- (NSString*) cbuiMachineReadableName 
{
    NSString *machine = [self cbuiMachine];
    
    if ([@"i386" isEqual:machine]) {
        return @"iOS Simulator";
        
    } else if ([@"iPhone1,1" isEqual:machine]) {
        return @"iPhone";
    } else if ([@"iPhone1,2" isEqual:machine]) {
        return @"iPhone 3G";
    } else if ([@"iPhone2,1" isEqual:machine]) {
        return @"iPhone 3GS";
    } else if ([@"iPhone3,1" isEqual:machine]) {
        return @"iPhone 4";
        
    } else if ([@"iPod1,1" isEqual:machine]) {
        return @"iPod touch (1st Gen.)";
    } else if ([@"iPod2,1" isEqual:machine]) {
        return @"iPod touch (2st Gen.)";
    } else if ([@"iPod3,1" isEqual:machine]) {
        return @"iPod touch (3st Gen.)";
        
    } else {
        return @"Unknown device";
    }
}

@end
