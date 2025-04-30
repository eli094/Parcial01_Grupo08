using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class WaterPanelController : MonoBehaviour
{
    public GameObject toonWaterPanel;
    public GameObject toonWaterfallPanel;

    private void Start()
    {

        ChangeToWaterPanel();
    }
    private void Update()
    {
        
    }

    public void ChangeToWaterPanel()
    {
        toonWaterfallPanel.SetActive(false);
        toonWaterPanel.SetActive(true);
    }
    public void ChangeToWaterfallPanel()
    {
        toonWaterPanel.SetActive(false);
        toonWaterfallPanel.SetActive(true);
    }
}
