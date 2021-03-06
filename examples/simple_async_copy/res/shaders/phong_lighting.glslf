#version 440 core
#extension GL_ARB_separate_shader_objects : enable 
#extension GL_NV_gpu_shader5 : enable

in vec3 normal;
in vec2 texture_coord;
in vec3 view_dir;

uniform vec3    light_ambient;
uniform vec3    light_diffuse;
uniform vec3    light_specular;
uniform vec3    light_position;

uniform vec3    material_ambient;
uniform vec3    material_diffuse;
uniform vec3    material_specular;
uniform float   material_shininess;
uniform float   material_opacity;

uniform sampler2D color_texture_aniso;
uniform sampler2D color_texture_nearest;

layout(location = 0) out vec4        out_color;

void main()
{
    vec4 res;
    vec3 n = normalize(normal);
    vec3 l = normalize(light_position); // assume parallel light!
    vec3 v = normalize(view_dir);
    vec3 h = normalize(l + v);//gl_LightSource[0].halfVector);//

    vec4 c;


    if (texture_coord.x > 0.5) {
        c = texture(color_texture_aniso, texture_coord);
    }
    else {
        c = texture(color_texture_nearest, texture_coord);
    }

    c.rgb *= material_diffuse;


    res.rgb =  light_ambient * material_ambient
         + light_diffuse * c.rgb/*material_diffuse*/ * max(0.0, dot(n, l))
         + light_specular * material_specular * pow(max(0.0, dot(n, h)), material_shininess);

    //res.rgb = c.rgb;//vec3(texture_coord, 0.0);//
    res.a = material_opacity;

    out_color = res;
}

