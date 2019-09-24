Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_MaskTex("Mask", 2D) = "white" {}
		_Color("Color", Color) = (1, 1, 1, 1)
		_Speed("Speed", float) = 1
		_RepeatFact("RepeatFactor", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

			sampler2D _MaskTex;
			float4 _Color;
			float _Speed;
			float _RepeatFact;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);

				
                return o;
            }

			fixed4 frag(v2f i) : SV_Target
			{
				float speed = _Speed;
				float4 color = _Color;
				float r = _RepeatFact;
                fixed4 col = tex2D(_MainTex, i.uv * r/*(i.uv - _Time.y * speed) * 2*/);
				fixed4 mask = tex2D(_MaskTex, (i.uv - _Time.y * (speed / r)) * r);

				
				clip(color.a - mask.b);

				col = col * color;

                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
