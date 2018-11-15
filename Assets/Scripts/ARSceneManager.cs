using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace BerlinAR.XR
{
    public class ARSceneManager : MonoBehaviour
    {
        public delegate IEnumerator ResizeAction(Vector3 scale);
        public static event ResizeAction OnResize;

        // The main scene object
        [SerializeField]
        private GameObject m_SceneObject;

        // resize UI
        [SerializeField]
        private GameObject goEnlarge;
        [SerializeField]
        private GameObject goMinimize;

        // reorient UI
        [SerializeField]
        private GameObject goVertical;
        [SerializeField]
        private GameObject goHorizontal;

        // AR Game Objects to activate
        [SerializeField]
        private GameObject aRCoreParent;
        [SerializeField]
        private GameObject aRKitParent;

        private readonly Vector3 minScale = new Vector3(0.1f, 0.1f, 0.1f);
        private readonly Vector3 maxScale = Vector3.one;

        // scene orientation in free mode
        public enum SceneOrientation
        {
            Vertical,
            Horizontal
        }
        private SceneOrientation currentSceneOrientation;
        private readonly float horizontalRot = 75.0f;
        private readonly float verticalRot = 15.0f;
        private readonly float rotTime = 3f;

        // Use this for initialization
        void Start()
        {
            if (Application.platform == RuntimePlatform.Android && aRCoreParent != null) {
                aRKitParent.SetActive(false);
                aRCoreParent.SetActive(true);
            } else if (aRKitParent != null) {
                aRKitParent.SetActive(true);
                aRCoreParent.SetActive(false);
            }
            if (goEnlarge != null && goMinimize != null)
            {
                goEnlarge.SetActive(false);
                goMinimize.SetActive(true);
            }
            if (goVertical != null && goHorizontal != null)
            {
                goVertical.SetActive(false);
                goHorizontal.SetActive(true);
            }
            currentSceneOrientation = SceneOrientation.Vertical;
        }

        // Update is called once per frame
        void Update()
        {

        }

        public void ResizeScene()
        {
            if (m_SceneObject != null && m_SceneObject.transform.localScale == minScale)
            {
                m_SceneObject.transform.localScale = maxScale;
                if (OnResize != null)
                {
                    OnResize(maxScale);
                    goEnlarge.SetActive(true);
                    goMinimize.SetActive(false);
                }

            }
            else if (m_SceneObject != null && m_SceneObject.transform.localScale == maxScale)
            {
                m_SceneObject.transform.localScale = minScale;
                if (OnResize != null)
                {
                    OnResize(minScale);
                    goEnlarge.SetActive(false);
                    goMinimize.SetActive(true);
                }
            }
        }

        public void SetSceneVertical()
        {
            if (currentSceneOrientation == SceneOrientation.Vertical)

            {
                return;
            }
            if (m_SceneObject != null)
            {
                goVertical.SetActive(false);
                StartCoroutine(RotateXTo(m_SceneObject, horizontalRot, verticalRot, rotTime, goHorizontal, SceneOrientation.Vertical));
            }
        }

        public void SetSceneHorizontal()
        {
            if (currentSceneOrientation == SceneOrientation.Horizontal)

            {
                return;
            }
            if (m_SceneObject != null)
            {
                goHorizontal.SetActive(false);
                StartCoroutine(RotateXTo(m_SceneObject, verticalRot, horizontalRot, rotTime, goVertical, SceneOrientation.Horizontal));
            }
        }

        private IEnumerator RotateXTo(GameObject go, float from, float to, float time, GameObject ui, SceneOrientation orientation)
        {
            Vector3 rot = new Vector3(from, go.transform.rotation.y, go.transform.rotation.z);

            float t = 0.0f; // initialize a zero time
            float tConf = 0.1f; // confidence interval for time comparison

            while (t <= time + tConf)
            {
                rot.x = Mathf.Lerp(from, to, t / time);
                go.transform.localEulerAngles = rot;
                t += Time.deltaTime;
                yield return null;
            }
            currentSceneOrientation = orientation;
            ui.SetActive(true);
            yield return null;
        }
    }
}