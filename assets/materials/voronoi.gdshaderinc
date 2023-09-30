#include "random.gdshaderinc"

vec3 vector(ivec3 pos) {
    float x = s_random(hash_4(pos.x, pos.y, pos.z, 0));
    float y = s_random(hash_4(pos.x, pos.y, pos.z, 1)) * sqrt(1.0 - x * x);
    float z = s_random(hash_4(pos.x, pos.y, pos.z, 2)) * sqrt(1.0 - x * x - y * y);
    return vec3(x, y, z) * 0.5 + vec3(0.5, 0.5, 0.5);
}

float sphDist(vec3 a, vec3 b) {
    return acos(dot(a, b)) / PI;
}

float voronoi_3(vec3 pos, out ivec3 minPos) {
    ivec3 ipos = ivec3(floor(pos));

    float minDist = 1000.0;

    minPos = ipos;

    for (int i = -1; i <= 1; i++)
    for (int j = -1; j <= 1; j++)
    for (int k = -1; k <= 1; k++) {
        ivec3 iposOfs = ipos + ivec3(i,j,k);
        vec3 offset = vector(iposOfs);

        float dist = sphDist(normalize(pos + vec3(offset)), normalize(vec3(iposOfs)));

        minPos = minDist < dist ? minPos : iposOfs;
        minDist = min(minDist, dist);
    }
    
    return minDist;
}