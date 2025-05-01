using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DissolveController : MonoBehaviour
{
    [Header("Target GameObject with Renderer")]
    public GameObject targetObject;
    public Material targetMaterial;

    [Header("Properties")]
    public Slider edgeSlider;
    public Slider dissolveProximitySlider;


    private void Awake()
    {
        if (targetObject == null)
        {
            Debug.LogError("DissolveController: No target GameObject assigned!");
            return;
        }

        Renderer renderer = targetObject.GetComponent<Renderer>();
        if (renderer == null)
        {
            Debug.LogError("DissolveController: Target GameObject has no Renderer!");
            return;
        }

        targetMaterial = new Material(renderer.sharedMaterial);
        renderer.material = targetMaterial;
    }
    private void Start()
    {
        if (targetMaterial == null)
        {
            Debug.LogError("DissolveController: No material assigned!");
            return;
        }

        if (edgeSlider != null)
            edgeSlider.onValueChanged.AddListener(val => targetMaterial.SetFloat("_Edge", val));

        if (dissolveProximitySlider != null)
            dissolveProximitySlider.onValueChanged.AddListener(val => targetMaterial.SetFloat("_DissolveProximity", val));
        
    }
}
