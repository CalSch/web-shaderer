# web-shaderer
Lets you do shaders in the web.  
The 'web' part is important because it means we can't use compute shaders ([like what Acerola is doing](https://www.youtube.com/watch?v=5y1Oin7CcI4)) or anything using `RenderingDevice`s because you just can't do that in the web.
Because of this, I use `SubViewport`s with `TextureRect`s inside (either with an `ImageTexture` or a `ViewportTexture` to the previous pass) and put a shader material on them to apply a GLSL shader.

![A screenshot of the app](https://github.com/user-attachments/assets/ef5da55f-259a-4a14-9bc5-087ce8dba086)


## todo
(things that shpuld be done before i can say the project is finished, in no particular order)
- upload custom images
- fix image sizing
- serialize shader parameters
- **get shader compilation errors**
  - seems that i may have to modify godot itself to add functionality
- render button
- ui improvements
  - custom theme
  - add some MarginContainers
- `TextureSampler`s as shader parameters
  - use shader pass outputs as textures!
- fix syntax highlighting
- put Blender-like 'driver's in shader uniforms (eg. type `#frame` to replace it with the frame number)

## feature ideas
(things that could be added to make it cool)
- a library of shader passes (for each user and/or for the public)
- videos instead of pictures
- audio?
- **you should come up with some ideas!** (and maybe contribute too! i believe in you!)
