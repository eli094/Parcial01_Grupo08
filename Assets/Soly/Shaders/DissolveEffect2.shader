// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DissolveEffect2"
{
	Properties
	{
		_MeshColor("MeshColor", Color) = (0,0,0,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Dissolve("Dissolve", 2D) = "white" {}
		_DissolveProximity("DissolveProximity", Range( 0 , 1)) = 0
		_Edge("Edge", Range( 0 , 10)) = 2.741176
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _MeshColor;
		uniform float _Edge;
		uniform sampler2D _Dissolve;
		uniform float4 _Dissolve_ST;
		uniform float _DissolveProximity;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _MeshColor.rgb;
			float2 uv_Dissolve = i.uv_texcoord * _Dissolve_ST.xy + _Dissolve_ST.zw;
			float4 tex2DNode3 = tex2D( _Dissolve, uv_Dissolve );
			float4 temp_cast_1 = (_DissolveProximity).xxxx;
			float4 color41 = IsGammaSpace() ? float4(0.2973431,0.2311321,1,0) : float4(0.07193031,0.04364694,1,0);
			o.Emission = ( ( _Edge * ( tex2DNode3 - temp_cast_1 ) ) * color41 ).rgb;
			o.Alpha = 1;
			clip( ( (-0.6 + (( 1.0 - _DissolveProximity ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + tex2DNode3 ).r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
192;73;874;486;860.4396;567.8986;2.166189;False;False
Node;AmplifyShaderEditor.SamplerNode;3;-771.382,191.1057;Inherit;True;Property;_Dissolve;Dissolve;2;0;Create;True;0;0;0;False;0;False;-1;e28dc97a9541e3642a48c0e3886688c5;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;50;-465.7604,-63.95345;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-795.0593,75.84163;Inherit;False;Property;_DissolveProximity;DissolveProximity;3;0;Create;True;0;0;0;False;0;False;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-444.2675,-210.5612;Inherit;False;Property;_Edge;Edge;4;0;Create;True;0;0;0;False;0;False;2.741176;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;41;-303.9133,-392.7524;Inherit;False;Constant;_GlowColor;GlowColor;4;0;Create;True;0;0;0;False;0;False;0.2973431,0.2311321,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;37;-403.0931,91.05342;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;40;-332.6182,-122.1043;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;39;-195.4076,64.56481;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;52;230.4533,-142.7363;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;30.23898,-104.4892;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;320.2421,-92.9596;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;14;335.2031,-299.1458;Inherit;False;Property;_MeshColor;MeshColor;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2547162,0.0708876,0.2297239,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;38;65.62888,171.9133;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;45;220.2456,46.87053;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;48;465.7957,135.2326;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;789.2661,-70.72448;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;DissolveEffect2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;0;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;50;0;3;0
WireConnection;37;0;4;0
WireConnection;40;0;50;0
WireConnection;40;1;4;0
WireConnection;39;0;37;0
WireConnection;52;0;41;0
WireConnection;42;0;44;0
WireConnection;42;1;40;0
WireConnection;46;0;42;0
WireConnection;46;1;52;0
WireConnection;38;0;39;0
WireConnection;38;1;3;0
WireConnection;0;0;14;0
WireConnection;0;2;46;0
WireConnection;0;10;38;0
ASEEND*/
//CHKSM=B0ACA43178895DDB357D5FE0976906BC44B0FC27