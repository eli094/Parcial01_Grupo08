// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ToonWater"
{
	Properties
	{
		_TimeScale("Time Scale", Range( 0 , 1)) = 0.2941177
		_HeightMultiplier("Height Multiplier", Vector) = (0,1,0,0)
		_Texture0("Texture 0", 2D) = "white" {}
		_Flowmap("Flowmap", 2D) = "white" {}
		_DistortionWeight("DistortionWeight", Range( 0 , 1)) = 0.1400807
		_FlowmapDirection("FlowmapDirection", Vector) = (1,1,0,0)
		_FlowmapPannerSpeed("FlowmapPannerSpeed", Range( 0 , 1)) = 0.4950396
		_FlowmapTilling("FlowmapTilling", Range( 0 , 1)) = 1
		_FadeColor("Fade Color", Color) = (1,1,1,0)
		_WaterColor("Water Color", Color) = (0.9575472,1,1,0)
		_Bias("Bias", Range( 0 , 1)) = 1
		_Scale("Scale", Range( 0 , 1)) = 1
		_Power("Power", Range( 0 , 10)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float _TimeScale;
		uniform float2 _FlowmapDirection;
		uniform float _FlowmapPannerSpeed;
		uniform float _FlowmapTilling;
		uniform sampler2D _Flowmap;
		uniform float4 _Flowmap_ST;
		uniform float _DistortionWeight;
		uniform float3 _HeightMultiplier;
		uniform float4 _WaterColor;
		uniform sampler2D _Texture0;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _Power;
		uniform float4 _FadeColor;


		float2 voronoihash2( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -2; j <= 2; j++ )
			{
				for ( int i = -2; i <= 2; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash2( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime1 = _Time.y * _TimeScale;
			float time2 = mulTime1;
			float2 temp_cast_0 = (_FlowmapTilling).xx;
			float2 uv_TexCoord25 = v.texcoord.xy * temp_cast_0;
			float2 uv_Flowmap = v.texcoord * _Flowmap_ST.xy + _Flowmap_ST.zw;
			float4 tex2DNode21 = tex2Dlod( _Flowmap, float4( uv_Flowmap, 0, 0.0) );
			float4 appendResult22 = (float4(tex2DNode21.r , tex2DNode21.g , 0.0 , 0.0));
			float4 lerpResult24 = lerp( float4( uv_TexCoord25, 0.0 , 0.0 ) , ( appendResult22 + float4( uv_TexCoord25, 0.0 , 0.0 ) ) , _DistortionWeight);
			float2 panner26 = ( 1.0 * _Time.y * ( _FlowmapDirection * _FlowmapPannerSpeed ) + lerpResult24.xy);
			float2 Distortion34 = panner26;
			float2 coords2 = Distortion34 * 1.0;
			float2 id2 = 0;
			float2 uv2 = 0;
			float fade2 = 0.5;
			float voroi2 = 0;
			float rest2 = 0;
			for( int it2 = 0; it2 <3; it2++ ){
			voroi2 += fade2 * voronoi2( coords2, time2, id2, uv2, 0 );
			rest2 += fade2;
			coords2 *= 2;
			fade2 *= 0.5;
			}//Voronoi2
			voroi2 /= rest2;
			v.vertex.xyz += ( voroi2 * _HeightMultiplier );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_FlowmapTilling).xx;
			float2 uv_TexCoord25 = i.uv_texcoord * temp_cast_0;
			float2 uv_Flowmap = i.uv_texcoord * _Flowmap_ST.xy + _Flowmap_ST.zw;
			float4 tex2DNode21 = tex2D( _Flowmap, uv_Flowmap );
			float4 appendResult22 = (float4(tex2DNode21.r , tex2DNode21.g , 0.0 , 0.0));
			float4 lerpResult24 = lerp( float4( uv_TexCoord25, 0.0 , 0.0 ) , ( appendResult22 + float4( uv_TexCoord25, 0.0 , 0.0 ) ) , _DistortionWeight);
			float2 panner26 = ( 1.0 * _Time.y * ( _FlowmapDirection * _FlowmapPannerSpeed ) + lerpResult24.xy);
			float2 Distortion34 = panner26;
			float mulTime1 = _Time.y * _TimeScale;
			float time2 = mulTime1;
			float2 coords2 = Distortion34 * 1.0;
			float2 id2 = 0;
			float2 uv2 = 0;
			float fade2 = 0.5;
			float voroi2 = 0;
			float rest2 = 0;
			for( int it2 = 0; it2 <3; it2++ ){
			voroi2 += fade2 * voronoi2( coords2, time2, id2, uv2, 0 );
			rest2 += fade2;
			coords2 *= 2;
			fade2 *= 0.5;
			}//Voronoi2
			voroi2 /= rest2;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth44 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth44 = abs( ( screenDepth44 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			float4 DepthFade53 = saturate( ( ( 1.0 - saturate( pow( ( ( distanceDepth44 + _Bias ) * _Scale ) , _Power ) ) ) * _FadeColor ) );
			o.Albedo = saturate( ( ( ( _WaterColor * tex2D( _Texture0, Distortion34 ) ) + voroi2 ) + DepthFade53 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
255;73;1326;622;1943.779;823.2678;1.768323;True;False
Node;AmplifyShaderEditor.CommentaryNode;73;-1153.342,957.4842;Inherit;False;1732.206;802.1564;For distortion effects and texture movement;13;20;34;26;24;33;32;30;23;28;22;25;27;21;Flowmap Distortion;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;20;-1051.185,1023.918;Inherit;True;Property;_Flowmap;Flowmap;6;0;Create;True;0;0;0;False;0;False;9712416f6a58f984b8af506ab02eee74;9712416f6a58f984b8af506ab02eee74;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;27;-796.6299,1265.7;Inherit;False;Property;_FlowmapTilling;FlowmapTilling;10;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-824.2998,1021.839;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-508.0081,1249.423;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;22;-469.5086,1046.853;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;63;-1150.108,320.5171;Inherit;False;1812.399;512.5513;For depth fade;13;53;60;58;59;50;49;48;47;52;51;45;44;46;Depth Fade;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;32;-495.7478,1504.234;Inherit;False;Property;_FlowmapDirection;FlowmapDirection;8;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;30;-561.3975,1642.529;Inherit;False;Property;_FlowmapPannerSpeed;FlowmapPannerSpeed;9;0;Create;True;0;0;0;False;0;False;0.4950396;0.4950396;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1083.008,503.7915;Inherit;False;Property;_Bias;Bias;13;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-503.6543,1379.413;Inherit;False;Property;_DistortionWeight;DistortionWeight;7;0;Create;True;0;0;0;False;0;False;0.1400807;0.1400807;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;44;-1039.008,379.7913;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-251.8078,1166.623;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-941.0079,602.7915;Inherit;False;Property;_Scale;Scale;14;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-725.008,447.7913;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-244.7008,1515.467;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;24;-119.3077,1262.723;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-582.008,454.7913;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-622.008,627.7915;Inherit;False;Property;_Power;Power;15;0;Create;True;0;0;0;False;0;False;1;5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;26;109.8334,1327.608;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;338.8432,1335.135;Inherit;False;Distortion;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;48;-427.0081,496.7915;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;49;-264.0081,506.7915;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-1233.25,-376.0559;Inherit;False;34;Distortion;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;50;-100.008,508.7915;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;40;-1018.677,-420.1484;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;59;-190.46,634.8276;Inherit;False;Property;_FadeColor;Fade Color;11;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;62.54007,525.8276;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;41;-845.0895,-456.6017;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1195.143,-272.0102;Inherit;False;Property;_TimeScale;Time Scale;0;0;Create;True;0;0;0;False;0;False;0.2941177;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;38;-1098.708,-655.0164;Inherit;True;Property;_Texture0;Texture 0;2;0;Create;True;0;0;0;False;0;False;3555f793cd0e64842ab481bc3b2cd6ad;3555f793cd0e64842ab481bc3b2cd6ad;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SaturateNode;60;234.5402,531.8276;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;39;-809.1589,-655.2769;Inherit;True;Property;_TextureSample2;Texture Sample 2;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;61;-783.4534,-865.2785;Inherit;False;Property;_WaterColor;Water Color;12;0;Create;True;0;0;0;False;0;False;0.9575472,1,1,0;0.9575472,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;1;-895.7518,-263.9482;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;2;-677.9969,-386.067;Inherit;True;1;0;1;0;3;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-479.5947,-637.897;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;414.0948,511.6298;Inherit;False;DepthFade;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-323.7705,-635.189;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-285.4278,-406.8526;Inherit;False;53;DepthFade;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;74;-2435.099,818.0411;Inherit;False;1167.621;600.3371;Comment;7;5;8;9;11;10;7;12;ERASE;1,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-28.00088,-490.7112;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;15;-692.0781,-84.52878;Inherit;False;Property;_HeightMultiplier;Height Multiplier;1;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-433.185,-132.8953;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-1521.636,971.0896;Inherit;False;Panner;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2365.506,1254.495;Inherit;False;Property;_PannerSpeed;PannerSpeed;4;0;Create;True;0;0;0;False;0;False;0.5474049;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;56;119.1463,-481.924;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;11;-2240.376,1117.445;Inherit;False;Property;_Direction;Direction;3;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;5;-2388.677,985.7057;Inherit;False;Property;_TextureTilling;TextureTilling;5;0;Create;True;0;0;0;False;0;False;0.3475744;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-2032.617,1110.691;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-2081.617,945.6912;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;10;-1796.133,938.5809;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;57;265.7988,-475.0738;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ToonWater;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;True;0;False;Opaque;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;20;0
WireConnection;25;0;27;0
WireConnection;22;0;21;1
WireConnection;22;1;21;2
WireConnection;23;0;22;0
WireConnection;23;1;25;0
WireConnection;45;0;44;0
WireConnection;45;1;46;0
WireConnection;33;0;32;0
WireConnection;33;1;30;0
WireConnection;24;0;25;0
WireConnection;24;1;23;0
WireConnection;24;2;28;0
WireConnection;47;0;45;0
WireConnection;47;1;51;0
WireConnection;26;0;24;0
WireConnection;26;2;33;0
WireConnection;34;0;26;0
WireConnection;48;0;47;0
WireConnection;48;1;52;0
WireConnection;49;0;48;0
WireConnection;50;0;49;0
WireConnection;40;0;35;0
WireConnection;58;0;50;0
WireConnection;58;1;59;0
WireConnection;41;0;40;0
WireConnection;60;0;58;0
WireConnection;39;0;38;0
WireConnection;39;1;41;0
WireConnection;1;0;13;0
WireConnection;2;0;35;0
WireConnection;2;1;1;0
WireConnection;62;0;61;0
WireConnection;62;1;39;0
WireConnection;53;0;60;0
WireConnection;42;0;62;0
WireConnection;42;1;2;0
WireConnection;54;0;42;0
WireConnection;54;1;55;0
WireConnection;16;0;2;0
WireConnection;16;1;15;0
WireConnection;12;0;10;0
WireConnection;56;0;54;0
WireConnection;9;0;11;0
WireConnection;9;1;7;0
WireConnection;8;0;5;0
WireConnection;10;0;8;0
WireConnection;10;2;9;0
WireConnection;57;0;56;0
WireConnection;57;11;16;0
ASEEND*/
//CHKSM=05030339B7B2536DF6B631CB2F235D3F9D3DEF47