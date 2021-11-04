// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Oven/PainterRiverHeightShader" {
Properties {
	_MainTex ("Smoothener gradient", 2D) = "black" {}
    _SmoothFactor ("SmoothFactor", Float) = 1.0
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha            

	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
                fixed4 color : COLOR;
			};

			struct v2f {
				float4 vertex : SV_POSITION;                
				half2 texcoord : TEXCOORD0;
                half2 scrPos : TEXCOORD1;
                fixed4 color : COLOR;
			};

			sampler2D _MainTex;    
			float4 _MainTex_ST;
            float _SmoothFactor;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.color = v.color;
               
                o.scrPos = ComputeScreenPos(o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
                fixed4 col = tex2D(_MainTex, i.texcoord);                
				     
                fixed4 depth = 0.47;
                depth.a = col.x * i.color.a;
               
				return depth;
			}
		ENDCG
	}
}

}
