Shader "T4M/Tool/Baked 4"
{
	Properties{
		_Splat0("Layer 1", 2D) = "white" {}
		_Splat1("Layer 2", 2D) = "white" {}
		_Splat2("Layer 3", 2D) = "white" {}
		_Splat3("Layer 4", 2D) = "white" {}
 
		_Control("Control (RGBA)", 2D) = "white" {}
		_MainTex("Never Used", 2D) = "white" {}
	}
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
			sampler2D _Control;
			sampler2D _Splat0, _Splat1, _Splat2, _Splat3;
			float4   _Splat0_ST, _Splat1_ST, _Splat2_ST, _Splat3_ST;

			float4 _Tiling3;

            fixed4 frag (v2f i) : SV_Target
            {
				half4 splat_control = tex2D(_Control, i.uv);
				half4 col;
				half4 splat0 = tex2D(_Splat0, TRANSFORM_TEX(i.uv, _Splat0) );
				half4 splat1 = tex2D(_Splat1, TRANSFORM_TEX(i.uv, _Splat1) );
				half4 splat2 = tex2D(_Splat2, TRANSFORM_TEX(i.uv, _Splat2) );
				half4 splat3 = tex2D(_Splat3, TRANSFORM_TEX(i.uv, _Splat3));
				col.rgb = splat_control.r * splat0.rgb + splat_control.g * splat1.rgb + splat_control.b * splat2.rgb + splat_control.a * splat3.rgb;
				
				col.a = 1;
                return col;
            }
            ENDCG
        }
    }
}
