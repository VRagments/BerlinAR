using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.iOS;

namespace BerlinAR.XR.iOS
{
    public class BerlinARHitTest : MonoBehaviour
    {
        // Preview prefab to instantiate
        [SerializeField]
        public GameObject m_HitObject;

        // Real prefab to instantiate
        [SerializeField]
        public GameObject m_SceneObject;

        // Message to detect planes
        [SerializeField]
        public GameObject m_MessageFindPlane;

        // Point Cloud indicator while finding planes
        [SerializeField]
        public GameObject m_PointCloudParticles;

        // Message to place object
        [SerializeField]
        public GameObject m_MessagePlaceObject;

        // General ARKit Camera Manager
        [SerializeField]
        private GameObject m_ARCameraManager;
        private UnityARCameraManager arCameraManager;
        [SerializeField]
        private GameObject m_ARGeneratePlanes;

        public LayerMask collisionLayer = 1 << 10;  //ARKitPlane layer

        private bool initialized = false;

        bool HitTestWithResultType(ARPoint point, ARHitTestResultType resultTypes)
        {
            Debug.Log("Enter HitTestWithResultType!");
            List<ARHitTestResult> hitResults = UnityARSessionNativeInterface.GetARSessionNativeInterface().HitTest(point, resultTypes);
            Debug.Log("HitResults " + hitResults.Count);
            if (hitResults.Count > 0)
            {
                foreach (var hitResult in hitResults)
                {
                    Debug.Log("Got hit!");
                    m_HitObject.transform.position = UnityARMatrixOps.GetPosition(hitResult.worldTransform);
                    m_HitObject.transform.rotation = Quaternion.LookRotation(new Vector3(
                        m_HitObject.transform.position.x - arCameraManager.m_camera.transform.localPosition.x,
                    0.0f,
                        m_HitObject.transform.position.z - arCameraManager.m_camera.transform.position.z));
                    m_HitObject.SetActive(true);
                    return true;
                }
            }
            m_HitObject.SetActive(false);
            return false;
        }

        // Initialize plane setup
        void Awake()
        {
            if (m_HitObject != null)
            {
                m_HitObject.SetActive(false);
            }
            if (m_SceneObject != null)
            {
                m_SceneObject.SetActive(false);
            }
            if (m_MessageFindPlane != null)
            {
                m_MessageFindPlane.SetActive(true);
            }
            if (m_PointCloudParticles != null)
            {
                m_PointCloudParticles.SetActive(true);
            }
            if (m_MessagePlaceObject != null)
            {
                m_MessagePlaceObject.SetActive(false);
            }
            if (m_ARCameraManager != null && m_ARGeneratePlanes != null)
            {
                arCameraManager = m_ARCameraManager.GetComponent<UnityARCameraManager>();
            }
        }

        // Update is called once per frame
        void Update()
        {

            // If initialized, move on
            if (initialized)
            {
                return;
            }
            else
            {
                var screenPosition = arCameraManager.m_camera.ScreenToViewportPoint(new Vector3(Screen.width / 2, Screen.height / 2, 1));
                ARPoint point = new ARPoint
                {
                    x = screenPosition.x,
                    y = screenPosition.y
                };

                // If plane found, show minified board object to place upon touch

                // prioritize results types
                ARHitTestResultType[] resultTypes = {
					//ARHitTestResultType.ARHitTestResultTypeExistingPlaneUsingGeometry,
                    ARHitTestResultType.ARHitTestResultTypeExistingPlaneUsingExtent, 
                    // if you want to use infinite planes use this:
                    //ARHitTestResultType.ARHitTestResultTypeExistingPlane,
                    //ARHitTestResultType.ARHitTestResultTypeEstimatedHorizontalPlane, 
				    //ARHitTestResultType.ARHitTestResultTypeEstimatedVerticalPlane, 
					//ARHitTestResultType.ARHitTestResultTypeFeaturePoint
                };

                foreach (ARHitTestResultType resultType in resultTypes)
                {
                    Debug.Log("ARHitTestResultType " + resultType.ToString());
                    if (HitTestWithResultType(point, resultType))
                    {
                        m_MessageFindPlane.SetActive(false);
                        m_PointCloudParticles.SetActive(false);
                        m_MessagePlaceObject.SetActive(true);
                        if (Input.touchCount > 0 && m_HitObject.transform != null)
                        {
                            Debug.Log("Got input!");
                            m_SceneObject.transform.position = m_HitObject.transform.position;
                            m_SceneObject.transform.rotation = m_HitObject.transform.rotation;
                            m_HitObject.SetActive(false);
                            m_SceneObject.SetActive(true);
                            m_MessagePlaceObject.SetActive(false);
                            initialized = true;
                        }
                        return;
                    }
                }
            }
        }

        public void Reset()
        {
            Debug.Log("Reset");
            m_HitObject.SetActive(false);
            m_SceneObject.SetActive(false);
            m_MessageFindPlane.SetActive(true);
            m_PointCloudParticles.SetActive(true);
            m_MessagePlaceObject.SetActive(false);
            initialized = false;
        }
    }
}

