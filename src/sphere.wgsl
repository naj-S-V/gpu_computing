// Vertex shader

// Structure containing the view and projection matrices for camera transformations
struct CameraUniform {
    view: mat4x4<f32>, // View matrix transforms world coordinates to camera coordinates
    proj: mat4x4<f32>, // Projection matrix transforms camera coordinates to clip space
};

// Binding the camera uniform to group 0, binding 0
@group(0) @binding(0)
var<uniform> matrices: CameraUniform;

// Structure representing the input to the vertex shader
struct VertexInput {
    @location(0) position: vec3<f32>, // Vertex position in object space
    @location(1) normal: vec3<f32>,   // Vertex normal for potential lighting calculations
    @location(2) tangent: vec3<f32>,  // Tangent vector for advanced texturing (not used here)
    @location(3) tex_coords: vec2<f32>, // Texture coordinates for sampling textures (not used here)
}

// Structure representing the output from the vertex shader
struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>, // Position in clip space for rasterization
}

// The vertex shader entry point
@vertex
fn vs_main(
    model: VertexInput, // Input vertex attributes
) -> VertexOutput {
    var out: VertexOutput; // Declare the output variable
    // Transform the vertex position from object space to clip space
    // The position is scaled by 0.95 to slightly shrink the object
    out.clip_position = matrices.proj * matrices.view * vec4<f32>(model.position * 0.95, 1.0);
    return out; // Return the transformed position for the rasterizer
}

// Fragment shader

// The fragment shader entry point
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // Outputs a solid blue color with full opacity for every pixel
    return vec4(0.0, 0.0, 1.0, 1.0); // RGBA: Blue color
}