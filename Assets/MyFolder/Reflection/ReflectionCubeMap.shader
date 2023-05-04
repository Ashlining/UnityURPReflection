Shader "Unlit/ReflectionCubeMap"
{
    Properties
    {
        _CubeMap ("CubeMap", cube) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            samplerCUBE _CubeMap;

            v2f vert (appdata v)
            {
                v2f o = (v2f) 0;
                o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.worldNormal = TransformObjectToWorldNormal(v.normal.xyz);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                Light light=GetMainLight();
                float3 worldLightDir= light.direction;
                float3 reflectDir=normalize(reflect(-worldLightDir,i.worldNormal));

                half4 envCol = texCUBE(_CubeMap, reflectDir);
                half3 envHDRCol = DecodeHDREnvironment(envCol, unity_SpecCube0_HDR);
                return half4(envHDRCol,1);
            }
            ENDHLSL
        }
    }
}
