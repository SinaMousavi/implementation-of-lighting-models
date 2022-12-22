Shader "Unlit/Specular"
{
    Properties
    {
        _color("color" , Color) = (1,1,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            #include "UnityLightingCommon.cginc"

            struct vertexInput
            {
                float4 vertex : POSITION;
                float3 normal:NORMAL;
                
            };

            struct vertexOutput
            {
                float3 normal:NORMAL;
                float4 worldPos:TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

           float4 _color;

            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                o.worldPos = mul(unity_ObjectToWorld,v.vertex);
                return o;
            }

            float4 frag (vertexOutput o) : SV_Target
            {
               float3 normal = normalize(o.normal);
               float3 view = normalize(_WorldSpaceCameraPos - o.worldPos.xyz);
               float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
               float3 reflectedLightDir = normalize( reflect(lightDir , normal) );
               float diffuse = 0.5f; 
               float spec = 0.4f;
               float specPart = max( 0 , dot(view , reflectedLightDir) ) * spec; 
               float diffusePart = max( 0 , dot(lightDir , normal) ) * diffuse;
               float3 finale = (specPart + diffusePart) * _LightColor0.rgb + _color.rgb * 0.6;
               //diffusePart = floor(diffusePart * 3) / 3;
               //float steps = step(0.001 , diffusePart);
               
               return float4(finale   , 0);
                
            }
            ENDCG
        }
    }
}
