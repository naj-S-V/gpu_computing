use wgpu_bootstrap::runner::{App, Context};
use wgpu_bootstrap::wgpu;

pub struct ClothRunner;

impl App for ClothRunner {
    fn update(&mut self, delta_time: f32, context: &Context) {
        println!("Updating simulation... Delta time: {}", delta_time);
    }

    fn render(&self, render_pass: &mut wgpu::RenderPass<'_>) {
        println!("Rendering simulation...");
    }
}
