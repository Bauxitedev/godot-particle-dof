# Godot Particle DoF

This is a shader for particles to create a bokeh-esque depth of field effect. It works by essentially "precomputing" the various amounts of blur, instead of blurring in real time. Since the particles are radial, we can store only a single row of pixels per blur level, and the shader will distort the UV coordinates to turn it into a circle. This gives us a very compact 512x1024 texture that stores 1024 different blur levels, which can be smoothly interpolated.

This has the following advantages:

- Really really fast blur. The GPU only has to look up the texture in a lookup table. No nested for loops with expensive convolution here. Only issue here is that there's a fairly large amount of overdraw.
- Allows extremely large blur sizes (e.g. can blur a particle so much that it covers the entire screen without lagging).
- No artifacts because of low sample count, looks very close to the "ground truth".

But has some disadvantages as well:

- Only works for radial particles, that is, disks and toruses and such, facing towards the camera.
- All particles must have the same size, or the effect breaks down.
