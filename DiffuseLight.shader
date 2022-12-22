Shader "Unlit/DiffuseLight"
{
    Properties
    {
        
    }
    SubShader
    {
        Tags { "LightMode" = "ForwardBase" }
        

        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            #include "UnityLightingCommon.cginc"

            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal:NORMAL;
                float4 t:TEXCOORD1;
            };

            struct VertexOutput
            {
                float2 uv : TEXCOORD0;
                float4 vertex : POSITION;
                float3 normal:NORMAL;
                float4 worldPos:TEXCOORD1;
            };
            
           

            

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                o.worldPos = mul(unity_ObjectToWorld , v.vertex);
                return o;
            }

            float4 frag (VertexOutput i) : SV_TARGET
            {
                float3 lightPos = normalize(_WorldSpaceLightPos0.xyz);
                float3 normal=normalize(i.normal);
                float diffuse = dot( normal , lightPos);
                return float4(diffuse.xxx,1);
            }
            
            ENDCG
        }
        
        
        
        
         Pass {	
         Tags { "LightMode" = "ForwardAdd" } 
            // pass for additional light sources
         Blend One One // additive blending 
 
         CGPROGRAM
 
         #pragma vertex vert  
         #pragma fragment frag 
 
         #include "UnityCG.cginc"
 
         uniform float4 _LightColor0; 
            // color of light source (from "UnityLightingCommon.cginc")
 
         uniform float4 _Color; // define shader property for shaders
 
         struct vertexInput {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 col : COLOR;
         };
 
         vertexOutput vert(vertexInput input) 
         {
            vertexOutput output;
 
            float4x4 modelMatrix = unity_ObjectToWorld;
            float4x4 modelMatrixInverse = unity_WorldToObject; 
 
            float3 normalDirection = normalize(
               mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);
            float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
 
            float3 diffuseReflection = _LightColor0.rgb 
               * max(0.0, dot(normalDirection, lightDirection));
 
            output.col = float4(diffuseReflection, 1.0);
            output.pos = UnityObjectToClipPos(input.vertex);
            return output;
         }
 
         float4 frag(vertexOutput input) : COLOR
         {
            return input.col;
         }
 
         ENDCG
      }
      
      
      
      
      
      
    }
    Fallback "Diffuse"
}
