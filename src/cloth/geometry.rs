use bytemuck::{Pod, Zeroable};

#[repr(C)]
#[derive(Copy, Clone, Debug, Pod, Zeroable)]
pub struct Particle {
    pub position: [f32; 3],
    pub velocity: [f32; 3],
}

impl Particle {
    pub fn new(x: f32, y: f32, z: f32, vx: f32, vy: f32, vz: f32) -> Self {
        Self {
            position: [x, y, z],
            velocity: [vx, vy, vz],
        }
    }
}

pub fn generate_cloth(rows: usize, cols: usize, spacing: f32) -> Vec<Particle> {
    let mut particles = Vec::new();
    for row in 0..rows {
        for col in 0..cols {
            particles.push(Particle::new(
                row as f32 * spacing,
                col as f32 * spacing,
                0.0, // z
                0.0, // vx
                0.0, // vy
                0.0, // vz
            ));
        }
    }
    particles
}

