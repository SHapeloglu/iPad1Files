#import "IP1AppRegistry.h"

@implementation IP1AppRegistry

+ (NSArray *)defaultRegistrations {
    return [NSArray arrayWithObjects:
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"pdf", @"extension",
            @"iPad1PDFReader", @"name",
            @"ipad1pdf://open?path=%@", @"url", nil],
        nil];
}

+ (NSDictionary *)registrationForExtension:(NSString *)extension {
    NSString *ext = [extension lowercaseString];
    for (NSDictionary *item in [self defaultRegistrations]) {
        if ([[item objectForKey:@"extension"] isEqualToString:ext]) return item;
    }
    return nil;
}

@end
