Shader "Custom/CooleShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
		_MaskTex("Mask", 2D) = "white" {}
		_Speed("Speed", float) = 1
		_RepeatFact("RepeatFactor", float) = 1
		_BumpMap("Normal Map", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_BumpMap;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

		sampler2D _BumpMap;
		sampler2D _MaskTex;
		float _Speed;
		float _RepeatFact;


        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			float speed = _Speed;
			float4 color = _Color;
			float r = _RepeatFact;

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex * r) * _Color;
			fixed4 mask = tex2D(_MaskTex, (IN.uv_MainTex - _Time.y * (speed / r)) * r);

			clip(color.a - mask.b);

            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap / 2 * _Time.x));
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
