# CSCI 5611 [Project 2](https://github.umn.edu/malin146/Project2)

By: Jacob Malin

This project uses cloth animaiton to recreate a short (4-5 second) serene shot from the Studio Ghibli film, Spirited Away. The scene depicts a small island in the ocean with a billowing clothesline. Below are a close up of the clothesline, my version of the scene, as well as the reference video that I have been working off of.

https://media.github.umn.edu/user/19560/files/f394f275-4266-43f8-b28c-74b2af55f7f8

https://media.github.umn.edu/user/19560/files/4a28d521-968c-419d-ac52-5c94aae0fefb

https://media.github.umn.edu/user/19560/files/9b2316b7-b1dc-47fd-83e2-949f2da8fb13

## Attempted Components

- Cloth	Simulation ( & Multiple Ropes )
- 3D Simulation
- High-quality Rendering
- Air Drag for Cloth

### Cloth	Simulation ( & Multiple Ropes )

This simulation models 7 pieces of cloth and one rope. The rope shares points with the tops of the cloths to hold them together. The cloth has one-way collision with the ground, which is shown in the video below.

https://media.github.umn.edu/user/19560/files/f51e6d1f-e6c2-4fb2-8c76-65d43677791d

### 3D Simulation

The simulation is rendered in 3D using the provided camera created by Liam Tyler.

https://media.github.umn.edu/user/19560/files/b7307f0a-96e6-4626-9efd-4f13191d20ec

### High-quality Rendering

The cloth is rendered in the context of a scene from the 6th station scene in Spirited Away. To add to the scene, a gradient was added to the sky to add some texture, there is also a cold ambient light and a warm point light that adds some essential shading to the house and half of the tree. Also the keys 1, 2, and 3 were bound to move the camera to different locations, notably key 2 also changes the speed of the camera to match the reference animation. The window of the animation is set to 1.85 : 1 also to match the reference animation.

### Air Drag for Cloth

Wind was added to the scene to make the cloth more dynamic. Below are videos with no drag, drag, low wind, med wind, and high wind, respectively.

https://media.github.umn.edu/user/19560/files/d7de3539-f9f3-4150-a917-64be6e664e69

https://media.github.umn.edu/user/19560/files/6632d10e-d639-4cdd-a8cb-ab6530ec56ad

https://media.github.umn.edu/user/19560/files/28e6ceff-41d1-44cf-8ce7-f14351ceab6e

https://media.github.umn.edu/user/19560/files/20b52f4f-a02a-400a-b3b4-1798d0afb2a9

https://media.github.umn.edu/user/19560/files/78144274-a992-49dd-a02c-eca34381dd4a

## Difficulties

This sim was practically build for shallow water simulation, however due to time constraints and sanity constraints, that was not implemented. Similarly a particle sim that modeled clouds was not within the scope of the project, but would have been cool.

As for more concrete difficulties, almost all constants in the sim are near breaking point, since I could not get Rk4 to work, so it relies on midpoint. And so the cloth is a little too whippy, strechy, and heavy.

Since the ground is just a really large sphere and the detail of the sphere is limited, there is a slight gap between the ground and what the cloth collides with.

I also learned blender for this project to model the house, and to seperate all of the models into color-seperate components. Just the house alone ended up eating up a lot of time.

## Tools/Libraries used

- All art is a reference to the 2001 film, Spirited Away written and directed by Hayao Miyazaki.
- The camera created by Liam Tyler was used, with some modifications so that holding shift will have a consitient boost, the camera cannot go below sea level, and the 1, 2, and 3 keys recall camera positions.
- The Vec2 library created by the professor was repurposed into a Vec3 library.
