using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(CharacterController))]
public class PlayerMovement : MonoBehaviour
{
    public MouseDragInput input;
    public float moveSpeed = 5f;
    public float smoothTime = 0.1f;

    private CharacterController controller;
    private Vector3 velocity = Vector3.zero;

    void Start()
    {
        controller = GetComponent<CharacterController>();
    }

    void Update()
    {
        Vector2 drag = input.DragDirection;

        Vector3 targetDirection = new Vector3(drag.x, 0, drag.y);
        Vector3 desiredVelocity = targetDirection * moveSpeed;

        velocity = Vector3.Lerp(velocity, desiredVelocity, Time.deltaTime / smoothTime);
        controller.Move(velocity * Time.deltaTime);

        if (targetDirection.magnitude > 0.1f)
        {
            Quaternion targetRotation = Quaternion.LookRotation(targetDirection);
            transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, Time.deltaTime * 10f);
        }
    }
}
