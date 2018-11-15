using GoogleARCore;

namespace BerlinAR.XR.Android
{
    using System.Collections.Generic;
    using GoogleARCore;
    using GoogleARCore.Examples.Common;
    using UnityEngine;

#if UNITY_EDITOR
    // Set up touch input propagation while using Instant Preview in the editor.
    using Input = InstantPreviewInput;
#endif

    /// <summary>
    /// Controls the HelloAR example.
    /// </summary>
    public class AndroidARController : MonoBehaviour
    {
        private enum AnchorPosition { APLOR, APRoutes, APStatus, APWall };
        /// <summary>
        /// The first-person camera being used to render the passthrough camera image (i.e. AR background).
        /// </summary>
        public Camera FirstPersonCamera;

        /// <summary>
        /// The rotation in degrees need to apply to model when the Andy model is placed.
        /// </summary>
        private const float k_ModelRotation = 180.0f;

        /// <summary>
        /// A list to hold all planes ARCore is tracking in the current frame. This object is used across
        /// the application to avoid per-frame allocations.
        /// </summary>
        private List<DetectedPlane> m_AllPlanes = new List<DetectedPlane>();

        /// <summary>
        /// True if the app is in the process of quitting due to an ARCore connection error, otherwise false.
        /// </summary>
        private bool m_IsQuitting = false;
        public DetectedPlaneGenerator planeGenerator;

        public GameObject m_MessageFindPlane;
        public GameObject m_MessagePlaceObject;

        public GameObject PrefabMiniModel;
        public GameObject PrefabBerlinModel;
        public GameObject PrefabLORModel;
        public GameObject PrefabRoutesModel;
        public GameObject PrefabStatusModel;
        public GameObject PrefabWallModel;
        private List<AugmentedImage> m_TempAugmentedImages = new List<AugmentedImage>();
        private Dictionary<AnchorPosition, Anchor> anchors = new Dictionary<AnchorPosition, Anchor>(System.Enum.GetValues(typeof(AnchorPosition)).Length);
        public bool isFreeMode;
        private bool initialized = false;
        private GameObject hitObject;
        /// <summary>
        /// The Unity Update() method.
        /// </summary>
        public GameObject m_SceneObject;

        void Start()
        {
            m_MessageFindPlane.SetActive(true);
            m_MessagePlaceObject.SetActive(false);
        }

        private GameObject model;
        public void Update()
        {
            _UpdateApplicationLifecycle();

            if (initialized)
            {
                return;
            }

            if (isFreeMode)
            {
                // Hide snackbar when currently tracking at least one plane.
                Session.GetTrackables<DetectedPlane>(m_AllPlanes);
                for (int i = 0; i < m_AllPlanes.Count; i++)
                {
                    if (m_AllPlanes[i].TrackingState == TrackingState.Tracking && m_AllPlanes[i].PlaneType == DetectedPlaneType.HorizontalUpwardFacing)
                    {
                        m_MessageFindPlane.SetActive(false);
                        m_MessagePlaceObject.SetActive(true);
                        break;
                    }
                }


                TrackableHit hit;
                TrackableHitFlags raycastFilter = TrackableHitFlags.PlaneWithinBounds;

                if (Frame.Raycast(Screen.width / 2, Screen.height / 2, raycastFilter, out hit))
                {
                    // Use hit pose and camera pose to check if hittest is from the
                    // back of the plane, if it is, no need to create the anchor.
                    if ((hit.Trackable is DetectedPlane))
                    {
                        if (Vector3.Dot(FirstPersonCamera.transform.position - hit.Pose.position, hit.Pose.rotation * Vector3.up) < 0)
                        {
                        }
                        else
                        {
                            DetectedPlane p = hit.Trackable as DetectedPlane;
                            if (p.PlaneType == DetectedPlaneType.HorizontalUpwardFacing)
                            {

                                if (hitObject == null)
                                {
                                    hitObject = Instantiate(PrefabMiniModel, hit.Pose.position, hit.Pose.rotation);
                                    hitObject.transform.Rotate(0, k_ModelRotation, 0, Space.Self);
                                }
                                else
                                {
                                    hitObject.transform.position = hit.Pose.position;
                                    hitObject.transform.rotation = hit.Pose.rotation;
                                }
                            }
                        }
                    }
                }

                if (Input.touchCount > 0 && hitObject != null)
                {
                    m_SceneObject.transform.position = hitObject.transform.position;
                    m_SceneObject.transform.rotation = hitObject.transform.rotation;
                    m_SceneObject.SetActive(true);
                    Destroy(hitObject);
                    m_MessagePlaceObject.SetActive(false);
                    initialized = true;
                    planeGenerator.gameObject.SetActive(false);
                }
            }
            else
            {
                // Get updated augmented images for this frame.
                Session.GetTrackables<AugmentedImage>(m_TempAugmentedImages, TrackableQueryFilter.Updated);
                List<AugmentedImage> FoundMarker = m_TempAugmentedImages.FindAll(
                    image => image.Name == "RefLOR" ||
                    image.Name == "RefRoutes" ||
                    image.Name == "RefStatus" ||
                    image.Name == "RefWall");
                FoundMarker.ForEach(image => _UpdateFromMarker(image));
            }

        }

