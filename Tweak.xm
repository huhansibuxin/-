#import <objc/runtime.h>

// 鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€ Fake IMPs 鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€
static BOOL fake_isProxy(id self, SEL _cmd) { return NO; }
static void fake_lock(id self, SEL _cmd) {}
static void fake_unlock(id self, SEL _cmd) {}

// 鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€ Patch a single class 鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€
static void patch_class(Class cls) {
    unsigned int count;
    Method *methods = class_copyMethodList(cls, &count);
    for (unsigned int i = 0; i < count; i++) {
        SEL sel = method_getName(methods[i]);
        const char *name = sel_getName(sel);
        IMP imp = NULL;

        if (strcmp(name, "isProxy") == 0) {
            imp = (IMP)fake_isProxy;
        } else if (strcmp(name, "lock") == 0) {
            imp = (IMP)fake_lock;
        } else if (strcmp(name, "unlock") == 0) {
            imp = (IMP)fake_unlock;
        }

        if (imp) {
            method_setImplementation(methods[i], imp);
            NSLog(@"[WCUnlock] patched -[%s %s]", class_getName(cls), name);
        }
    }
    free(methods);
}

// 鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€ Constructor 鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€
__attribute__((constructor))
static void WCUnlock_init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
        int numClasses = objc_getClassList(NULL, 0);
        Class *classes = (Class *)malloc(sizeof(Class) * numClasses);
        objc_getClassList(classes, numClasses);

        for (int i = 0; i < numClasses; i++) {
            const char *name = class_getName(classes[i]);
            if (strstr(name, "WCallRecorder") ||
                strstr(name, "WCR_") ||
                strstr(name, "WCP_")) {
                patch_class(classes[i]);
            }
        }
        free(classes);
        NSLog(@"[WCUnlock] all target classes patched");
    });
}
