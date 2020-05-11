Shader "T4MShaders/ShaderModel3/BumpSpec/T4M 6 Textures Bump Spec Conbinded" {
	Properties{
		_SpecColor("Specular Color", Color) = (1, 1, 1, 1)

		_Splat("Layer 4 in one (R)", 2D) = "white" {}
		_ShininessL0("Layer1Shininess", Range(0.03, 1)) = 0.078125
		_ShininessL1("Layer2Shininess", Range(0.03, 1)) = 0.078125
		_ShininessL2("Layer3Shininess", Range(0.03, 1)) = 0.078125
		_ShininessL3("Layer4Shininess", Range(0.03, 1)) = 0.078125
		_ShininessL4("Layer4Shininess", Range(0.03, 1)) = 0.078125
		_ShininessL5("Layer4Shininess", Range(0.03, 1)) = 0.078125


		_Gloss0("Gloss0", Range(0, 1)) = 0
		_Gloss1("Gloss1", Range(0, 1)) = 0
		_Gloss2("Gloss2", Range(0, 1)) = 0
		_Gloss3("Gloss3", Range(0, 1)) = 0
		_Gloss4("Gloss4", Range(0, 1)) = 0
		_Gloss5("Gloss5", Range(0, 1)) = 0

		_BumpSplat("Layer1Normalmap 4 in One", 2D) = "bump" {}
		_Tiling0("_Tiling1 x/y", Vector) = (1,1,0,0)
		_Tiling1("_Tiling1 x/y", Vector) = (1,1,0,0)
		_Tiling2("_Tiling2 x/y", Vector) = (1,1,0,0)
		_Tiling3("_Tiling3 x/y", Vector) = (1,1,0,0)
		_Tiling4("_Tiling4 x/y", Vector) = (1,1,0,0)
		_Tiling5("_Tiling5 x/y", Vector) = (1,1,0,0)
		_Control("Control (RGBA)", 2D) = "white" {}
		_Control2("Control (RGBA)", 2D) = "black" {}
		_MainTex("Never Used", 2D) = "white" {}
	}

		SubShader{
			Tags {
				"SplatCount" = "4"
				"Queue" = "Geometry-100"
				"RenderType" = "Opaque"
			}
		CGPROGRAM
		#pragma surface surf_new BlinnPhong vertex:vert
		#pragma target 3.0
		#include "UnityCG.cginc"

		struct Input {
			float3 worldPos;
			float2 uv_Control : TEXCOORD0;


		};

		void vert(inout appdata_full v) {

			float3 T1 = float3(1, 0, 1);
			float3 Bi = cross(T1, v.normal);
			float3 newTangent = cross(v.normal, Bi);

			normalize(newTangent);

			v.tangent.xyz = newTangent.xyz;

			if (dot(cross(v.normal,newTangent),Bi) < 0)
				v.tangent.w = -1.0f;
			else
				v.tangent.w = 1.0f;
		}

		sampler2D _Control;
		sampler2D _Control2;
		sampler2D _BumpSplat;
		sampler2D _Splat;
		fixed _ShininessL0;
		fixed _ShininessL1;
		fixed _ShininessL2;
		fixed _ShininessL3;
		fixed _ShininessL4;
		fixed _ShininessL5;

		fixed _Gloss0;
		fixed _Gloss1;
		fixed _Gloss2;
		fixed _Gloss3;
		fixed _Gloss4;
		fixed _Gloss5;

		float4 _Tiling0;
		float4 _Tiling1;
		float4 _Tiling2;
		float4 _Tiling3;
		float4 _Tiling4;
		float4 _Tiling5;
		float4 _Splat_TexelSize;


		
		void surf_new(Input IN, inout SurfaceOutput o) {

			half4 splat_control = tex2D(_Control, IN.uv_Control);
			half4 splat_control2 = tex2D(_Control2, IN.uv_Control);
			half3 col;
			half2 uv0 = IN.uv_Control* _Tiling0.xy + _Tiling0.zw;
			half2 uv1 = IN.uv_Control* _Tiling1.xy + _Tiling1.zw;
			half2 uv2 = IN.uv_Control* _Tiling2.xy + _Tiling2.zw;
			half2 uv3 = IN.uv_Control* _Tiling3.xy + _Tiling3.zw;
			half2 uv4 = IN.uv_Control* _Tiling4.xy + _Tiling4.zw;
			half2 uv5 = IN.uv_Control* _Tiling5.xy + _Tiling5.zw;
 
			uv0.x = frac(uv0.x);
			uv1.x = frac(uv1.x);
			uv2.x = frac(uv2.x);
			uv3.x = frac(uv3.x);
			uv4.x = frac(uv4.x);
			uv5.x = frac(uv5.x); 
 
			float deltaLen0 = 1.0 / 7.0;
			float deltaLen = 1.0 / 8.0;
			float _PixInU = 1.0 / 112.0 ;
 
			uv0.x = _PixInU + uv0.x*deltaLen;
			uv1.x = _PixInU + uv1.x*deltaLen + deltaLen0 * 1;
			uv2.x = _PixInU + uv2.x*deltaLen + deltaLen0 * 2;
			uv3.x = _PixInU + uv3.x*deltaLen + deltaLen0 * 3;
			uv4.x = _PixInU + uv4.x*deltaLen + deltaLen0 * 4;
			uv5.x = _PixInU + uv5.x*deltaLen + deltaLen0 * 5;


			half4 splat0 = tex2D(_Splat, uv0);
			half4 splat1 = tex2D(_Splat, uv1);
			half4 splat2 = tex2D(_Splat, uv2);
			half4 splat3 = tex2D(_Splat, uv3);
			half4 splat4 = tex2D(_Splat, uv4);
			half4 splat5 = tex2D(_Splat, uv5);
		 
			col = splat_control.r * splat0.rgb;
			o.Normal = splat_control.r * UnpackNormal(tex2D(_BumpSplat, uv0));
			o.Gloss = splat0.a * splat_control.r*_Gloss0;
			o.Specular = _ShininessL0 * splat_control.r;

			col += splat_control.g * splat1.rgb;
			o.Normal += splat_control.g * UnpackNormal(tex2D(_BumpSplat, uv1));
			o.Gloss += splat1.a * splat_control.g*_Gloss1;
			o.Specular += _ShininessL1 * splat_control.g;

			col += splat_control.b * splat2.rgb;
			o.Normal += splat_control.b * UnpackNormal(tex2D(_BumpSplat, uv2));
			o.Gloss += splat2.a * splat_control.b*_Gloss2;
			o.Specular += _ShininessL2 * splat_control.b;

			col += splat_control.a * splat3.rgb;
			o.Normal += splat_control.a * UnpackNormal(tex2D(_BumpSplat, uv3));
			o.Gloss += splat3.a * splat_control2.r*_Gloss3;
			o.Specular += _ShininessL3 * splat_control.a;

			col += splat_control2.r * splat4.rgb;
			o.Normal += splat_control2.r * UnpackNormal(tex2D(_BumpSplat, uv4));
			o.Gloss += splat4.a * splat_control2.g*_Gloss4;
			o.Specular += _ShininessL4 * splat_control2.r;


		 

			 
			col += splat_control2.g * splat5.rgb;
			o.Normal += splat_control2.g * UnpackNormal(tex2D(_BumpSplat, splat5));
			o.Gloss += splat5.a * splat_control.a*_Gloss5;
			o.Specular += _ShininessL5 * splat_control2.g;
			
			//o.Gloss = 0;
			o.Albedo = col;
			o.Alpha = 0.0;
		}
		ENDCG
	}
		FallBack "Specular"
}