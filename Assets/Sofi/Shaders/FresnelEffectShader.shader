// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FresnelEffect"
{
	Properties
	{
		_Color0("Color 0", Color) = (0,1,0.9294465,0)
		_LerpValue("LerpValue", Range( 0 , 1)) = 0.94
		_FresnelPower("FresnelPower", Range( 0 , 1)) = 1
		_LerpTime("LerpTime", Range( 0 , 3)) = 3
		_LerpAlpha("LerpAlpha", Range( 0 , 1)) = 0.94
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+3000" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		ZTest Greater
		Blend One One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow nometa noforwardadd 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _Color0;
		uniform float _LerpTime;
		uniform float _LerpValue;
		uniform float _LerpAlpha;
		uniform float _FresnelPower;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float mulTime53 = _Time.y * _LerpTime;
			float lerpResult45 = lerp( sin( mulTime53 ) , _LerpValue , _LerpAlpha);
			float fresnelNdotV47 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode47 = ( 0.0 + lerpResult45 * pow( 1.0 - fresnelNdotV47, _FresnelPower ) );
			o.Emission = saturate( ( _Color0 * fresnelNode47 ) ).rgb;
			o.Alpha = fresnelNode47;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
218.4;73.6;322.8;442.2;1121.882;-31.05525;1.3;False;False
Node;AmplifyShaderEditor.RangedFloatNode;55;-1434.128,168.6709;Inherit;False;Property;_LerpTime;LerpTime;4;0;Create;True;0;0;0;False;0;False;3;3;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;53;-1124.857,169.564;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;54;-942.2547,170.6708;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1089.991,253.1387;Inherit;False;Property;_LerpValue;LerpValue;1;0;Create;True;0;0;0;False;0;False;0.94;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-1075.448,347.4733;Inherit;False;Property;_LerpAlpha;LerpAlpha;5;0;Create;True;0;0;0;False;0;False;0.94;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;45;-670.4987,152.5896;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-783.4072,431.8327;Inherit;False;Property;_FresnelPower;FresnelPower;3;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;48;-323.2307,-42.1348;Inherit;False;Property;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0,1,0.9294465,0;0,1,0.9294465,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;47;-403.9339,181.7859;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-47.16621,69.00171;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;50;148.5505,71.22575;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;397.4711,-33.3781;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;FresnelEffect;False;False;False;False;False;False;False;False;False;False;True;True;False;False;False;True;False;False;False;False;False;Back;2;False;-1;2;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;3000;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;4;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;53;0;55;0
WireConnection;54;0;53;0
WireConnection;45;0;54;0
WireConnection;45;1;46;0
WireConnection;45;2;56;0
WireConnection;47;2;45;0
WireConnection;47;3;51;0
WireConnection;49;0;48;0
WireConnection;49;1;47;0
WireConnection;50;0;49;0
WireConnection;0;2;50;0
WireConnection;0;9;47;0
ASEEND*/
//CHKSM=3B1CAED0942FA6C4DB4DAD71DD47882BD41F7A91