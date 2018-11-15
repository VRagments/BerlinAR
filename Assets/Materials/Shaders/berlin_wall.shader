// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "berlin_wall"
{
	Properties
	{
		_basecolor("basecolor", 2D) = "white" {}
		_normal("normal", 2D) = "bump" {}
		_smoothness("smoothness", 2D) = "white" {}
		_noise("noise", 2D) = "white" {}
		_speed("speed", Range( -3 , 3)) = 0
		_bottomrimcolor("bottom rim color", Color) = (0,0.2058823,1,0)
		_opac("opac", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma surface surf Standard keepalpha noshadow nolightmap  nodynlightmap nodirlightmap nofog 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _normal;
		uniform float4 _normal_ST;
		uniform sampler2D _basecolor;
		uniform float4 _basecolor_ST;
		uniform float4 _bottomrimcolor;
		uniform sampler2D _noise;
		uniform float _speed;
		uniform sampler2D _smoothness;
		uniform float4 _smoothness_ST;
		uniform float _opac;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_normal = i.uv_texcoord * _normal_ST.xy + _normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _normal, uv_normal ) );
			float2 uv_basecolor = i.uv_texcoord * _basecolor_ST.xy + _basecolor_ST.zw;
			o.Albedo = tex2D( _basecolor, uv_basecolor ).rgb;
			float mulTime22 = _Time.y * _speed;
			float2 appendResult32 = (float2(0.0 , mulTime22));
			float2 uv_TexCoord27 = i.uv_texcoord * float2( 0.09,0.11 ) + appendResult32;
			float4 tex2DNode20 = tex2D( _noise, uv_TexCoord27 );
			float4 lerpResult24 = lerp( float4( 0,0,0,0 ) , _bottomrimcolor , tex2DNode20.r);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float clampResult18 = clamp( ase_vertex3Pos.z , 0.0 , 1.0 );
			float4 lerpResult38 = lerp( lerpResult24 , float4( 0,0,0,0 ) , clampResult18);
			o.Emission = lerpResult38.rgb;
			o.Metallic = 0.0;
			float2 uv_smoothness = i.uv_texcoord * _smoothness_ST.xy + _smoothness_ST.zw;
			o.Smoothness = tex2D( _smoothness, uv_smoothness ).r;
			float lerpResult35 = lerp( ase_vertex3Pos.z , 1.0 , ( tex2DNode20.r * 0.125 ));
			float clampResult13 = clamp( ( lerpResult35 + ase_vertex3Pos.z ) , 0.0 , 1.0 );
			o.Alpha = ( clampResult13 * _opac );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
-1914;58;1908;1016;1376.691;113.8375;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;26;-2655.927,-276.6204;Float;False;Property;_speed;speed;5;0;Create;True;0;0;False;0;0;0.0125;-3;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;22;-2362.688,-271.6382;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;34;-2139.852,-530.5467;Float;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;False;0;0.09,0.11;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;32;-2134.468,-298.7242;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-1914.973,-394.9493;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-1601.041,-416.0667;Float;True;Property;_noise;noise;4;0;Create;True;0;0;False;0;None;16d574e53541bba44a84052fa38778df;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1164.633,259.9637;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.125;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;9;-1177.725,574.3531;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;35;-890.686,499.7426;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-671.5037,602.0603;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.44;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-476.4023,-1265.076;Float;False;Property;_bottomrimcolor;bottom rim color;6;0;Create;True;0;0;False;0;0,0.2058823,1,0;0.3206897,0.1131846,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;24;-36.11223,-1056.903;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-562.0121,324.2648;Float;False;Property;_opac;opac;7;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;13;-473.516,604.9245;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;18;-466.7139,769.3356;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-599.3143,-438.6211;Float;True;Property;_basecolor;basecolor;1;0;Create;True;0;0;False;0;eb2de82e4cb3480468f918ed34fefd5c;eb2de82e4cb3480468f918ed34fefd5c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-580.3143,-219.6211;Float;True;Property;_normal;normal;2;0;Create;True;0;0;False;0;133d20f7f8befd9468087cef83950f03;133d20f7f8befd9468087cef83950f03;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;614.4348,-43.84312;Float;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;277.4437,184.6325;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;38;136.3912,-82.93539;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-562.3143,12.37891;Float;True;Property;_smoothness;smoothness;3;0;Create;True;0;0;False;0;e9361ac9f12c0854a829c7314109104f;e9361ac9f12c0854a829c7314109104f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1023.724,-106.3857;Float;False;True;0;Float;ASEMaterialInspector;0;0;Standard;berlin_wall;False;False;False;False;False;False;True;True;True;True;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;26;0
WireConnection;32;1;22;0
WireConnection;27;0;34;0
WireConnection;27;1;32;0
WireConnection;20;1;27;0
WireConnection;36;0;20;1
WireConnection;35;0;9;3
WireConnection;35;2;36;0
WireConnection;11;0;35;0
WireConnection;11;1;9;3
WireConnection;24;1;16;0
WireConnection;24;2;20;1
WireConnection;13;0;11;0
WireConnection;18;0;9;3
WireConnection;10;0;13;0
WireConnection;10;1;6;0
WireConnection;38;0;24;0
WireConnection;38;2;18;0
WireConnection;0;0;1;0
WireConnection;0;1;2;0
WireConnection;0;2;38;0
WireConnection;0;3;4;0
WireConnection;0;4;3;1
WireConnection;0;9;10;0
ASEEND*/
//CHKSM=806A3B4F864811888623992B3C81DC980F998F67