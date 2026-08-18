#import <Foundation/Foundation.h>

@interface IP1AppRegistry : NSObject
+ (NSArray *)defaultRegistrations;
+ (NSDictionary *)registrationForExtension:(NSString *)extension;
@end
