using GeoJSON;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

namespace BerlinAR.XR
{
    public class BikeRoutesRenderer : MonoBehaviour
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

        // Array of all routes with key=start time and bike GameObject
        [SerializeField]
        private SortedDictionary<DateTime, List<GameObject>> routesDict;

        private bool loadedJSON = false;
        private bool routesInitialized = false;

        [SerializeField]
        private int SPEEDUP_FACTOR = 1000;

        // UI and legend
        [SerializeField]
        private GameObject loadUI;
        [SerializeField]
        private Transform loading_bar;
        [SerializeField]
        private TMP_Text date;
        [SerializeField]
        private TMP_Text time;
        [SerializeField]
        private TMP_Text count;

        public int currentCount = 0;
        private DateTime startDate = new DateTime(2015, 6, 3, 0, 0, 0);
        private DateTime lastDate = new DateTime(2015, 6, 3, 0, 0, 0);

        // Use this for initialization
        void Start()
        {
            if (encodedGeoJSON != null)
            {
                StartCoroutine(LoadAndParse(encodedGeoJSON.text));
            }
            if (!loadUI || !loading_bar || !date || !time || !count)
            {
                Debug.LogWarning("UI Elements not set");
            } else
            {
                loading_bar.localScale = new Vector3(0f, 1f, 1f);
                date.text = startDate.Day + "." + startDate.Month + "." + startDate.Year;
                time.text = startDate.Hour.ToString("00") + ":" + startDate.Minute.ToString("00");
                count.text = currentCount.ToString();
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

            while (!routesInitialized)
            {
                yield return null;
            }

            //Debug.Log("Start animating route game object - " + Time.time);
            yield return StartCoroutine(AnimateRouteGameObjects());
            //Debug.Log("Finished animating route game object - " + Time.time);
        }

        private IEnumerator LoadJSON(string txt)
        {
            //Debug.Log("Enter LoadJSON");
            Collection = GeoJSONObject.Deserialize(txt);
            yield return loadedJSON = true;
            //Debug.Log("Exit LoadJSON");
        }

        private IEnumerator GetFeatures(FeatureCollection coll)
        {
            int collCount = coll.features.Count;
            routesDict = new SortedDictionary<DateTime, List<GameObject>>();

            int idx = 0;
            //Debug.Log("Enter GetFeatures");
            foreach (FeatureObject obj in coll.features)
            {
                StartCoroutine(GetFeatureObject(obj, idx, collCount));
                idx++;
                yield return null;
            }
            loading_bar.localScale = new Vector3(1f, 1f, 1f);
            routesInitialized = true;
            loadUI.SetActive(false);
            //Debug.Log("Exit GetFeatures");
        }

        private IEnumerator GetFeatureObject(FeatureObject obj, int idx, int collCount)
        {
            // get bikeId
            string bikeId = "";
            if (obj.properties.TryGetValue("bikeId", out bikeId))
            {
                // Debug.Log("FeatureObject: " + bikeId);
            }

            // get fromStationId
            string fromStationId = "";
            if (obj.properties.TryGetValue("fromStationId", out fromStationId))
            {
                // Debug.Log("FeatureObject: " + fromStationId);
            }

            // get toStationId
            string toStationId = "";
            if (obj.properties.TryGetValue("toStationId", out toStationId))
            {
                // Debug.Log("FeatureObject: " + toStationId);
            }

            // get fromTime
            string fromTime = "";
            if (obj.properties.TryGetValue("fromTime", out fromTime))
            {
                // Debug.Log("FeatureObject: " + System.DateTime.Parse(fromTime));
            }

            // get toTime
            string toTime = "";
            if (obj.properties.TryGetValue("toTime", out toTime))
            {
                // Debug.Log("FeatureObject: " + System.DateTime.Parse(toTime));
            }

            // get coordinates
            GeoJSON.LineStringGeometryObject geomLines = (LineStringGeometryObject)obj.geometry;

            StartCoroutine(CreateRouteGameObject(geomLines.coordinates, bikeId, System.DateTime.Parse(fromTime), System.DateTime.Parse(toTime), idx));

            float fill = idx / (float)collCount;
            loading_bar.localScale = new Vector3(fill, 1f, 1f);
            
            //Debug.Log("Fill amount " + fill.ToString() + " idx " + idx + " / collCount " + collCount);

            yield return null;
        }

        private IEnumerator CreateRouteGameObject(List<PositionObject> coords, string bikeId, DateTime fromTime, DateTime toTime, int idx) {

            if (coords.Count > 1)
            {
                List<Vector3> vertices = new List<Vector3>();

                for (int i = 0; i < coords.Count; i++)
                {
                    vertices.Add(Quaternion.AngleAxis(coords[i].longitude, -Vector3.up) * Quaternion.AngleAxis(-coords[i].latitude, -Vector3.right) * new Vector3(0, 0, -6371.0f));
                }

                // build LineRenderer go
                GameObject go = GameObject.Instantiate(prefabToGenerate, Vector3.zero, Quaternion.identity);
                go.SetActive(false);
                go.name = "_bike_" + bikeId;
                // add to worldRoot and position
                go.transform.parent = worldRoot.transform;

                // reset position, rotation and scale to local 0
                go.transform.localPosition = Vector3.zero;
                go.transform.LookAt(2 * go.transform.position - worldRoot.transform.position);
                go.transform.localScale = Vector3.one * 0.01f;

                Bike bikeComponent = go.AddComponent<Bike>();

                bikeComponent.Init(bikeId, vertices, fromTime, toTime, SPEEDUP_FACTOR);

                // add current route to sorted dictionary
                if (routesDict.ContainsKey(fromTime))
                {
                    List<GameObject> goList;
                    if (routesDict.TryGetValue(fromTime, out goList))
                    {
                        goList.Add(go);
                    }
                }
                else
                {
                    List<GameObject> goList = new List<GameObject>();
                    goList.Add(go);
                    routesDict.Add(fromTime, goList);
                }

                // store current route termination time
                lastDate = new DateTime(Math.Max(lastDate.Ticks, toTime.Ticks));
            }

            yield return null;
        }

        private IEnumerator AnimateRouteGameObjects()
        {
            //Debug.Log("Enter AnimateRouteGameObjects");
            //Debug.Log("Going from " + startDate + " to " + lastDate);

            DateTime currentTime = startDate;

            foreach (KeyValuePair<DateTime, List<GameObject>> route in routesDict)
            {
                while (currentTime < route.Key)
                {
                    currentTime = currentTime.AddSeconds(Time.deltaTime * SPEEDUP_FACTOR);
                    time.text = currentTime.Hour.ToString("00") + ":" + currentTime.Minute.ToString("00");
                    yield return null;
                }
                foreach (GameObject go in route.Value)
                {
                    go.SetActive(true);
                    Bike compBike = go.GetComponent<Bike>();
                    StartCoroutine(compBike.AnimateAlongPath());
                    count.text = currentCount++.ToString();
                }
            }

            // continue to animate time through the rest of the day
            while (currentTime < startDate.AddDays(1))
            {
                currentTime = currentTime.AddSeconds(Time.deltaTime * SPEEDUP_FACTOR);
                time.text = currentTime.Hour.ToString("00") + ":" + currentTime.Minute.ToString("00");
            }
        }
    }
}