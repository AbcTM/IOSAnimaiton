//
//  ViewController.m
//  SampleBuffer
//
//  Created by tm on 2018/11/22.
//  Copyright © 2018 tm. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property(nonatomic, strong) AVSampleBufferDisplayLayer *sampleBufferDisplayLayer;
@property(nonatomic, strong) CVPixelBufferRef previousPixelBuffer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.sampleBufferDisplayLayer = [[AVSampleBufferDisplayLayer alloc] init];
    self.sampleBufferDisplayLayer.frame = self.view.bounds;
    self.sampleBufferDisplayLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    self.sampleBufferDisplayLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.sampleBufferDisplayLayer.opaque = YES;
    [self.view.layer addSublayer:self.sampleBufferDisplayLayer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//把pixelBuffer包装成samplebuffer送给displayLayer
- (void)dispatchPixelBuffer:(CVPixelBufferRef) pixelBuffer
{
    if (!pixelBuffer){
        return;
    }
    
    @synchronized(self) {
        if (self.previousPixelBuffer){
            CFRelease(self.previousPixelBuffer);
            self.previousPixelBuffer = nil;
        }
        self.previousPixelBuffer = CFRetain(pixelBuffer);
    }
    
    //不设置具体时间信息
    CMSampleTimingInfo timing = {kCMTimeInvalid, kCMTimeInvalid, kCMTimeInvalid};
    //获取视频信息
    CMVideoFormatDescriptionRef videoInfo = NULL;
    OSStatus result = CMVideoFormatDescriptionCreateForImageBuffer(NULL, pixelBuffer, &videoInfo);
    NSParameterAssert(result == 0 && videoInfo != NULL);
    
    CMSampleBufferRef sampleBuffer = NULL;
    result = CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault,pixelBuffer, true, NULL, NULL, videoInfo, &timing, &sampleBuffer);
    NSParameterAssert(result == 0 && sampleBuffer != NULL);
    CFRelease(pixelBuffer);
    CFRelease(videoInfo);
    
    
    CFArrayRef attachments = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, YES);
    CFMutableDictionaryRef dict = (CFMutableDictionaryRef)CFArrayGetValueAtIndex(attachments, 0);
    CFDictionarySetValue(dict, kCMSampleAttachmentKey_DisplayImmediately, kCFBooleanTrue);
    [self enqueueSampleBuffer:sampleBuffer toLayer:self.sampleBufferDisplayLayer];
    CFRelease(sampleBuffer);
}

- (void)enqueueSampleBuffer:(CMSampleBufferRef) sampleBuffer toLayer:(AVSampleBufferDisplayLayer*) layer
{
    if (sampleBuffer){
        CFRetain(sampleBuffer);
        [layer enqueueSampleBuffer:sampleBuffer];
        CFRelease(sampleBuffer);
        if (layer.status == AVQueuedSampleBufferRenderingStatusFailed){
            NSLog(@"ERROR: %@", layer.error);
            if (-11847 == layer.error.code){
                [self rebuildSampleBufferDisplayLayer];
            }
        }else{
            //            NSLog(@"STATUS: %i", (int)layer.status);
        }
    }else{
        NSLog(@"ignore null samplebuffer");
    }
}

- (void)rebuildSampleBufferDisplayLayer{
    @synchronized(self) {
        [self teardownSampleBufferDisplayLayer];
        [self setupSampleBufferDisplayLayer];
    }
}

- (void)teardownSampleBufferDisplayLayer
{
    if (self.sampleBufferDisplayLayer){
        [self.sampleBufferDisplayLayer stopRequestingMediaData];
        [self.sampleBufferDisplayLayer removeFromSuperlayer];
        self.sampleBufferDisplayLayer = nil;
    }
}

- (void)setupSampleBufferDisplayLayer{
    if (!self.sampleBufferDisplayLayer){
        self.sampleBufferDisplayLayer = [[AVSampleBufferDisplayLayer alloc] init];
        self.sampleBufferDisplayLayer.frame = self.view.bounds;
        self.sampleBufferDisplayLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        self.sampleBufferDisplayLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.sampleBufferDisplayLayer.opaque = YES;
        [self.view.layer addSublayer:self.sampleBufferDisplayLayer];
    }else{
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.sampleBufferDisplayLayer.frame = self.view.bounds;
        self.sampleBufferDisplayLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        [CATransaction commit];
    }
    [self addObserver];
}

- (void)addObserver{
    //    if (!hasAddObserver){
    //        NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    //        [notificationCenter addObserver: self selector:@selector(didResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    //        [notificationCenter addObserver: self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    //        hasAddObserver = YES;
    //    }
}


- (UIImage*)getUIImageFromPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    UIImage *uiImage = nil;
    if (pixelBuffer){
        CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
        uiImage = [UIImage imageWithCIImage:ciImage];
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [uiImage drawInRect:self.view.bounds];
        uiImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return uiImage;
}

- (void)didResignActive{
    NSLog(@"resign active");
    [self setupPlayerBackgroundImage];
}

- (void) setupPlayerBackgroundImage{
    //    if (self.isVideoHWDecoderEnable){
    //        @synchronized(self) {
    //            if (self.previousPixelBuffer){
    //                self.image = [self getUIImageFromPixelBuffer:self.previousPixelBuffer];
    //                CFRelease(self.previousPixelBuffer);
    //                self.previousPixelBuffer = nil;
    //            }
    //        }
    //    }
}


/*
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    // The video can either be encoded, decoded and then displayed... or just displayed with no encoding
    if(encodeVideo)
    {
        CFRetain(sampleBuffer);
        
        NSLog(@"PTS: %f", CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer)));
        
        CVPixelBufferRef pixelBuffer =CMSampleBufferGetImageBuffer(sampleBuffer);
        CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        CMTime duration = CMSampleBufferGetDuration(sampleBuffer);
        
        VTEncodeInfoFlags flags;
        
        VTCompressionSessionEncodeFrame(compressionSession, pixelBuffer, pts, duration, NULL, NULL, &flags);
        
        CFRelease(sampleBuffer);
    }
    else
    {
        CFRetain(sampleBuffer);
        
        [displayLayer enqueueSampleBuffer:sampleBuffer];
        
        CFRelease(sampleBuffer);
    }
}
*/


@end
