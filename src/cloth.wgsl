// Vertex shader

// Structure containing the view and projection matrices for camera transformations
struct CameraUniform {
    view: mat4x4<f32>, // View matrix transforms world coordinates to camera coordinates
    proj: mat4x4<f32>, // Projection matrix transforms camera coordinates to clip space
};

// Binding the camera uniform to group 1, binding 0
@group(1) @binding(0)
var<uniform> matrices: CameraUniform;

// Structure representing the input to the vertex shader
struct VertexInput {
    @location(0) position: vec3<f32>, // Vertex position in object space
    @location(1) normal: vec3<f32>,   // Vertex normal for lighting calculations
    @location(2) tangent: vec3<f32>,  // Tangent vector for advanced texturing (e.g., normal mapping)
    @location(3) tex_coords: vec2<f32>, // Texture coordinates for sampling textures
}

// Structure representing the output from the vertex shader
struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>, // Position in clip space for rasterization
    @location(0) tex_coords: vec2<f32>,          // Pass through texture coordinates to the fragment shader
    @location(1) normal: vec3<f32>,              // Pass through the normal vector for lighting calculations
}

// The vertex shader entry point
@vertex
fn vs_main(
    model: VertexInput, // Input vertex attributes
) -> VertexOutput {
    var out: VertexOutput; // Declare the output variable
    out.tex_coords = model.tex_coords; // Pass the texture coordinates to the output
    // Transform the vertex position from object space to clip space using the view and projection matrices
    out.clip_position = matrices.proj * matrices.view * vec4<f32>(model.position, 1.0);
    out.normal = model.normal; // Pass the normal vector to the output
    return out; // Return the output to the rasterizer
}

// Fragment shader

// Declare a texture and sampler for diffuse color sampling
@group(0) @binding(0)
var t_diffuse: texture_2d<f32>; // 2D texture for the diffuse color
@group(0) @binding(1)
var s_diffuse: sampler;         // Sampler for the texture

// The fragment shader entry point
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // Sample the diffuse texture using the interpolated texture coordinates
    return textureSample(t_diffuse, s_diffuse, in.tex_coords);
}
