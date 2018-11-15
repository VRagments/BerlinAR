using GeoJSON;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using UnityEngine;
using UnityEngine.UI;

namespace BerlinAR.XR
{
    public class BikeStatusRenderer : MonoBehaviour
    {

        // where to attach the pins to and get offset and scale
        [SerializeField]
        public GameObject worldRoot;

        // the geojson data source
        [SerializeField]
        public TextAsset encodedGeoJSON;

        // prefab to use for visualization
        [SerializeField]
        private GameObject prefabToGenerate;

        // material to use for visualization
        [SerializeField]
        private Material lineMaterial;

        // used to adapt the line renderer to scaling the model
        [SerializeField]
        public float scaleFactor = 1f;

        public FeatureCollection Collection { get; private set; }

        private List<GameObject> routes;

        private bool loadedJSON = false;

        // UI and legend
        [SerializeField]
        private GameObject loadUI;
        [SerializeField]
        private Transform loading_bar;

        void OnEnable()
        {
            ARSceneManager.OnResize += Resize;
        }


        void OnDisable()
        {
            ARSceneManager.OnResize -= Resize;
        }

        // Use this for initialization
        void Start()
        {
            if (encodedGeoJSON != null)
            {
                StartCoroutine(LoadAndParse(encodedGeoJSON.text));
            }
            routes = new List<GameObject>();
            if (!loadUI || !loading_bar)
            {
                Debug.LogWarning("UI Elements not set");
            }
            else
            {
                loading_bar.localScale = new Vector3(0f, 1f, 1f);
            }
        }

        // Update is called once per frame
        void Update()
        {

        }

        private IEnumerator LoadAndParse(string txt)
        {
            //Debug.Log("Enter LoadAndParse");
            StartCoroutine(LoadJSON(txt));
            while (!loadedJSON)
            {
                yield return null;
            }
            StartCoroutine(GetFeatures(Collection));
        }

        private IEnumerator LoadJSON(string txt)
        {
            //Debug.Log("Enter LoadJSON");
            Collection = GeoJSONObject.Deserialize(txt);
            yield return loadedJSON = true;
        }

        private IEnumerator GetFeatures(FeatureCollection coll)
        {
            int collCount = coll.features.Count;

            int idx = 0;
            //Debug.Log("Enter GetFeatures");
            foreach (FeatureObject obj in coll.features)
            {
                StartCoroutine(GetFeatureObject(obj));
                idx++;
                float fill = idx / (float)collCount;
                loading_bar.localScale = new Vector3(fill, 1f, 1f);
                yield return null;
            }
            loading_bar.localScale = new Vector3(1f, 1f, 1f);
            loadUI.SetActive(false);
            yield return null;
        }

        private IEnumerator GetFeatureObject(FeatureObject obj)
        {
            // get id
            string id = "";
            if (obj.properties.TryGetValue("STRSCHL", out id))
            {
                //Debug.Log("FeatureObject: " + id);
            }

            // get coverage
            string coverageStr = "";
            float coverageFloat = 0f;

            if (obj.properties.TryGetValue("ABDECKUNG", out coverageStr))
            {
                coverageFloat = float.Parse(coverageStr, CultureInfo.InvariantCulture.NumberFormat);
                if (coverageFloat > 0.0f)
                {
                    //Debug.Log("FeatureObject: " + coverageFloat);
                }
            }


            // get coordinates
            GeoJSON.MultiLineStringGeometryObject geomLines = (MultiLineStringGeometryObject)obj.geometry;

            if (geomLines.coordinates.Count > 0 && id != "" && coverageStr != "") {
                foreach (List<PositionObject> section in geomLines.coordinates)
                {
                    yield return StartCoroutine(CreateRouteGameObject(section, id, coverageFloat));
                }
            }

            yield return null;
        }

        private IEnumerator CreateRouteGameObject(List<PositionObject> coords, string id, float coverageFloat)
        {

            // build LineRenderer go
            GameObject go = new GameObject();
            go.name = "_street_" + id;
            // add to worldRoot and position
            go.transform.parent = worldRoot.transform;

            // reset position, rotation and scale to local 0
            go.transform.localPosition = Vector3.zero;
            go.transform.localRotation = Quaternion.identity;
            go.transform.localScale = Vector3.one;


            LineRenderer lRenderer = go.AddComponent<LineRenderer>();
            lRenderer.widthMultiplier = 0.01f * scaleFactor;
            lRenderer.material = lineMaterial;
            Color tmpColor = new Color(Mathf.Lerp(0f, 1f, 1f-coverageFloat), Mathf.Lerp(0f, 1f, coverageFloat), 0);
            //Debug.Log("Line color " + tmpColor);
            lRenderer.material.SetColor("_color", tmpColor);


            // lRenderer.alignment
            lRenderer.useWorldSpace = false;

            Vector3[] vertices = new Vector3[coords.Count];

            for (int i = 0; i < coords.Count; i++)
            {
                vertices[i] = Quaternion.AngleAxis(coords[i].longitude, -Vector3.up) * Quaternion.AngleAxis(-coords[i].latitude, -Vector3.right) * new Vector3(0, 0, -6371.0f);
                yield return null;
            }

            lRenderer.positionCount = vertices.Length;
            lRenderer.SetPositions(vertices);


            routes.Add(go);
        }

        public IEnumerator Resize(Vector3 scaleFactor)
        {
            yield return StartCoroutine(ResizeRoutes(scaleFactor.x));
        }

        private IEnumerator ResizeRoutes(float width)
        {
            if (routes != null)
            {
                //Debug.Log("Changing routes width of " + routes.Count + " routes.");
                foreach (GameObject route in routes)
                {
                    LineRenderer lRenderer = route.GetComponent<LineRenderer>();
                    lRenderer.widthMultiplier = 0.01f * width;
                }
            }
            yield return null;
        }
    }
}