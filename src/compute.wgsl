// Compute shader

// Structure to store positions and related attributes of each vertex
struct Position {
    position_x: f32, // X-coordinate of the vertex position
    position_y: f32, // Y-coordinate of the vertex position
    position_z: f32, // Z-coordinate of the vertex position
    normal_x: f32,   // X-component of the vertex normal
    normal_y: f32,   // Y-component of the vertex normal
    normal_z: f32,   // Z-component of the vertex normal
    tangent_x: f32,  // X-component of the vertex tangent
    tangent_y: f32,  // Y-component of the vertex tangent
    tangent_z: f32,  // Z-component of the vertex tangent
    tex_coords_x: f32, // X-coordinate of the texture
    tex_coords_y: f32, // Y-coordinate of the texture
}

// Structure to store velocities of each vertex
struct Velocity {
    velocity_x: f32, // Velocity along the X-axis
    velocity_y: f32, // Velocity along the Y-axis
    velocity_z: f32, // Velocity along the Z-axis
}

// Uniform data shared across all vertices, including simulation parameters
struct ComputeData {
    delta_time: f32,          // Time step for the simulation
    nb_vertices: f32,         // Total number of vertices in the cloth
    sphere_radius: f32,       // Radius of the collision sphere
    sphere_center_x: f32,     // X-coordinate of the sphere center
    sphere_center_y: f32,     // Y-coordinate of the sphere center
    sphere_center_z: f32,     // Z-coordinate of the sphere center
    vertex_mass: f32,         // Mass of each vertex
    structural_stiffness: f32, // Stiffness of structural springs
    shear_stiffness: f32,     // Stiffness of shear springs
    bend_stiffness: f32,      // Stiffness of bend springs
    structural_damping: f32,  // Damping of structural springs
    shear_damping: f32,       // Damping of shear springs
    bend_damping: f32,        // Damping of bend springs
}

// Structure to define spring connections between vertices
struct Spring {
    vertex_index_1: f32, // Index of the first vertex in the spring
    vertex_index_2: f32, // Index of the second vertex in the spring
    rest_length: f32,    // Resting length of the spring
}

// Buffers and data bindings
@group(0) @binding(0) var<storage, read_write> verticiesPositions: array<Position>; // Positions of the vertices
@group(1) @binding(0) var<storage, read_write> verticiesVelocities: array<Velocity>; // Velocities of the vertices
@group(2) @binding(0) var<uniform> data: ComputeData; // Simulation parameters
@group(3) @binding(0) var<storage, read> springsR: array<Spring>; // Springs connecting the vertices

// Compute shader entry point
@compute @workgroup_size(128, 1, 1)
fn main(@builtin(global_invocation_id) param: vec3<u32>) {
    // Check if the current invocation is within bounds
    if (param.x >= u32(data.nb_vertices)) {
          return;
    }

    // Access the spring data for the current vertex
    var spring = springsR[param.x];

    // Update the position of the vertex based on its velocity and delta time
    // We use for x => x = x + v * dt
    verticiesPositions[param.x].position_x += verticiesVelocities[param.x].velocity_x * data.delta_time;
    verticiesPositions[param.x].position_y += verticiesVelocities[param.x].velocity_y * data.delta_time;
    verticiesPositions[param.x].position_z += verticiesVelocities[param.x].velocity_z * data.delta_time;

    // Calculate the distance from the vertex to the sphere center
    let sphere_center = vec3<f32>(data.sphere_center_x, data.sphere_center_y, data.sphere_center_z);
    let sphere_radius = data.sphere_radius;
    let position = vec3<f32>(verticiesPositions[param.x].position_x, verticiesPositions[param.x].position_y, verticiesPositions[param.x].position_z);

    let distance = length(position - sphere_center);

    // Apply velocity damping (placeholder logic for now)
    verticiesVelocities[param.x].velocity_x += 0.0;

    // Handle collision detection and response with the sphere
    if (distance < sphere_radius) {
        // Vertex is inside the sphere; push it out
        let normal = normalize(position - sphere_center); // Calculate normal at the collision point

        // Adjust position to be on the sphere's surface
        verticiesPositions[param.x].position_x += normal.x * (sphere_radius - distance);
        verticiesPositions[param.x].position_y += normal.y * (sphere_radius - distance);
        verticiesPositions[param.x].position_z += normal.z * (sphere_radius - distance);

        // Stop the velocity to simulate collision response
        verticiesVelocities[param.x].velocity_x = 0.0;
        verticiesVelocities[param.x].velocity_y = 0.0;
        verticiesVelocities[param.x].velocity_z = 0.0;
    }
}
