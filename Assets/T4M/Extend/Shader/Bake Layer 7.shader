
Shader "T4M/Tool/Bake n Layer"
{
	Properties{
		_Splat0("Layer 1", 2D) = "white" {}
		_Splat1("Layer 2", 2D) = "white" {}
		_Splat2("Layer 3", 2D) = "white" {}
		_Splat3("Layer 4", 2D) = "white" {}
		_Splat4("Layer 5", 2D) = "white" {}
		_Splat5("Layer 6", 2D) = "white" {}
		_Splat6("Layer 7", 2D) = "white" {}
		_Tiling3("_Tiling4 x/y", Vector) = (1,1,0,0)
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

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			sampler2D _Control;
			sampler2D _Splat0, _Splat1, _Splat2, _Splat3, _Splat4, _Splat5, _Splat6;
			float4   _Splat0_ST, _Splat1_ST, _Splat2_ST, _Splat3_ST, _Splat4_ST, _Splat5_ST, _Splat6_ST;

 
 
			fixed4 frag(v2f i) : SV_Target
			{
			 
				//_PixInU = _PixInU * 180;

				//_PixInU = 0.0009765625 * 30;
				float2 uv;
				uv = i.uv;
				float count = 7;
				float invCount = 1 / count;
				float u0 = frac(i.uv.x * count);
				float delta = invCount * 0.5f;
				float4 c0 = 1;
				/*if (u0 < delta)
				{
					u0 = 0;
					c0 = float4(1, 0, 0, 1);
				}*/
				float _len = 1 - invCount;
				/*if (u0 > _len+ delta)
				{
 
					c0 = float4(0, 1, 0, 1);
				}*/
					
				u0 = (u0- delta)/ _len;
				//u0 = saturate(u0);
 
				float2 uv0 = float2(u0,i.uv.y );
				if (uv.x < invCount)
				{
					return tex2D(_Splat0, uv0)*c0;
				}
				else if (uv.x < invCount * 2)
				{
					return tex2D(_Splat1, uv0)*c0;
				}
				else if (uv.x < invCount * 3)
				{
					return tex2D(_Splat2, uv0)*c0;
				}
				else if (uv.x < invCount * 4)
				{
					return tex2D(_Splat3, uv0)*c0;
				}
				else if (uv.x < invCount * 5)
				{
					return tex2D(_Splat4, uv0)*c0;
				}
				else if (uv.x < invCount * 6)
				{
					return tex2D(_Splat5, uv0)*c0;
				}
				else  
				{
					return tex2D(_Splat6, uv0)*c0;
				}
			}
			ENDCG
		}
	}
}
