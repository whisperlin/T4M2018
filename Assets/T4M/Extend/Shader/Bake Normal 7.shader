
Shader "T4M/Tool/Bake n Normal"
{
	Properties{
		_BumpSplat0("Layer 1", 2D) = "dump" {}
		_BumpSplat1("Layer 2", 2D) = "dump" {}
		_BumpSplat2("Layer 3", 2D) = "dump" {}
		_BumpSplat3("Layer 4", 2D) = "dump" {}
		_BumpSplat4("Layer 5", 2D) = "dump" {}
		_BumpSplat5("Layer 6", 2D) = "dump" {}
		_BumpSplat6("Layer 7", 2D) = "dump" {}
 
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
				sampler2D _BumpSplat0, _BumpSplat1, _BumpSplat2, _BumpSplat3, _BumpSplat4, _BumpSplat5, _BumpSplat6;
				float4   _BumpSplat0_ST, _BumpSplat1_ST, _BumpSplat2_ST, _BumpSplat3_ST, _BumpSplat4_ST, _BumpSplat5_ST, _BumpSplat6_ST;

				float4 _Tiling3;
				float _PixInU;
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
						//u0 = 0;
						c0 = float4(1, 0, 0, 1);
					}*/
					float _len = 1 - invCount;
					/*if (u0 > _len+ delta)
					{

						c0 = float4(0, 1, 0, 1);
					}*/

					u0 = (u0 - delta) / _len;

					//u0 = saturate(u0);
					float2 uv0 = float2(u0,i.uv.y);
					if (uv.x < invCount)
					{
 
						float4 c1 = tex2D(_BumpSplat0, uv0)*c0; 
						c1.xyz = UnpackNormal(c1);
						c1 = (c1 + 1)*0.5f;
						c1.w = 1;

						return c1;
					}
					else if (uv.x < invCount * 2)
					{
						float4 c1 = tex2D(_BumpSplat1, uv0)*c0;
						c1.xyz = UnpackNormal(c1);
						c1 = (c1 + 1)*0.5f;
						c1.w = 1;
						return c1;
					}
					else if (uv.x < invCount * 3)
					{
						float4 c1 = tex2D(_BumpSplat2, uv0)*c0;
						c1.xyz = UnpackNormal(c1); 
						c1 = (c1 + 1)*0.5f;
						c1.w = 1;
						return c1;
					}
					else if (uv.x < invCount * 4)
					{
						float4 c1 = tex2D(_BumpSplat3, uv0)*c0;
						c1.xyz = UnpackNormal(c1);
						c1 = (c1 + 1)*0.5f;
						c1.w = 1;
						return c1;
					}
					else if (uv.x < invCount * 5)
					{
						float4 c1 = tex2D(_BumpSplat4, uv0)*c0;
						c1.xyz = UnpackNormal(c1);
						c1 = (c1 + 1)*0.5f;
						c1.w = 1;
						return c1;
					}
					else if (uv.x < invCount * 6)
					{
						float4 c1 = tex2D(_BumpSplat5, uv0)*c0;
						c1.xyz = UnpackNormal(c1);
						c1 = (c1 + 1)*0.5f;
						c1.w = 1;
						return c1;
					}
					else 
					{
						float4 c1 = tex2D(_BumpSplat4, uv0)*c0;
						c1.xyz = UnpackNormal(c1);
						c1 = (c1 + 1)*0.5f;
						c1.w = 1;
						return c1;
					}
				}
				ENDCG
			}
		}
}


 