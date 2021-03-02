//
// Copyright 2019 Le Hoang Quyen. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

- (void)initImpl {}
- (void)deallocImpl {}
- (void)viewDidMoveToWindow {}

- (void)viewDidLoad
{
#if DEBUG
    NSLog(@"MGLKViewController viewDidLoad");
#endif
    [super viewDidLoad];
}

- (void)setPreferredFramesPerSecond:(NSInteger)preferredFramesPerSecond
{
    _preferredFramesPerSecond = preferredFramesPerSecond;
    if (_displayLink)
    {
        if (ANGLE_APPLE_AVAILABLE_CI(13.0, 10.0))
        {
            _displayLink.preferredFramesPerSecond = _preferredFramesPerSecond;
        }
        else
        {
            _displayLink.frameInterval = 60 / std::max<NSInteger>(_preferredFramesPerSecond, 1);
        }
    }
    [self pause];
    [self resume];
}

- (void)pause
{
#if DEBUG
    NSLog(@"MGLKViewController pause");
#endif

    _isPaused = YES;

    if (_displayLink)
    {
        [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        _displayLink = nil;
    }
}

- (void)resume
{
    [self pause];
#if DEBUG
    NSLog(@"MGLKViewController resume");
#endif

    _isPaused = NO;

    if (!_glView)
    {
        return;
    }

    if (!_displayLink)
    {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(frameStep)];
        if (ANGLE_APPLE_AVAILABLE_CI(13.0, 10.0))
        {
            _displayLink.preferredFramesPerSecond = _preferredFramesPerSecond;
        }
        else
        {
            _displayLink.frameInterval = 60 / std::max<NSInteger>(_preferredFramesPerSecond, 1);
        }
    }

    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}
