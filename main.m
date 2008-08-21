//
//  main.m
//  Croak
//
//  Created by Brian Cooke on 8/21/08.
//  Copyright (c) 2008 roobasoft, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <RubyCocoa/RBRuntime.h>
#import <HMBlkAppKit/HMBlkAppKit.h>

int main(int argc, const char *argv[])
{
    return RBApplicationMain("rb_main.rb", argc, argv);
}
