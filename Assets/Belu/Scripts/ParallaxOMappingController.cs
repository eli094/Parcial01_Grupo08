using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ParallaxOMappingController : MonoBehaviour
{
    [Header("Target GameObject with Renderer")]
    public GameObject targetObject;
    public Material targetMaterial;

    [Header("Properties")]
    public Slider scale;
    public Slider reflScale;

    private void Awake()
    {
        if (targetObject == null)
        {
            Debug.LogError("ParallaxOMappingController: No target GameObject assigned!");
            return;
        }

        Renderer renderer = targetObject.GetComponent<Renderer>();
        if (renderer == null)
        {
            Debug.LogError("ParallaxOMappingController: Target GameObject has no Renderer!");
            return;
        }

        targetMaterial = new Material(renderer.sharedMaterial);
        renderer.material = targetMaterial;
    }
    private void Start()
    {
        if (targetMaterial == null)
        {
            Debug.LogError("ParallaxOMappingController: No material assigned!");
            return;
        }

        if (scale != null)
            scale.onValueChanged.AddListener(val => targetMaterial.SetFloat("_Scale", val));

        if (reflScale != null)
            reflScale.onValueChanged.AddListener(val => targetMaterial.SetFloat("_ReflPlane", val));
    }
}
