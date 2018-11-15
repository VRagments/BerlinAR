using System.Collections;
using UnityEngine;
using GeoJSON;

namespace BerlinAR.XR
{
    public class BikeStationsRenderer : MonoBehaviour
    {

        // offset
        private float _LonOrigin = 52.5161f;
        private float _LatOrigin = 13.3770f;

        // where to attach the pins to and get offset and scale
        [SerializeField]
        public GameObject worldRoot;

        // the geojson data source
        [SerializeField]
        public TextAsset encodedGeoJSON;

        // prefab to use for visualization
        [SerializeField]
        private GameObject prefabToGenerate;

        public FeatureCollection Collection { get; private set; }

        private bool loadedJSON = false;

        // Use this for initialization
        void Start()
        {
            if (encodedGeoJSON != null)
            {
                StartCoroutine(LoadAndParse(encodedGeoJSON.text));
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
            coll.features.ForEach(GetFeatureObject);
            yield return coll;
        }

        private void GetFeatureObject(FeatureObject obj)
        {
            // get name
            string propName = "";
            if (obj.properties.TryGetValue("name", out propName))
            {
                // Debug.Log("FeatureObject: " + propName);
            }

            // get id
            string id = "";
            if (obj.properties.TryGetValue("id", out id))
            {
                // Debug.Log("FeatureObject: " + id);
            }

            // get coordinates
            GeoJSON.SingleGeometryObject geomCoords = (SingleGeometryObject)obj.geometry;
            Vector3 stationPosition = Quaternion.AngleAxis(geomCoords.coordinates.longitude, -Vector3.up) * Quaternion.AngleAxis(-geomCoords.coordinates.latitude, -Vector3.right) * new Vector3(0, 0, -6371.375f);
            //Vector3 stationPosition = new Vector3(geomLon.coordinates.longitude, geomLon.coordinates.latitude, -0.0125f);

            // create object at identity position
            GameObject stationObject = Instantiate<GameObject>(prefabToGenerate, Vector3.zero, Quaternion.Euler(new Vector3(0, 0, 0)));

            // add to worldRoot and position
            stationObject.transform.parent = worldRoot.transform;
            // reset position
            stationObject.transform.localPosition = Vector3.zero;
            stationObject.transform.localScale = Vector3.Scale(Vector3.one, new Vector3(0.1f, 0.1f, 0.1f));
            // Debug.Log(stationObject.transform.localPosition);
            // set scaled position
            stationObject.transform.localPosition = stationPosition;
            stationObject.transform.LookAt(2 * stationObject.transform.position - worldRoot.transform.position);
            // Debug.Log(stationObject.transform.localPosition);
        }
    }
}