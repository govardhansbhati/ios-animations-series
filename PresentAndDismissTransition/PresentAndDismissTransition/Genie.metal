#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
float2 genie(float2 position,
             float4 bounds,       // Screen bounds
             float btnX, float btnY, float btnW, float btnH, // Separate floats
             float squeezeFactor,
             float shrinkFactor,
             float slideFactor) {
    
    // Reconstruct button vector
    float4 buttonFrame = float4(btnX, btnY, btnW, btnH);
    
    float2 screenSize = bounds.zw;
    float2 screenCenter = screenSize / 2.0;
    
    // Calculate centers
    float2 buttonSize = buttonFrame.zw;
    float2 buttonCenter = buttonFrame.xy + buttonSize / 2.0;
    
    // 1. Calculate the offset required to move Center to Button
    // If slideFactor is 1, we want the image to shift by this amount
    float2 totalOffset = buttonCenter - screenCenter;
    float2 currentOffset = totalOffset * slideFactor;
    
    // 2. Calculate Scale
    float2 targetScale = buttonSize / screenSize;
    
    // We only shrink Y when sliding (slideFactor), X acts independently (squeezeFactor)
    float currentScaleX = mix(1.0, targetScale.x, squeezeFactor);
    float currentScaleY = mix(1.0, targetScale.y, slideFactor);
    
    // 3. Genie "Suction" Effect (Bending X)
    // We want the bottom of the view to be narrower than the top
    // yNorm: 0 at top, 1 at bottom
    float yNorm = position.y / screenSize.y;
    
    // Curve: Affects the bottom more than the top
    float curve = pow(yNorm, 3.5);
    float genieSqueeze = mix(1.0, 0.1, squeezeFactor * curve);
    
    // 4. Apply Transformations
    // Move coordinate to center
    float2 p = position - screenCenter;
    
    // Inverse Translate: To move image DOWN, we subtract positive offset
    p -= currentOffset;
    
    // Inverse Genie Squeeze
    p.x /= genieSqueeze;
    
    // Inverse Scale
    p.x /= currentScaleX;
    p.y /= currentScaleY;
    
    // Restore coordinate system
    p += screenCenter;
    
    return p;
}
