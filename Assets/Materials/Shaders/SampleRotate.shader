// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sample Rotate"
{
	Properties
	{
		_Rotation("Rotation", Range( -10 , 10)) = 0
		[Toggle]_AnimatedRotation("Animated Rotation", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _AnimatedRotation;
		uniform float _Rotation;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float4 transform2 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 temp_output_6_0 = ( ( float4( ase_worldPos , 0.0 ) - transform2 ) + float4( 0,0,0,0 ) );
			float temp_output_5_0 = ( 0.0 + lerp(_Rotation,_Time.y,_AnimatedRotation) );
			float4 appendResult22 = (float4((temp_output_6_0).x , ( ( temp_output_5_0 * (temp_output_6_0).y ) - ( (temp_output_6_0).z * temp_output_5_0 ) ) , ( ( temp_output_5_0 * (temp_output_6_0).y ) + ( (temp_output_6_0).z * temp_output_5_0 ) ) , 0.0));
			o.Albedo = ( appendResult22 - temp_output_6_0 ).xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
-1914;58;1908;1016;4555.006;1535.738;2.646319;True;True
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;2;-3064.015,-483.1965;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-3059.015,-676.1965;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;4;-3016.865,-899.2822;Float;False;Property;_Rotation;Rotation;0;0;Create;True;0;0;False;0;0;10;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;26;-3026.864,-797.2829;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-2710.015,-503.1965;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ToggleSwitchNode;28;-2731.969,-882.943;Float;False;Property;_AnimatedRotation;Animated Rotation;1;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-2382.415,-83.59702;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;11;-1963.317,-428.7112;Float;False;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-2385.908,-501.0912;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;13;-1931.489,262.6336;Float;False;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;9;-1931.968,466.2719;Float;False;False;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;14;-1967.025,-303.244;Float;False;False;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1624.97,418.0089;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1700.717,-519.7111;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1643.967,215.4657;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1701.268,-262.0511;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;21;-1883.537,-928.4771;Float;False;True;False;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-1462.318,-373.8519;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-1394.808,404.6595;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;22;-998.2361,-317.0724;Float;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CosOpNode;12;-1908.117,-537.4109;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-617.8124,-88.64787;Float;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;24;-341.5252,208.6604;Float;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;False;0;1,0.9310344,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;8;-1888.351,171.6834;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;10;-1887.464,566.097;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;7;-1896.261,-196.6797;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;140.3456,-190.7822;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Sample Rotate;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;28;0;4;0
WireConnection;28;1;26;0
WireConnection;6;0;3;0
WireConnection;11;0;6;0
WireConnection;5;1;28;0
WireConnection;13;0;6;0
WireConnection;9;0;6;0
WireConnection;14;0;6;0
WireConnection;18;0;9;0
WireConnection;18;1;5;0
WireConnection;17;0;5;0
WireConnection;17;1;11;0
WireConnection;16;0;5;0
WireConnection;16;1;13;0
WireConnection;15;0;14;0
WireConnection;15;1;5;0
WireConnection;21;0;6;0
WireConnection;19;0;17;0
WireConnection;19;1;15;0
WireConnection;20;0;16;0
WireConnection;20;1;18;0
WireConnection;22;0;21;0
WireConnection;22;1;19;0
WireConnection;22;2;20;0
WireConnection;12;0;5;0
WireConnection;23;0;22;0
WireConnection;23;1;6;0
WireConnection;8;0;5;0
WireConnection;10;0;5;0
WireConnection;7;0;5;0
WireConnection;0;0;23;0
ASEEND*/
//CHKSM=1E3D6FEEE8F5736904370696AFB9BDD2C0D2E2DE