        /// <summary>
        /// Check and update the application lifecycle.
        /// </summary>
        private void _UpdateApplicationLifecycle()
        {
            // Exit the app when the 'back' button is pressed.
            if (Input.GetKey(KeyCode.Escape))
            {
                Application.Quit();
            }

            // Only allow the screen to sleep when not tracking.
            if (Session.Status != SessionStatus.Tracking)
            {
                const int lostTrackingSleepTimeout = 15;
                Screen.sleepTimeout = lostTrackingSleepTimeout;
            }
            else
            {
                Screen.sleepTimeout = SleepTimeout.NeverSleep;
            }

            if (m_IsQuitting)
            {
                return;
            }

            // Quit if ARCore was unable to connect and give Unity some time for the toast to appear.
            if (Session.Status == SessionStatus.ErrorPermissionNotGranted)
            {
                _ShowAndroidToastMessage("Camera permission is needed to run this application.");
                m_IsQuitting = true;
                Invoke("_DoQuit", 0.5f);
            }
            else if (Session.Status.IsError())
            {
                _ShowAndroidToastMessage("ARCore encountered a problem connecting.  Please start the app again.");
                m_IsQuitting = true;
                Invoke("_DoQuit", 0.5f);
            }
        }

        /// <summary>
        /// Actually quit the application.
        /// </summary>
        private void _DoQuit()
        {
            Application.Quit();
        }

        /// <summary>
        /// Show an Android toast message.
        /// </summary>
        /// <param name="message">Message string to show in the toast.</param>
        private void _ShowAndroidToastMessage(string message)
        {
            AndroidJavaClass unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
            AndroidJavaObject unityActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity");

            if (unityActivity != null)
            {
                AndroidJavaClass toastClass = new AndroidJavaClass("android.widget.Toast");
                unityActivity.Call("runOnUiThread", new AndroidJavaRunnable(() =>
                {
                    AndroidJavaObject toastObject = toastClass.CallStatic<AndroidJavaObject>("makeText", unityActivity,
                        message, 0);
                    toastObject.Call("show");
                }));
            }
        }
        private void _UpdateFromMarker(AugmentedImage image)
        {
            switch (image.TrackingState)
            {
                case TrackingState.Tracking:
                    _TrackingMarker(image);
                    break;
                case TrackingState.Stopped:
                    _StoppedMarker(image);
                    break;
                default:
                    break;
            }
        }

        private void _TrackingMarker(AugmentedImage image)
        {
            AnchorPosition pos = _PosForName(image.Name);
            Anchor anchor;
            if (!anchors.TryGetValue(pos, out anchor))
            {
                anchor = image.CreateAnchor(image.CenterPose);
                anchors.Add(pos, anchor);
                _AdaptModel(pos, anchor);
            }
        }

        private void _StoppedMarker(AugmentedImage image)
        {
            if (model != null)
            {
                AnchorPosition pos = _PosForName(image.Name);
                Anchor anchor;
                if (anchors.TryGetValue(pos, out anchor))
                {
                    anchors.Remove(pos);
                    if (anchors.Count == 0)
                    {
                        GameObject.Destroy(model);
                    }
                }
            }
        }
        private AnchorPosition _PosForName(string name)
        {
            if (name == "RefLOR")
            {
                return AnchorPosition.APLOR;
            }
            if (name == "RefRoutes")
            {
                return AnchorPosition.APRoutes;
            }
            if (name == "RefStatus")
            {
                return AnchorPosition.APStatus;
            }
            if (name == "RefWall")
            {
                return AnchorPosition.APWall;
            }
            return AnchorPosition.APWall;
        }

        private GameObject prefabFromPos(AnchorPosition pos)
        {
            switch (pos)
            {
                case AnchorPosition.APLOR:
                    return PrefabLORModel;
                case AnchorPosition.APRoutes:
                    return PrefabRoutesModel;
                case AnchorPosition.APStatus:
                    return PrefabStatusModel;
                case AnchorPosition.APWall: // same as default
                    return PrefabWallModel;
                default:
                    return PrefabWallModel;
            }
        }

        private void _AdaptModel(AnchorPosition pos, Anchor anchor)
        {
            Destroy(model);
            GameObject pref = prefabFromPos(pos);
            model = Instantiate<GameObject>(pref, anchor.transform);
            switch (pos)
            {
                case AnchorPosition.APLOR:
                    model.transform.localPosition += new Vector3(2, -1, 1.5f);
                    model.transform.localEulerAngles = new Vector3(109, 0, 0);
                    break;
                case AnchorPosition.APRoutes:
                    model.transform.localPosition += new Vector3(1, -1, 1.5f);
                    model.transform.localEulerAngles = new Vector3(109, 0, 0);
                    break;
                case AnchorPosition.APStatus:
                    model.transform.localPosition += new Vector3(0, -1, 1.5f);
                    model.transform.localEulerAngles = new Vector3(109, 0, 0);
                    break;
                case AnchorPosition.APWall:
                    model.transform.localPosition += new Vector3(-1, -1, 1.5f);
                    model.transform.localEulerAngles = new Vector3(109, 0, 0);
                    break;
                default:
                    break;
            }
        }
        public void Reset()
        {
            if (hitObject) { Destroy(hitObject); }
            if (m_SceneObject) { m_SceneObject.SetActive(false); }
            if (m_MessageFindPlane) { m_MessageFindPlane.SetActive(true); }
            if (m_MessagePlaceObject) { m_MessagePlaceObject.SetActive(false); }
            if (planeGenerator) { planeGenerator.gameObject.SetActive(true); }
            initialized = false;
        }
    }
}
