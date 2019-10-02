Shader "Unlit/Muur"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_MaskTex("Mask", 2D) = "white" {}
		_Color("Color", Color) = (1, 1, 1, 1)
		_Speed("Speed", float) = 1
		_RepeatFact("RepeatFactor", float) = 1
		_Transparency("Transparency", Range(0.0,0.5)) = 0.25
		_Direction("Direction", Vector) = (0, 0, 0, 0)
	}
		SubShader
		{
			Tags {"Queue" = "Transparent" "RenderType" = "Transparent"}
			LOD 100

			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

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
					float3 normal : NORMAL;
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
				float _Transparency;
				float4 _Direction;

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);

					//float4 dispTexColor = tex2Dlod(_MaskTex, float4(v.uv.xy, 0.0, 0.0));
					//float displacement = dot(float3(0.21, 0.72, 0.07), dispTexColor.rgb) * 1;
					//float4 newVertexPos = v.vertex + float4(v.normal * displacement, 0.0);
					//o.vertex = UnityObjectToClipPos(newVertexPos);

					o.uv = TRANSFORM_TEX(v.uv, _MainTex);

					UNITY_TRANSFER_FOG(o,o.vertex);


					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					float speed = _Speed;
					float4 color = _Color;
					float r = _RepeatFact;
					float t = _Transparency;
					float4 dir = _Direction;

					fixed4 col = tex2D(_MainTex, i.uv/*(i.uv + _Time.y * speed * float2(dir.x, dir.y))*/);
					fixed4 mask = tex2D(_MaskTex, (i.uv + _Time.y * speed * float2(dir.x, dir.y)));


					//clip(color.a - mask.b);
					col.a = t * mask.b;

					fixed4 c = lerp(mask, col, col);

					c.a = t;

					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG
			}
		}
}
