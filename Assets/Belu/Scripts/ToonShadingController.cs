using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Windows;

public class ToonShadingController : MonoBehaviour
{
    [Header("Target GameObject with Renderer")]
    public GameObject targetObject;
    public Material targetMaterial;

    [Header("Properties")]
    public Slider shadowForce;
    public Slider shadowForceStep2;
    public TMP_InputField color1;
    public TMP_InputField color2;
    public TMP_InputField multiplyColor;

    private void Awake()
    {
        if (targetObject == null)
        {
            Debug.LogError("ToonShadingController: No target GameObject assigned!");
            return;
        }

        Renderer renderer = targetObject.GetComponent<Renderer>();
        if (renderer == null)
        {
            Debug.LogError("ToonShadingController: Target GameObject has no Renderer!");
            return;
        }

        targetMaterial = new Material(renderer.sharedMaterial);
        renderer.material = targetMaterial;
    }
    private void Start()
    {
        if (targetMaterial == null)
        {
            Debug.LogError("ToonShadingController: No material assigned!");
            return;
        }

        if (shadowForce != null)
            shadowForce.onValueChanged.AddListener(val => targetMaterial.SetFloat("_ShadowForce", val));

        if (shadowForceStep2 != null)
            shadowForceStep2.onValueChanged.AddListener(val => targetMaterial.SetFloat("_ShadowForceStep2", val));

        if (color1 != null)
            color1.onEndEdit.AddListener(input => TryParseColor(input, "_Color1"));

        if (color2 != null)
            color2.onEndEdit.AddListener(input => TryParseColor(input, "_Color2"));

        if (multiplyColor != null)
            multiplyColor.onEndEdit.AddListener(input => TryParseColor(input, "_MultiplyColor"));
    }
    private void TryParseColor(string input, string propertyName)
    {
        if (targetMaterial == null || string.IsNullOrWhiteSpace(input)) return;

        var parts = input.Split(',');
        if (parts.Length >= 3 &&
            float.TryParse(parts[0], out float r) &&
            float.TryParse(parts[1], out float g) &&
            float.TryParse(parts[2], out float b))
        {
            float a = parts.Length >= 4 && float.TryParse(parts[3], out float parsedA) ? parsedA : 1f;
            targetMaterial.SetColor(propertyName, new Color(r, g, b, a));
            Debug.Log("Color has changed.");
        }
        else
        {
            Debug.LogWarning($"Invalid color input for {propertyName}. Expected: R,G,B[,A]");
        }
    }
}
