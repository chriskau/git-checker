//
//  Created by Chris Kau on 9/1/11.
//  Copyright (c) 2011 Chris Kau. All rights reserved.
//

#import "Globals.h"
#import <Foundation/Foundation.h>

static NSString *kDivStartString = @"<div id=\"ver\">";
static NSString *kDivEndString = @"</div>";


int main (int argc, const char * argv[])
{
    @autoreleasepool {

        // get the HTML from http://git-scm.com
        NSError *error = nil;
        NSString *htmlString = [NSString stringWithContentsOfURL:NSURL(@"http://git-scm.com")
                                                        encoding:NSUTF8StringEncoding
                                                           error:&error];

        if (!htmlString) {
            NSLog(@"ERROR: %@", [error localizedDescription]);
            return -1;
        }


        // get the current version number

        NSRange startRange = [htmlString rangeOfString:kDivStartString
                                               options:NSCaseInsensitiveSearch];

        if (startRange.location == NSNotFound) {
            NSLog(@"ERROR: Could not find version number of the current Git release.");
            return -1;
        }

        NSRange range = NSMakeRange(NSMaxRange(startRange), 14);
        NSRange endRange = [htmlString rangeOfString:kDivEndString
                                             options:NSCaseInsensitiveSearch
                                             range:range];

        if (endRange.location == NSNotFound) {
            NSLog(@"ERROR: Could not find the closing '</div>'.");
            return -1;
        }


        // extract the version number (minus the leading 'v')

        NSUInteger location = NSMaxRange(startRange) + 1;
        NSUInteger length = endRange.location - location;

        NSString *currentVersion = [htmlString substringWithRange:NSMakeRange(location, length)];


        // get the version number of the currently installed version of git

        NSTask *git = [[NSTask alloc] init];

        NSPipe *pipe = [NSPipe pipe];
        [git setStandardOutput:pipe];

        [git setLaunchPath:@"/usr/bin/git"];
        [git setArguments:NSARRAY(@"--version")];
        [git launch];

        NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];

        [git waitUntilExit];
        [git release];

        NSString *localVersion = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        localVersion = [localVersion substringFromIndex:12];
        localVersion = [localVersion stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];


        // compare version numbers

        if (![localVersion isEqualToString:currentVersion]) {
            printf("A newer version of git (%s) is available.\n", [currentVersion UTF8String]);
        }
        else {
            printf("The most recent version of git (%s) is installed locally.\n", [currentVersion UTF8String]);
        }
    }

    return 0;
}

