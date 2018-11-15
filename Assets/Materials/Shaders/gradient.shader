// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "lor"
{
	Properties
	{
		_GradientMaxHeight("Gradient Max Height", Float) = 30
		_Rotation("Rotation", Range( -2 , 2)) = 0
		_GradientTop("Gradient Top", Color) = (0,1,0,0)
		_GradientBottom("Gradient Bottom", Color) = (1,0,0,0)
		_TopColor("Top Color", Color) = (0.1208824,0.172435,0.822,0)
		_TopColorOpacity("Top Color Opacity", Range( 0 , 1)) = 0
		_TopColorHeight("Top Color Height", Float) = -9
		_TopColorRimOpacity("Top Color Rim Opacity", Range( 0 , 1)) = 1
		_TopColorRimBlur("Top Color Rim Blur", Range( 0.25 , 5)) = 0
		_Posterize("Posterize", Float) = 0
		_opac("opac", Range( 0 , 1)) = 0.8
		_OpacityContrast("Opacity Contrast", Range( 0 , 3)) = 3
		_WorldspaceZOffset("Worldspace Z Offset", Float) = -2
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "DisableBatching" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred noambient nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform half _Posterize;
		uniform half4 _GradientBottom;
		uniform half4 _GradientTop;
		uniform half _WorldspaceZOffset;
		uniform half _Rotation;
		uniform half _GradientMaxHeight;
		uniform half4 _TopColor;
		uniform half _TopColorOpacity;
		uniform half _TopColorHeight;
		uniform half _TopColorRimOpacity;
		uniform half _TopColorRimBlur;
		uniform half _opac;
		uniform half _OpacityContrast;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float4 appendResult211 = (half4((ase_worldPos).x , ( ( _Rotation * (ase_worldPos).y ) - ( _Rotation * (ase_worldPos).z ) ) , ( ( _Rotation * (ase_worldPos).y ) + ( _Rotation * (ase_worldPos).z ) ) , 0.0));
			float clampResult26 = clamp( ( ( _WorldspaceZOffset + (( appendResult211 - half4( ase_worldPos , 0.0 ) )).z ) / _GradientMaxHeight ) , 0.0 , 1.0 );
			float4 lerpResult32 = lerp( _GradientBottom , _GradientTop , clampResult26);
			float div50=256.0/float((int)_Posterize);
			float4 posterize50 = ( floor( lerpResult32 * div50 ) / div50 );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float clampResult86 = clamp( ( _TopColorHeight + ase_vertex3Pos.z ) , 0.0 , 1.0 );
			half3 ase_worldNormal = i.worldNormal;
			half3 ase_normWorldNormal = normalize( ase_worldNormal );
			float temp_output_4_0 = abs( ase_normWorldNormal.z );
			float clampResult133 = clamp( ( clampResult86 - ( 1.0 * ( temp_output_4_0 * temp_output_4_0 ) ) ) , 0.0 , 1.0 );
			float temp_output_134_0 = ( _TopColorRimOpacity * pow( clampResult133 , _TopColorRimBlur ) );
			float4 lerpResult69 = lerp( posterize50 , _TopColor , ( ( _TopColorOpacity * clampResult86 ) + temp_output_134_0 ));
			o.Emission = lerpResult69.rgb;
			float temp_output_136_0 = ( temp_output_134_0 + _opac );
			float clampResult141 = clamp( ( temp_output_136_0 * temp_output_136_0 ) , 0.0 , 1.0 );
			o.Alpha = pow( clampResult141 , _OpacityContrast );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
-1931;31;1908;1016;6644.395;2360.384;2.647659;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;193;-6447.173,-1241.101;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;2;-3473.489,1493.964;Float;False;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;1;-3039.137,1490.932;Float;False;725.6512;309.7077;Get World Y Vector Mask;3;13;4;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;199;-5695.173,-1705.101;Float;False;False;True;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;201;-5631.173,-1017.101;Float;False;False;True;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;202;-5631.173,-793.1013;Float;False;False;False;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;194;-6815.173,-1929.101;Float;False;Property;_Rotation;Rotation;1;0;Create;True;0;0;False;0;0;-0.375;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;4;-3000.039,1564.079;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;203;-5695.173,-1481.101;Float;False;False;False;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;-5375.173,-1497.101;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;-5327.173,-809.1013;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;206;-5343.173,-1033.101;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;-5375.173,-1753.101;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;78;-2389.523,502.8463;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;81;-2360.405,257.1113;Float;False;Property;_TopColorHeight;Top Color Height;7;0;Create;True;0;0;False;0;-9;-9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-2789.461,1563.899;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;208;-5487.173,-2393.103;Float;False;True;False;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;13;-2567.654,1564.356;Float;False;False;True;False;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-2530.074,1196.609;Float;False;Constant;_TopColorRim;Top Color Rim;4;0;Create;True;0;0;False;0;1;20.7;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-2017.952,378.0989;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;210;-5071.173,-969.1013;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;209;-5119.173,-1625.101;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-2089.24,1421.024;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;211;-4618.473,-1662.254;Float;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;86;-1677.727,377.478;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;213;-4300.573,-1384.917;Float;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;83;-1397.313,915.5334;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;133;-1151.288,915.6962;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-1178.585,1208.418;Float;False;Property;_TopColorRimBlur;Top Color Rim Blur;9;0;Create;True;0;0;False;0;0;1.1;0.25;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;185;-3598.678,-1060.537;Float;False;False;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;-3606.656,-1396.091;Float;False;Property;_WorldspaceZOffset;Worldspace Z Offset;13;0;Create;True;0;0;False;0;-2;18.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;3;-3169.464,-1025.424;Float;False;970.8446;761.9433;Create the world gradient;4;49;20;26;144;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-825.9191,584.6945;Float;False;Property;_TopColorRimOpacity;Top Color Rim Opacity;8;0;Create;True;0;0;False;0;1;0.174;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;128;-804.2966,913.1027;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;144;-3082.85,-931.6747;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-3058.932,-526.9857;Float;False;Property;_GradientMaxHeight;Gradient Max Height;0;0;Create;True;0;0;False;0;30;-31.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;118.5338,446.3344;Float;False;Property;_opac;opac;11;0;Create;True;0;0;False;0;0.8;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;20;-2724.551,-831.8326;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-274.287,588.8358;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;124;-842.4748,39.07761;Float;False;Property;_TopColorOpacity;Top Color Opacity;6;0;Create;True;0;0;False;0;0;0.122;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;136;550.3214,199.0479;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;48;-1842.801,-1207.938;Half;False;Property;_GradientBottom;Gradient Bottom;4;0;Create;True;0;0;False;0;1,0,0,0;1,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;26;-2425.126,-777.1234;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;28;-1419.866,-787.894;Float;False;331.1761;277.9463;Lerp the Bottom and Top Colors according to the world gradient;1;32;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;47;-1846.503,-1003.562;Half;False;Property;_GradientTop;Gradient Top;2;0;Create;True;0;0;False;0;0,1,0,0;0,1,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-286.7013,200.9857;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1290.987,-456.6221;Float;False;Property;_Posterize;Posterize;10;0;Create;True;0;0;False;0;0;14.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;742.996,360.5443;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;32;-1369.866,-737.894;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;129;79.84299,198.5827;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;550.3242,581.2984;Float;False;Property;_OpacityContrast;Opacity Contrast;12;0;Create;True;0;0;False;0;3;0.95;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosterizeNode;50;-874.9533,-724.9355;Float;False;1;2;1;COLOR;0,0,0,0;False;0;INT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;70;76.34304,-40.78243;Float;False;Property;_TopColor;Top Color;5;0;Create;True;0;0;False;0;0.1208824,0.172435,0.822,0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;141;794.9492,195.9507;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;69;529.5107,-41.96607;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;138;981.8757,320.6107;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;44;1240.166,-86.84125;Half;False;True;0;Half;ASEMaterialInspector;0;0;Unlit;lor;False;False;False;False;True;False;True;True;True;True;True;True;False;True;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;2;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1.13;0,0,0,0;VertexScale;True;False;Cylindrical;False;Relative;0;;3;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;199;0;193;0
WireConnection;201;0;193;0
WireConnection;202;0;193;0
WireConnection;4;0;2;3
WireConnection;203;0;193;0
WireConnection;207;0;194;0
WireConnection;207;1;203;0
WireConnection;204;0;194;0
WireConnection;204;1;202;0
WireConnection;206;0;194;0
WireConnection;206;1;201;0
WireConnection;205;0;194;0
WireConnection;205;1;199;0
WireConnection;7;0;4;0
WireConnection;7;1;4;0
WireConnection;208;0;193;0
WireConnection;13;0;7;0
WireConnection;82;0;81;0
WireConnection;82;1;78;3
WireConnection;210;0;206;0
WireConnection;210;1;204;0
WireConnection;209;0;205;0
WireConnection;209;1;207;0
WireConnection;71;0;72;0
WireConnection;71;1;13;0
WireConnection;211;0;208;0
WireConnection;211;1;209;0
WireConnection;211;2;210;0
WireConnection;86;0;82;0
WireConnection;213;0;211;0
WireConnection;213;1;193;0
WireConnection;83;0;86;0
WireConnection;83;1;71;0
WireConnection;133;0;83;0
WireConnection;185;0;213;0
WireConnection;128;0;133;0
WireConnection;128;1;126;0
WireConnection;144;0;143;0
WireConnection;144;1;185;0
WireConnection;20;0;144;0
WireConnection;20;1;49;0
WireConnection;134;0;135;0
WireConnection;134;1;128;0
WireConnection;136;0;134;0
WireConnection;136;1;137;0
WireConnection;26;0;20;0
WireConnection;123;0;124;0
WireConnection;123;1;86;0
WireConnection;142;0;136;0
WireConnection;142;1;136;0
WireConnection;32;0;48;0
WireConnection;32;1;47;0
WireConnection;32;2;26;0
WireConnection;129;0;123;0
WireConnection;129;1;134;0
WireConnection;50;1;32;0
WireConnection;50;0;51;0
WireConnection;141;0;142;0
WireConnection;69;0;50;0
WireConnection;69;1;70;0
WireConnection;69;2;129;0
WireConnection;138;0;141;0
WireConnection;138;1;139;0
WireConnection;44;2;69;0
WireConnection;44;9;138;0
ASEEND*/
//CHKSM=F469D1D85ED6B9896D65B68AC79FD7748A53B18D