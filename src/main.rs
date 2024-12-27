mod runner;
mod cloth;  // Declare the cloth module

use wgpu_bootstrap::runner::Runner;
use std::sync::Arc;
use crate::runner::ClothRunner;
use wgpu_bootstrap::egui::Color32;

fn main() {
    let mut runner = Runner::new(
        "Cloth Simulation",
        800, // Width
        600, // Height
        Color32::from_rgba_unmultiplied(0, 0, 0, 255), // Background color
        1, // MSAA sample count
        1, // Additional sample count
        Box::new(|_context| Arc::new(ClothRunner)),
    );
    runner.run();
}
