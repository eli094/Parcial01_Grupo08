using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseDragInput : MonoBehaviour
{
    public Vector2 DragDirection { get; private set; }
    public bool IsDragging { get; private set; }

    private Vector2 dragStartPos;

    private void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            dragStartPos = Input.mousePosition;
            IsDragging = true;
        }
        else if (Input.GetMouseButtonUp(0))
        {
            IsDragging = false;
            DragDirection = Vector2.zero;
        }

        if (IsDragging)
        {
            Vector2 currentMousePos = Input.mousePosition;
            Vector2 dragDelta = currentMousePos - dragStartPos;
            DragDirection = Vector2.ClampMagnitude(dragDelta, 100f) / 100f;
        }
    }
}
