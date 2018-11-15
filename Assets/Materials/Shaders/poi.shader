// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "poi"
{
	Properties
	{
		_ColorBG("Color BG", Color) = (1,0,0,0)
		_ColorTop("Color Top", Color) = (0,1,0,0)
		_ExtrusionAmount("Extrusion Amount", Range( 0 , 0.25)) = 0.5
		_Speed("Speed", Range( -1 , 1)) = 0.5
		_Frequency("Frequency", Range( 0 , 50)) = 45
		_Magnitude("Magnitude", Range( -5 , 5)) = 0.35
		_opac("opac", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		AlphaToMask On
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float4 vertexColor : COLOR;
		};

		uniform float _Frequency;
		uniform float _Speed;
		uniform float _Magnitude;
		uniform float _ExtrusionAmount;
		uniform half4 _ColorBG;
		uniform half4 _ColorTop;
		uniform float _opac;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float mulTime40 = _Time.y * _Speed;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_8_0 = ( sin( ( _Frequency * ( mulTime40 + ase_vertex3Pos.z ) ) ) / ( 1.0 / _Magnitude ) );
			float3 lerpResult91 = lerp( float3(0,0,0) , ( ase_vertexNormal * max( ( temp_output_8_0 * _ExtrusionAmount ) , 0.0 ) ) , v.color.a);
			v.vertex.xyz += lerpResult91;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime40 = _Time.y * _Speed;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float temp_output_8_0 = ( sin( ( _Frequency * ( mulTime40 + ase_vertex3Pos.z ) ) ) / ( 1.0 / _Magnitude ) );
			float4 lerpResult29 = lerp( _ColorBG , _ColorTop , temp_output_8_0);
			float4 lerpResult115 = lerp( lerpResult29 , _ColorTop , i.vertexColor.g);
			o.Emission = lerpResult115.rgb;
			float lerpResult55 = lerp( 1.0 , temp_output_8_0 , i.vertexColor.a);
			float lerpResult112 = lerp( 0.0 , ( lerpResult55 * ( 1.0 - ( 0.5 * i.vertexColor.g ) ) ) , _opac);
			float clampResult111 = clamp( lerpResult112 , 0.0 , 1.0 );
			o.Alpha = clampResult111;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
-1914;58;1908;1016;-1959.513;1250.903;1.3;True;True
Node;AmplifyShaderEditor.RangedFloatNode;3;-324.0918,-1111.564;Float;False;Property;_Speed;Speed;4;0;Create;True;0;0;False;0;0.5;-0.053;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;36;89.70632,-953.8698;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;40;97.85843,-1092.579;Float;False;1;0;FLOAT;1.45;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;320.4607,-1290.26;Float;False;Property;_Frequency;Frequency;5;0;Create;True;0;0;False;0;45;28.9;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2;453.3195,-1087.668;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;75;1810.353,-1075.352;Float;False;822.5247;539.7252;Apply only where VAlpha > 0;4;55;54;119;121;Vertex Color Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;826.5846,-1106.884;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;685.6084,-738.623;Float;False;Property;_Magnitude;Magnitude;6;0;Create;True;0;0;False;0;0.35;0.72;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;54;1837.084,-820.2236;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;9;1139.889,-762.2191;Float;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;7;1142.629,-1099.293;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;2191.289,-730.2129;Float;False;2;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;1455.513,871.5708;Float;False;Property;_ExtrusionAmount;Extrusion Amount;3;0;Create;True;0;0;False;0;0.5;0.075;0;0.25;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;8;1393.113,-919.8052;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;119;2409.51,-693.2589;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;55;2189.12,-936.5366;Float;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;1858.576,689.9665;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;3012.01,-508.6386;Float;False;Property;_opac;opac;7;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;89;2225.276,333.856;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;27;1648.572,-2010.844;Half;False;Property;_ColorTop;Color Top;2;0;Create;True;0;0;False;0;0,1,0,0;0.2694637,0.3487177,0.6544118,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;88;2229.014,686.5456;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;2872.982,-799.8691;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;1646.156,-2195.942;Half;False;Property;_ColorBG;Color BG;1;0;Create;True;0;0;False;0;1,0,0,0;0.275431,0.4115636,0.7344827,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;112;3437.79,-675.8569;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;29;2170.77,-2086.769;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;2581.703,475.9323;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;92;2586.855,109.6121;Float;False;Constant;_Vector0;Vector 0;9;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;111;3626.678,-678.1475;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;115;2641.296,-1842.607;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;91;3025.01,-34.37638;Float;False;3;0;FLOAT3;1,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;34;4015.13,-797.4305;Float;False;True;0;Float;ASEMaterialInspector;0;0;Unlit;poi;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;40;0;3;0
WireConnection;2;0;40;0
WireConnection;2;1;36;3
WireConnection;4;0;5;0
WireConnection;4;1;2;0
WireConnection;9;1;11;0
WireConnection;7;0;4;0
WireConnection;121;1;54;2
WireConnection;8;0;7;0
WireConnection;8;1;9;0
WireConnection;119;0;121;0
WireConnection;55;1;8;0
WireConnection;55;2;54;4
WireConnection;97;0;8;0
WireConnection;97;1;85;0
WireConnection;88;0;97;0
WireConnection;120;0;55;0
WireConnection;120;1;119;0
WireConnection;112;1;120;0
WireConnection;112;2;114;0
WireConnection;29;0;28;0
WireConnection;29;1;27;0
WireConnection;29;2;8;0
WireConnection;90;0;89;0
WireConnection;90;1;88;0
WireConnection;111;0;112;0
WireConnection;115;0;29;0
WireConnection;115;1;27;0
WireConnection;115;2;54;2
WireConnection;91;0;92;0
WireConnection;91;1;90;0
WireConnection;91;2;54;4
WireConnection;34;2;115;0
WireConnection;34;9;111;0
WireConnection;34;11;91;0
ASEEND*/
//CHKSM=3625CB9AA403B85F4D8AED4FEFFFEC0C518C0D70