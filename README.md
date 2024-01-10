# CSCI 5611 Project 2

By: Jacob Malin

This project uses cloth animaiton to recreate a short (4-5 second) serene shot from the Studio Ghibli film, Spirited Away. The scene depicts a small island in the ocean with a billowing clothesline. Below are a close up of the clothesline, my version of the scene, as well as the reference video that I have been working off of.

https://github.com/JacobMalin/cloth-sim/assets/34765120/241d0762-84e7-418f-aca3-ecb229db5b0e

https://github.com/JacobMalin/cloth-sim/assets/34765120/b95b296d-e64f-4f73-8c7c-9f811e13432c

https://github.com/JacobMalin/cloth-sim/assets/34765120/53a9cf2c-ff1f-459d-a834-bb893902f00a

## Attempted Components

- Cloth	Simulation ( & Multiple Ropes )
- 3D Simulation
- High-quality Rendering
- Air Drag for Cloth

### Cloth	Simulation ( & Multiple Ropes )

This simulation models 7 pieces of cloth and one rope. The rope shares points with the tops of the cloths to hold them together. The cloth has one-way collision with the ground, which is shown in the video below.

https://github.com/JacobMalin/cloth-sim/assets/34765120/393ae74c-dc46-4f56-b619-cebd81227bd3

### 3D Simulation

The simulation is rendered in 3D using the provided camera created by Liam Tyler.

https://github.com/JacobMalin/cloth-sim/assets/34765120/7a7bdb2c-6bdd-4648-8dfd-9468e2d90f3a

### High-quality Rendering

The cloth is rendered in the context of a scene from the 6th station scene in Spirited Away. To add to the scene, a gradient was added to the sky to add some texture, there is also a cold ambient light and a warm point light that adds some essential shading to the house and half of the tree. Also the keys 1, 2, and 3 were bound to move the camera to different locations, notably key 2 also changes the speed of the camera to match the reference animation. The window of the animation is set to 1.85 : 1 also to match the reference animation.

### Air Drag for Cloth

Wind was added to the scene to make the cloth more dynamic. The drag is most visible in the sway of the short cloths and the rippliing of the cloths that touch the floor. (Notably the length of the cloth is random and changes between each video.) Below are videos with no drag, drag, low wind, med wind, and high wind, respectively. 

https://github.com/JacobMalin/cloth-sim/assets/34765120/384e0ada-0668-404c-968c-1aa1e5a49aed

https://github.com/JacobMalin/cloth-sim/assets/34765120/f5ce8504-3ac7-4ca0-a008-885eecb210e6

https://github.com/JacobMalin/cloth-sim/assets/34765120/cbc1d148-e85d-4d0b-91be-0efb3179e82a

https://github.com/JacobMalin/cloth-sim/assets/34765120/e292d184-4ac9-44b7-8419-10def98b8204

https://github.com/JacobMalin/cloth-sim/assets/34765120/4d8be67b-c4f7-440f-9a80-9cde8f35b40c

## Difficulties

This sim was practically build for shallow water simulation, however due to time constraints and sanity constraints, that was not implemented. Similarly a particle sim that modeled clouds was not within the scope of the project, but would have been cool.

As for more concrete difficulties, almost all constants in the sim are near breaking point, since I could not get Rk4 to work, so it relies on midpoint. And so the cloth is a little too whippy, strechy, and heavy.

Since the ground is just a really large sphere and the detail of the sphere is limited, there is a slight gap between the ground and what the cloth collides with.

I also learned blender for this project to model the house, and to seperate all of the models into color-seperate components. Just the house alone ended up eating up a lot of time.

## Tools/Libraries used

- All art is a reference to the 2001 film, Spirited Away written and directed by Hayao Miyazaki.
- The camera created by Liam Tyler was used, with some modifications so that holding shift will have a consitient boost, the camera cannot go below sea level, and the 1, 2, and 3 keys recall camera positions.
- The Vec2 library created by the professor was repurposed into a Vec3 library.
