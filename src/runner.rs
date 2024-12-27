use wgpu_bootstrap::runner::{App, Context};
use wgpu_bootstrap::wgpu;
use wgpu::util::DeviceExt;
use wgpu_bootstrap::util::geometry;  // Assuming geometry is part of wgpu_bootstrap


pub struct ClothRunner;

impl App for ClothRunner {
    fn update(&mut self, delta_time: f32, context: &Context) {
        println!("Updating simulation... Delta time: {}", delta_time);
    }

    fn render(&self, render_pass: &mut wgpu::RenderPass<'_>) {
        println!("Rendering simulation...");
    }
}

impl ClothRunner {
    pub fn create_sphere_geometry(context: &mut Context, order: u32) -> (wgpu::Buffer, wgpu::Buffer) {
        let (positions, indices) = geometry::icosphere(order);

        // Flatten positions (Vector3<f32>) to a flat f32 slice
        let flat_positions: Vec<f32> = positions
            .iter()
            .flat_map(|v| vec![v.x, v.y, v.z])  // Flatten each Vector3<f32> into individual f32 values
            .collect();

        // Create the vertex buffer
        let vertex_buffer = context.device().create_buffer_init(&wgpu::util::BufferInitDescriptor {
            label: Some("Sphere Vertex Buffer"),
            contents: bytemuck::cast_slice(&flat_positions),  // Now we're passing a flat slice of f32
            usage: wgpu::BufferUsages::VERTEX,
        });

        // Create the index buffer
        let index_buffer = context.device().create_buffer_init(&wgpu::util::BufferInitDescriptor {
            label: Some("Sphere Index Buffer"),
            contents: bytemuck::cast_slice(&indices),
            usage: wgpu::BufferUsages::INDEX,
        });

        (vertex_buffer, index_buffer)
    }
}
