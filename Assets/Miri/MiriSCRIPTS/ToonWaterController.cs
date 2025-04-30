using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class ToonWaterController : MonoBehaviour
{
    public Material targetMaterial;

    [Header("Time properties")]
    public Slider timeScaleSlider;

    [Header("Height properties")]
    public TMP_InputField heightMultiplierInput;

    [Header("Distortion properties")]
    public Slider distortionWeightSlider;

    [Header("FlowMap properties")]
    public TMP_InputField flowDirX;
    public TMP_InputField flowDirY;
    public TMP_InputField flowDirZ;
    public Slider flowmapPannerSpeedSlider;
    public Slider flowmapTilingSlider;

    [Header("Depth Fade properties")]
    public Slider biasSlider;
    public Slider scaleSlider;
    public Slider powerSlider;

    void Start()
    {
        if (targetMaterial == null)
        {
            Debug.LogError("ShaderUIBinder: No material assigned!");
            return;
        }

        if (timeScaleSlider != null)
            timeScaleSlider.onValueChanged.AddListener(val => targetMaterial.SetFloat("_TimeScale", val));

        if (heightMultiplierInput != null)
            heightMultiplierInput.onEndEdit.AddListener(OnHeightMultiplierChanged);

        if (distortionWeightSlider != null)
            distortionWeightSlider.onValueChanged.AddListener(val => targetMaterial.SetFloat("_DistortionWeight", val));

        if (flowDirX != null && flowDirY != null && flowDirZ != null)
        {
            flowDirX.onEndEdit.AddListener(_ => UpdateFlowDirection());
            flowDirY.onEndEdit.AddListener(_ => UpdateFlowDirection());
            flowDirZ.onEndEdit.AddListener(_ => UpdateFlowDirection());
        }

        if (flowmapPannerSpeedSlider != null)
            flowmapPannerSpeedSlider.onValueChanged.AddListener(val => targetMaterial.SetFloat("_FlowmapPannerSpeed", val));

        if (flowmapTilingSlider != null)
            flowmapTilingSlider.onValueChanged.AddListener(val => targetMaterial.SetFloat("_FlowmapTiling", val));

        if (biasSlider != null)
            biasSlider.onValueChanged.AddListener(val => targetMaterial.SetFloat("_Bias", val));

        if (scaleSlider != null)
            scaleSlider.onValueChanged.AddListener(val => targetMaterial.SetFloat("_Scale", val));

        if (powerSlider != null)
            powerSlider.onValueChanged.AddListener(val => targetMaterial.SetFloat("_Power", val));
    }

    void OnHeightMultiplierChanged(string input)
    {
        if (targetMaterial == null) return;
        if (float.TryParse(input, out float val))
        {
            Vector4 current = targetMaterial.GetVector("_HeightMultiplier");
            current.x = val;
            targetMaterial.SetVector("_HeightMultiplier", current);
        }
    }

    void UpdateFlowDirection()
    {
        if (targetMaterial == null || flowDirX == null || flowDirY == null || flowDirZ == null)
            return;

        if (
            float.TryParse(flowDirX.text, out float x) &&
            float.TryParse(flowDirY.text, out float y) &&
            float.TryParse(flowDirZ.text, out float z))
        {
            targetMaterial.SetVector("_FlowmapDirection", new Vector3(x, y, z));
        }
    }
}
