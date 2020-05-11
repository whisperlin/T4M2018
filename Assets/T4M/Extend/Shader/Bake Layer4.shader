
Shader "T4M/Tool/Bake 4 Layer"
{
	Properties{
		_Splat0("Layer 1", 2D) = "white" {}
		_Splat1("Layer 2", 2D) = "white" {}
		_Splat2("Layer 3", 2D) = "white" {}
		_Splat3("Layer 4", 2D) = "white" {}
		_Tiling3("_Tiling4 x/y", Vector) = (1,1,0,0)
		_Control("Control (RGBA)", 2D) = "white" {}
		_MainTex("Never Used", 2D) = "white" {}
		_PixInU("_PixInU",Float) = 0.01
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
			sampler2D _Splat0, _Splat1, _Splat2, _Splat3;
			float4   _Splat0_ST, _Splat1_ST, _Splat2_ST, _Splat3_ST;

			float4 _Tiling3;
			float _PixInU;
			fixed4 frag(v2f i) : SV_Target
			{
			 
				//_PixInU = _PixInU * 180;

				//_PixInU = 0.0009765625 * 30;
				float2 uv;
				uv = i.uv;
				float count = 4;
				float invCount = 1 / count;
				float u0 = frac(i.uv.x * 4);
				_PixInU = _PixInU * count;
				
				float4 c0 = 1;
				u0 = saturate(u0);
				/*if (u0 < _PixInU)
				{
					c0 = float4(1, 0, 0, 1);
				}
				if (u0 > 1.0 - _PixInU)
				{
					c0 = float4(0, 1, 0, 1);
				}*/
				//u0 = u0 / (1.0- _PixInU) ;
				u0 = (u0 - _PixInU) / (1.0 - _PixInU*2);
			 
				u0 = saturate(u0);
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
				else
				{
					return tex2D(_Splat3, uv0)*c0;
				}
			}
			ENDCG
		}
	}
}
