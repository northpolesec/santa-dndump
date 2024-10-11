#import <AppKit/AppKit.h>

static int observerCount = 0;
static int notificationCount = 1;

static const char* objectToCString(id object) {
  return [[object description] cStringUsingEncoding: NSUTF8StringEncoding];
}

static void writeObject(id data, id object) {
  if (object) {
    printf("[%s] %s\n", objectToCString(object), objectToCString(data));
  } else {
    printf("%s\n", objectToCString(data));
  }
}

typedef void (^ObserverBlock)(id,id);

static void handleNotification(CFNotificationCenterRef center, void *observer, CFNotificationName name, const void *object, CFDictionaryRef userInfo) {
  // NSLog(@"%@: %@[%@]", name, object, userInfo);
  ObserverBlock block = (__bridge ObserverBlock)observer;
  if (block) block((__bridge id)object, (__bridge id)userInfo);
  if (notificationCount != -1) {
    if (notificationCount > 0) {
        notificationCount--;
    }

    if (notificationCount == 0) {
      exit(0);
    }
  }
}

static void execute(const char* bin, NSString* notificationName) {

  CFNotificationCenterRef center = CFNotificationCenterGetDistributedCenter();

  ObserverBlock observer = ^(id object, id userInfo) {
      NSData* data = [NSJSONSerialization dataWithJSONObject: userInfo options: NSJSONWritingPrettyPrinted error: nil];
      printf("%s\n", objectToCString([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]));
  };

  CFNotificationCenterAddObserver(center, CFBridgingRetain([observer copy]),
      handleNotification,
      (__bridge CFStringRef)notificationName, nil, CFNotificationSuspensionBehaviorDeliverImmediately);

    observerCount += 1;
}

int main(int argc, const char** argv) {
  @autoreleasepool {

    int i = 1;

    NSString* notificationName = @"com.northpolesec.santa.notification.blockedeexecution";
    notificationCount = 1;

    execute(argv[0], notificationName);

    if (observerCount) CFRunLoopRun();
    return 0;
  }
}
