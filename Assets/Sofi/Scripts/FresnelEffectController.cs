using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class FresnelEffectController : MonoBehaviour
{
    [Header("Target GameObject with Renderer")]
    public GameObject targetObject;
    public Material targetMaterial;

    [Header("Properties")]
    public Slider lerpValueSlider;
    public Slider fresnelPowerSlider;
    public Slider lerpTimeSlider;
    public Slider lerpAlphaSlider;

    private void Awake()
    {
        if (targetObject == null)
        {
            Debug.LogError("FresnelEffectController: No target GameObject assigned!");
            return;
        }

        Renderer renderer = targetObject.GetComponent<Renderer>();
        if (renderer == null)
        {
            Debug.LogError("FresnelEffectController: Target GameObject has no Renderer!");
            return;
        }

        targetMaterial = new Material(renderer.sharedMaterial);
        renderer.material = targetMaterial;
    }
    private void Start()
    {
        if (targetMaterial == null)
        {
            Debug.LogError("FresnelEffectController: No material assigned!");
            return;
        }

        if (lerpValueSlider != null)
            lerpValueSlider.onValueChanged.AddListener(val => targetMaterial.SetFloat("_LerpValue", val));

        if (fresnelPowerSlider != null)
            fresnelPowerSlider.onValueChanged.AddListener(val => targetMaterial.SetFloat("_FresnelPower", val)); 

        if (lerpTimeSlider != null)
            lerpTimeSlider.onValueChanged.AddListener(val => targetMaterial.SetFloat("_LerpTime", val)); 

        if (lerpAlphaSlider != null)
            lerpAlphaSlider.onValueChanged.AddListener(val => targetMaterial.SetFloat("_LerpAlpha", val));
    }
}
