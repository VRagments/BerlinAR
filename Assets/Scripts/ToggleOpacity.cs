using UnityEngine;
using System.Collections;

// public class ToggleOpacity : MonoBehaviour
// {
//     public float timeSeconds = 1.0f;
//     string shaderPropertyName = "_opac";
//     public float speed = 0.2f;
//     public float timeDiff = 0.0f;
//
//     void Update()
//     {
//         float opacGet = GetComponent<Renderer>().material.GetFloat(shaderPropertyName);
//
//         if (opacGet == 0.0f) {
//             while (opacGet <= 1.0f) {
//                 timeDiff += Time.deltaTime * speed;
//                 GetComponent<Renderer>().material.SetFloat(shaderPropertyName,  timeDiff);
//                 Debug.Log(timeDiff);
//             }
//         }
//     }
// }

public class ToggleOpacity : MonoBehaviour
{
    string shaderPropertyName = "_opac";
    float timeVal = 0.0f;
    public float speed = 0.2f;

    void Update()
    {
        float opacGet = GetComponent<Renderer>().material.GetFloat(shaderPropertyName);

        if (opacGet == 0.0f) {

            while (opacGet <= 1.0f) {
                timeVal += Time.deltaTime * speed;
                GetComponent<Renderer>().material.SetFloat(shaderPropertyName, timeVal);
                opacGet = GetComponent<Renderer>().material.GetFloat(shaderPropertyName);
                Debug.Log(opacGet);
            }
            timeVal = 0.0f;
        }
    }
}
