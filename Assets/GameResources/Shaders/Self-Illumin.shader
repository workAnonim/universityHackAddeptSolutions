Shader "Custom/Self-Illumin"
{
	Properties 
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Base (RGB)", 2D) = "white" {}
		
		_GlowColor("Glow Color", Color) = (1, 1, 1, 1)
		_IlluminMap ("Illumin (A)", 2D) = "gray" {}
		_Luminance("Luminance", Float) = 1
	}

	SubShader 
	{
		Tags
		{
			"Queue"="Geometry"
			"IgnoreProjector"="False"
			"RenderType"="Opaque"

		}

		Cull Back
		ZWrite On
		ZTest LEqual
		ColorMask RGBA

		Fog{
		}

		CGPROGRAM
//		#pragma surface surf BlinnPhongEditor  vertex:vert
		#pragma surface surf BlinnPhongEditor
		#pragma target 2.0


		float4 _Color;
		float4 _GlowColor;
		sampler2D _MainTex;
		sampler2D _IlluminMap;
		float _Luminance;

		struct EditorSurfaceOutput {
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half3 Gloss;
			half Specular;
			half Alpha;
			half4 Custom;
		};

		inline half4 LightingBlinnPhongEditor_PrePass (EditorSurfaceOutput s, half4 light)
		{
			half3 spec = light.a * s.Gloss;
			half4 c;
			c.rgb = (s.Albedo * light.rgb + light.rgb * spec);
			c.a = s.Alpha;
			return c;

		}

		inline half4 LightingBlinnPhongEditor (EditorSurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		{
			half3 h = normalize (lightDir + viewDir);

			half diff = max (0, dot ( lightDir, s.Normal ));

			float nh = max (0, dot (s.Normal, h));
			float spec = pow (nh, s.Specular*128.0);

			half4 res;
			res.rgb = _LightColor0.rgb * diff;
			res.w = spec * Luminance (_LightColor0.rgb);
			res *= atten * 2.0;

			return LightingBlinnPhongEditor_PrePass( s, res );
		}

		struct Input {
			float2 uv_MainTex;
			float2 uv_SpecularMap;
			float2 uv_IlluminMap;
		};

//		void vert (inout appdata_full v, out Input o) {
//			float4 VertexOutputMaster0_0_NoInput = float4(0,0,0,0);
//			float4 VertexOutputMaster0_1_NoInput = float4(0,0,0,0);
//			float4 VertexOutputMaster0_2_NoInput = float4(0,0,0,0);
//			float4 VertexOutputMaster0_3_NoInput = float4(0,0,0,0);
//		}

		void surf (Input IN, inout EditorSurfaceOutput o) {
			o.Alpha = 1.0;
			o.Specular = 0.0;
			o.Gloss = 0.0;
			o.Custom = 0.0;
			o.Normal = float3(0.0,0.0,1.0);

			half4 TexMain = tex2D(_MainTex, IN.uv_MainTex);
			half4 TexIllumin = tex2D(_IlluminMap, IN.uv_IlluminMap);
			
			half3 SemiMain = TexMain * _Color;
			
			o.Albedo = SemiMain;
			o.Emission = SemiMain * TexIllumin.w * _GlowColor * _Luminance;
		}
		ENDCG
	}
	Fallback "Specular"
}