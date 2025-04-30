using System.Collections;
using System.Collections.Generic;
using System.Xml.Serialization;
using UnityEngine;
using UnityEngine.UI;

public class HeightMapController : MonoBehaviour
{
    public Material material; // El material que utiliza el shader
    public Slider intensitySlider; // El slider para controlar la intensidad

    void Start()
    {
        // Inicializa el valor del slider
        intensitySlider.value = material.GetFloat("_HeightIntensity"); // Asegúrate de que el shader tenga un `_HeightIntensity` como propiedad
        intensitySlider.onValueChanged.AddListener(UpdateIntensity);
    }

    void UpdateIntensity(float value)
    {
        material.SetFloat("_HeightIntensity", value);
    }
}
