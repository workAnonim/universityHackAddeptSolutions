Shader "Custom/BumpedSpecularIllumin"
{
	Properties 
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Base (RGB)", 2D) = "white" {}
		
		_BumpMap("Normalmap", 2D) = "bump" {}
//		_Bumpiness("BumpAmount", Float) = 1
		
		_SpecularColor("_SpecularColor", Color) = (1,1,1,1)
		_SpecularMap("_SpecularMap", 2D) = "white" {}
		_Specular("_Specular", Float ) = 1
		_Shininess("_Shininess", Float ) = 1
		_Lighting("_Lighting", Float ) = 11.6

		_GlowColor("Glow Color", Color) = (1, 1, 1, 1)
		_IlluminMap ("Illumin (A)", 2D) = "black" {}
		_Luminance("Luminance", Float) = 1
		
//		_Cutoff ("Alpha cutoff", Range (0,1)) = 0.5
	}

	SubShader 
	{
		Tags
		{
			"Queue"="Geometry"
//			"Queue"="Transparent"
			"IgnoreProjector"="False"
			"RenderType"="Opaque"
//			"RenderType"="Transparent"

		}

		Cull Back
		ZWrite On
		ZTest LEqual
		ColorMask RGBA
		
//		AlphaTest Greater [_Cutoff]

//		Cull Off

//		Lighting Off
//		ZWrite Off
//		Fog { Mode Off }
//		Offset -1, -1
//		Blend SrcAlpha OneMinusSrcAlpha

		Fog{
		}

		CGPROGRAM
//		#pragma surface surf BlinnPhongEditor  vertex:vert
		#pragma surface surf BlinnPhongEditor
		#pragma target 3.0


		float4 _Color;
		float4 _SpecularColor;
		float4 _GlowColor;
		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _SpecularMap;
		sampler2D _IlluminMap;
//		float _Bumpiness;
		float _Specular;
		float _Lighting;
		float _Shininess;
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
			float2 uv_BumpMap;
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
			o.Custom = 0.0;

			half4 TexNormal = tex2D(_BumpMap, IN.uv_BumpMap);
			half4 TexMain = tex2D(_MainTex, IN.uv_MainTex);
			half4 TexSpec = tex2D(_SpecularMap, IN.uv_SpecularMap);
			half4 TexIllumin = tex2D(_IlluminMap, IN.uv_IlluminMap);
			
			half3 SemiMain = TexMain * _Color;
			half3 DeLighting = TexSpec / _Lighting * _Color;
			
			o.Albedo = SemiMain - DeLighting;
//			o.Alpha = TexMain.a;
			o.Normal = normalize(UnpackNormal(TexNormal));
//			o.Normal = normalize (lerp(fixed3(0.5, 0.5, 1), 
//				UnpackNormal(TexNormal), 
//				_Bumpiness));
			o.Specular = _Specular;
			o.Gloss = _SpecularColor * _Shininess * TexSpec;
			o.Emission = SemiMain * TexIllumin.w * _GlowColor * _Luminance;
		}
		ENDCG
	}
	Fallback "Specular"
}