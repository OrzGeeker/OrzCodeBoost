//___FILEHEADER___

#import "___FILEBASENAME___.h"

@implementation ___FILEBASENAMEASIDENTIFIER___

+ (instancetype)sharedInstance {
    static ___FILEBASENAMEASIDENTIFIER___ *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[___FILEBASENAMEASIDENTIFIER___ alloc] init];
    });
    return _instance;
}

@end
