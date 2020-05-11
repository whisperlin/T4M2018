Shader "T4MShaders/ShaderModel3/BumpSpec/T4M 4 Textures Bump Spec Conbinded" {
Properties {
	_SpecColor ("Specular Color", Color) = (1, 1, 1, 1)
	_ShininessL0 ("Layer1Shininess", Range (0.03, 1)) = 0.078125
	_Splat ("Layer 4 in one (R)", 2D) = "white" {}
	_ShininessL1 ("Layer2Shininess", Range (0.03, 1)) = 0.078125
	_ShininessL2 ("Layer3Shininess", Range (0.03, 1)) = 0.078125
	_ShininessL3 ("Layer4Shininess", Range (0.03, 1)) = 0.078125
	 
	_BumpSplat ("Layer1Normalmap 4 in One", 2D) = "bump" {}
	_Tiling0("_Tiling1 x/y", Vector) = (1,1,0,0)
	_Tiling1("_Tiling1 x/y", Vector) = (1,1,0,0)
	_Tiling2("_Tiling2 x/y", Vector) = (1,1,0,0)
	_Tiling3("_Tiling3 x/y", Vector) = (1,1,0,0)
	_Control ("Control (RGBA)", 2D) = "white" {}
	_MainTex ("Never Used", 2D) = "white" {}
} 

SubShader {
	Tags {
		"SplatCount" = "4"
		"Queue" = "Geometry-100"
		"RenderType" = "Opaque"
	}
CGPROGRAM
#pragma surface surf BlinnPhong vertex:vert
#pragma target 3.0
#include "UnityCG.cginc"

struct Input {
	float3 worldPos;
	float2 uv_Control : TEXCOORD0;
 
	 
};

void vert (inout appdata_full v) {

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
sampler2D _BumpSplat;
sampler2D _Splat;
fixed _ShininessL0;
fixed _ShininessL1;
fixed _ShininessL2;
fixed _ShininessL3;
float4 _Tiling0;
float4 _Tiling1;
float4 _Tiling2;
float4 _Tiling3;
float4 _Splat_TexelSize;


void surf(Input IN, inout SurfaceOutput o) {

	half4 splat_control = tex2D(_Control, IN.uv_Control);
	half3 col;

	half2 uv0 = IN.uv_Control* _Tiling0.xy + _Tiling0.zw;
	half2 uv1 = IN.uv_Control* _Tiling1.xy + _Tiling1.zw;
	half2 uv2 = IN.uv_Control* _Tiling2.xy + _Tiling2.zw;
	half2 uv3 = IN.uv_Control* _Tiling3.xy + _Tiling3.zw;
	uv0.x = frac(uv0.x);
	uv1.x = frac(uv1.x);
	uv2.x = frac(uv2.x);
	uv3.x = frac(uv3.x);

	float _PixInU = _Splat_TexelSize.x*4;
	uv0.x = (uv0.x - _PixInU) / (1.0 - _PixInU * 2);
	uv0.x = uv0.x*0.25;
	
	
	uv1.x = (uv1.x - _PixInU) / (1.0 - _PixInU * 2);
	uv1.x = uv1.x*0.25 + 0.25;
	
	uv2.x = (uv2.x - _PixInU) / (1.0 - _PixInU * 2);

	uv2.x = uv2.x*0.25 + 0.5;
	
	uv3.x = (uv3.x - _PixInU) / (1.0 - _PixInU * 2);
	uv3.x = uv3.x*0.25 + 0.75;
	
	
	half4 splat0 = tex2D(_Splat, uv0);
	half4 splat1 = tex2D(_Splat, uv1);
	half4 splat2 = tex2D(_Splat, uv2);
	half4 splat3 = tex2D(_Splat, uv3);



	col = splat_control.r * splat0.rgb;
	o.Normal = splat_control.r *  UnpackNormal(tex2D(_BumpSplat, uv0));


	col += splat_control.g * splat1.rgb;
	o.Normal += splat_control.g *  UnpackNormal(tex2D(_BumpSplat, uv1));

	col += splat_control.b * splat2.rgb;
	o.Normal += splat_control.b *  UnpackNormal(tex2D(_BumpSplat, uv2));

	col += splat_control.a * splat3.rgb;
	o.Normal += splat_control.a *  UnpackNormal(tex2D(_BumpSplat, uv3));

	o.Albedo = col;
	o.Alpha = 0.0;
}
 
ENDCG  
}
FallBack "Specular"
}