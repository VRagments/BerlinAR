using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace BerlinAR.XR
{
    public class BerlinCenter : MonoBehaviour
    {

        // Offset rotation
        // Brandenburg Gate
        // private float _LonOrigin = 52.5162778f;
        // private float _LatOrigin = -13.3755101f;
        private float _LonOrigin = 53.275f;
        private float _LatOrigin = -8.1f;

        // Offset location

        // Scale 1:1000

        // Use this for initialization
        void Start()
        {
            RotateToOrigin();
        }

        // Update is called once per frame
        void Update()
        {

        }

        void RotateToOrigin()
        {
            this.transform.localRotation = Quaternion.AngleAxis(_LatOrigin, -Vector3.up) * Quaternion.AngleAxis(_LonOrigin, -Vector3.right);
        }
    }
}
