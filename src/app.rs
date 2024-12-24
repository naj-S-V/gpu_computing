use wgpu_bootstrap::wgpu;
use wgpu_bootstrap::runner::Context;
use crate::cloth::geometry::{generate_cloth, Particle};
use wgpu_bootstrap::wgpu::util::DeviceExt;

pub struct ClothApp {
    particle_buffer: wgpu::Buffer,
    particle_count: usize,
}

impl ClothApp {
    pub fn new(context: &mut Context) -> Self {
        let particles = generate_cloth(10, 10, 0.1);

        let particle_buffer = context.device().create_buffer_init(&wgpu::util::BufferInitDescriptor {
            label: Some("Particle Buffer"),
            contents: bytemuck::cast_slice(&particles),
            usage: wgpu::BufferUsages::VERTEX | wgpu::BufferUsages::STORAGE,
        });

        Self {
            particle_buffer,
            particle_count: particles.len(),
        }
    }
}

