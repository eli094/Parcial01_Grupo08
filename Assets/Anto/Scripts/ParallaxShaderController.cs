using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class ParallaxShaderController : MonoBehaviour
{
    public Material targetMaterial;
    public Slider speedSlider;
    public Slider scaleSlider;

    private string speedProperty = "_Speed";
    private string scaleProperty = "_Scale";

    void Start()
    {
        if (speedSlider != null)
        {
            speedSlider.onValueChanged.AddListener(SetSpeed);
        }
        if (scaleSlider != null)
        {
            scaleSlider.onValueChanged.AddListener(SetScale);
        }
    }

    void SetSpeed(float value)
    {
        if (targetMaterial != null)
        {
            targetMaterial.SetFloat(speedProperty, value);
        }
    }

    void SetScale(float value)
    {
        if (targetMaterial != null)
        {
            targetMaterial.SetFloat(scaleProperty, value);
        }
    }
}
