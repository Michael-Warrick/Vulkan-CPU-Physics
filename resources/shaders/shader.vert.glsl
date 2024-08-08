#version 460
#define PI 3.14159265358979323846

layout(set = 0, binding = 0) uniform UniformBufferObject
{
    mat4 model;
    mat4 view;
    mat4 projection;
}ubo;

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec3 inColor;
layout(location = 2) in vec2 inTexCoords;

layout(location = 0) out vec3 fragColor;
layout(location = 1) out vec2 fragTexCoords;

// Structure to hold particle data
struct PhysicsObject {
    vec3 position;
    vec4 rotation;
    vec3 velocity;
    vec3 angularVelocity;
    float radius;
    float mass;
    float elasticity;
    float momentOfInertia;
};

layout(set = 0, binding = 2) buffer PhysicsObjectBuffer {
    PhysicsObject physicsObjects[];
};

// Reimplementation of glm::translate()
mat4 translate(mat4 matrix, vec3 translation) {
    mat4 translationMatrix = mat4(
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        translation.x, translation.y, translation.z, 1.0
    );
    return translationMatrix * matrix;
}

void main() 
{
    uint instanceIndex = gl_InstanceIndex;
    
    mat4 transformedModel = translate(ubo.model, physicsObjects[instanceIndex].position);

    gl_Position = ubo.projection * ubo.view * transformedModel * vec4(inPosition, 1.0);

    fragColor = inColor;
    fragTexCoords = inTexCoords;
}